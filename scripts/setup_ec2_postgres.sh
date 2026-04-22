#!/bin/bash
# =============================================================================
# EC2 PostgreSQL Setup Script
# Run this ON your EC2 instance after SSH-ing in.
# Tested on: Ubuntu 22.04 LTS (t3.micro / t4g.small)
# =============================================================================

set -e  # exit on any error

echo "=== [1/5] Updating system packages ==="
sudo apt-get update -y && sudo apt-get upgrade -y

echo "=== [2/5] Installing PostgreSQL 15 ==="
sudo apt-get install -y postgresql-15 postgresql-client-15

echo "=== [3/5] Starting and enabling PostgreSQL service ==="
sudo systemctl enable postgresql
sudo systemctl start postgresql

echo "=== [4/5] Creating DB user and database ==="
# These values must match your Lambda env vars (DB_USER, DB_PASSWORD, DB_NAME)
DB_USER="pokeuser"
DB_PASSWORD="YourStrongPassword123!"   # <-- CHANGE THIS
DB_NAME="pokedex"

sudo -u postgres psql <<EOF
-- Create user
DO \$\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USER}') THEN
      CREATE ROLE ${DB_USER} WITH LOGIN PASSWORD '${DB_PASSWORD}';
   END IF;
END
\$\$;

-- Create database
SELECT 'CREATE DATABASE ${DB_NAME} OWNER ${DB_USER}'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${DB_NAME}')\gexec

GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
EOF

echo "=== [5/5] Running Pokémon schema SQL ==="
# Copy poke_db.sql to the EC2 instance before running this script.
# scp -i your-key.pem poke_db.sql ubuntu@<EC2_PUBLIC_IP>:~/poke_db.sql
sudo -u postgres psql -d ${DB_NAME} -f ~/poke_db.sql

echo ""
echo "✅ PostgreSQL setup complete!"
echo ""
echo "Next steps:"
echo "  1. Edit /etc/postgresql/15/main/postgresql.conf and set:"
echo "       listen_addresses = '*'"
echo "  2. Edit /etc/postgresql/15/main/pg_hba.conf and add (for Lambda VPC CIDR):"
echo "       host  ${DB_NAME}  ${DB_USER}  10.0.0.0/16  md5"
echo "  3. Restart: sudo systemctl restart postgresql"
echo "  4. EC2 Security Group: Allow inbound TCP 5432 from Lambda's Security Group"
