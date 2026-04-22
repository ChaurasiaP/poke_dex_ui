import os
import boto3
import time
import json

def main():
    print("Initializing AWS RDS Deployment...")
    rds = boto3.client('rds', region_name=os.environ.get('AWS_DEFAULT_REGION', 'ap-south-1'))
    ec2 = boto3.client('ec2', region_name=os.environ.get('AWS_DEFAULT_REGION', 'ap-south-1'))
    
    db_name = 'pokedex'
    db_instance_id = 'pokedex-db'
    db_user = 'postgres'
    db_password = 'PokedexPassword123!'
    
    # Check if instance already exists
    try:
        instances = rds.describe_db_instances(DBInstanceIdentifier=db_instance_id)
        if instances['DBInstances']:
            instance = instances['DBInstances'][0]
            print(f"Database instance {db_instance_id} already exists with status: {instance['DBInstanceStatus']}")
            if instance['DBInstanceStatus'] == 'available':
                print(f"Endpoint: {instance['Endpoint']['Address']}")
            return
    except rds.exceptions.DBInstanceNotFoundFault:
        pass

    # Create Security Group allowing all inbound to 5432
    print("Getting default VPC...")
    vpcs = ec2.describe_vpcs(Filters=[{'Name': 'is-default', 'Values': ['true']}])
    vpc_id = vpcs['Vpcs'][0]['VpcId']
    
    sg_name = 'pokedex-db-sg'
    try:
        print(f"Creating Security Group {sg_name}...")
        sg = ec2.create_security_group(GroupName=sg_name, Description='Allow Postgres access for Pokedex API', VpcId=vpc_id)
        sg_id = sg['GroupId']
        print(f"Security Group created: {sg_id}")
        
        # Add inbound rule
        ec2.authorize_security_group_ingress(
            GroupId=sg_id,
            IpPermissions=[
                {'IpProtocol': 'tcp',
                 'FromPort': 5432,
                 'ToPort': 5432,
                 'IpRanges': [{'CidrIp': '0.0.0.0/0'}]}
            ]
        )
    except Exception as e:
        if 'InvalidGroup.Duplicate' in str(e):
            print("Security Group already exists. Fetching its ID.")
            sgs = ec2.describe_security_groups(Filters=[{'Name': 'group-name', 'Values': [sg_name]}])
            sg_id = sgs['SecurityGroups'][0]['GroupId']
        else:
            raise

    # Create RDS Instance
    print(f"Creating RDS instance {db_instance_id} (this will take several minutes)...")
    try:
        response = rds.create_db_instance(
            DBName=db_name,
            DBInstanceIdentifier=db_instance_id,
            AllocatedStorage=20,
            DBInstanceClass='db.t3.micro',
            Engine='postgres',
            MasterUsername=db_user,
            MasterUserPassword=db_password,
            VpcSecurityGroupIds=[sg_id],
            PubliclyAccessible=True,
            BackupRetentionPeriod=0,
            MultiAZ=False
        )
        print("Create command sent successfully. Waiting for instance to become available...")
        
        waiter = rds.get_waiter('db_instance_available')
        waiter.wait(
            DBInstanceIdentifier=db_instance_id,
            WaiterConfig={'Delay': 30, 'MaxAttempts': 40} # up to 20 mins
        )
        
        # Get endpoint
        instances = rds.describe_db_instances(DBInstanceIdentifier=db_instance_id)
        endpoint = instances['DBInstances'][0]['Endpoint']['Address']
        print(f"\n✅ Database created successfully!")
        print(f"Endpoint: {endpoint}")
        
        # Save endpoint to a file for later steps
        with open('rds_endpoint.txt', 'w') as f:
            f.write(endpoint)
            
    except Exception as e:
        print(f"Error creating RDS instance: {e}")

if __name__ == '__main__':
    main()
