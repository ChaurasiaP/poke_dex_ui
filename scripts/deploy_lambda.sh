#!/bin/bash
# =============================================================================
# Lambda Deployment Script
# Run this from your LOCAL machine (Windows: use Git Bash or WSL).
# Prerequisites: AWS CLI installed + configured (aws configure)
# =============================================================================

set -e

# ── Config ───────────────────────────────────────────────────────────────────
FUNCTION_NAME="pokedex-api"
REGION="us-east-1"                        # Change to your preferred region
RUNTIME="python3.11"
HANDLER="app.main.handler"
ROLE_ARN="arn:aws:iam::YOUR_ACCOUNT_ID:role/lambda-pokedex-role"  # <-- CHANGE
MEMORY=256    # MB
TIMEOUT=30    # seconds

# DB env vars — set these to your EC2 private IP and credentials
DB_HOST="10.0.1.50"          # EC2 private IPv4 (from AWS console)
DB_PORT="5432"
DB_NAME="pokedex"
DB_USER="pokeuser"
DB_PASSWORD="YourStrongPassword123!"  # <-- CHANGE

# VPC config — put Lambda in same VPC as EC2
SUBNET_IDS="subnet-xxxxxxxx,subnet-yyyyyyyy"          # <-- CHANGE
SECURITY_GROUP_IDS="sg-xxxxxxxx"                      # <-- CHANGE (Lambda SG)

PACKAGE_DIR="lambda_package"
ZIP_FILE="lambda_package.zip"

echo "=== [1/4] Installing dependencies into package dir ==="
rm -rf ${PACKAGE_DIR} ${ZIP_FILE}
pip install -r requirements.txt --target ${PACKAGE_DIR} --platform manylinux2014_x86_64 \
    --implementation cp --python-version 3.11 --only-binary=:all: --upgrade

echo "=== [2/4] Copying app source code ==="
cp -r app ${PACKAGE_DIR}/

echo "=== [3/4] Zipping package ==="
cd ${PACKAGE_DIR}
zip -r ../${ZIP_FILE} . -q
cd ..
echo "Package size: $(du -sh ${ZIP_FILE} | cut -f1)"

echo "=== [4/4] Deploying to AWS Lambda ==="
# Check if function exists
if aws lambda get-function --function-name ${FUNCTION_NAME} --region ${REGION} &>/dev/null; then
    echo "Updating existing Lambda function..."
    aws lambda update-function-code \
        --function-name ${FUNCTION_NAME} \
        --zip-file fileb://${ZIP_FILE} \
        --region ${REGION}

    aws lambda update-function-configuration \
        --function-name ${FUNCTION_NAME} \
        --region ${REGION} \
        --environment "Variables={DB_HOST=${DB_HOST},DB_PORT=${DB_PORT},DB_NAME=${DB_NAME},DB_USER=${DB_USER},DB_PASSWORD=${DB_PASSWORD}}"
else
    echo "Creating new Lambda function..."
    aws lambda create-function \
        --function-name ${FUNCTION_NAME} \
        --runtime ${RUNTIME} \
        --handler ${HANDLER} \
        --role ${ROLE_ARN} \
        --zip-file fileb://${ZIP_FILE} \
        --memory-size ${MEMORY} \
        --timeout ${TIMEOUT} \
        --region ${REGION} \
        --vpc-config SubnetIds=${SUBNET_IDS},SecurityGroupIds=${SECURITY_GROUP_IDS} \
        --environment "Variables={DB_HOST=${DB_HOST},DB_PORT=${DB_PORT},DB_NAME=${DB_NAME},DB_USER=${DB_USER},DB_PASSWORD=${DB_PASSWORD}}"
fi

echo ""
echo "✅ Lambda deployed successfully!"
echo ""
echo "Next step: Set up API Gateway HTTP API targeting this Lambda function."
echo "  → AWS Console → API Gateway → Create HTTP API → Lambda integration → ${FUNCTION_NAME}"
echo "  → Route: ANY /{proxy+} → Lambda"
