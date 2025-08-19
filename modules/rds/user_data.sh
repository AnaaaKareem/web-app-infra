#!/bin/bash
sudo apt update -y
sudo apt install -y mysql jq awscli

SECRET=$(aws secretsmanager get-secret-value --secret-id rds-mysql-secret --query SecretString --output text --region ${AWS_REGION})
USERNAME=$(echo $SECRET | jq -r '.username')
PASSWORD=$(echo $SECRET | jq -r '.password')
HOST=$(echo $SECRET | jq -r '.host')
DBNAME=$(echo $SECRET | jq -r '.dbname')

sudo mysql -h $HOST -u $USERNAME -p $PASSWORD $DBNAME <<EOF
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);
INSERT INTO users (name) VALUES ('Karim Khater');
EOF