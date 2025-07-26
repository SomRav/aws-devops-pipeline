#!/bin/bash

# Update the system
yum update -y

# Install Node.js and npm
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install Docker
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install CodeDeploy agent
yum install -y ruby
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto

echo "Dependencies installed successfully"
