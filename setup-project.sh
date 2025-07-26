#!/bin/bash

# AWS DevOps Project Setup Script
# This script helps you set up the complete AWS DevOps pipeline

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 AWS DevOps Pipeline Setup${NC}"
echo "==============================="
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
    fi
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"
echo

prerequisites_met=true

# Check AWS CLI
if command_exists aws; then
    print_status "AWS CLI installed" 0
    aws_version=$(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)
    echo "   Version: $aws_version"
else
    print_status "AWS CLI not found" 1
    prerequisites_met=false
fi

# Check Terraform
if command_exists terraform; then
    print_status "Terraform installed" 0
    tf_version=$(terraform version | head -n1 | cut -d'v' -f2)
    echo "   Version: v$tf_version"
else
    print_status "Terraform not found" 1
    prerequisites_met=false
fi

# Check Go
if command_exists go; then
    print_status "Go installed" 0
    go_version=$(go version | cut -d' ' -f3)
    echo "   Version: $go_version"
else
    print_status "Go not found" 1
    prerequisites_met=false
fi

# Check Docker
if command_exists docker; then
    print_status "Docker installed" 0
    docker_version=$(docker --version | cut -d' ' -f3 | tr -d ',')
    echo "   Version: $docker_version"
else
    print_status "Docker not found" 1
    prerequisites_met=false
fi

# Check Node.js
if command_exists node; then
    print_status "Node.js installed" 0
    node_version=$(node --version)
    echo "   Version: $node_version"
else
    print_status "Node.js not found" 1
    prerequisites_met=false
fi

echo

if [ "$prerequisites_met" = false ]; then
    echo -e "${RED}❌ Some prerequisites are missing. Please install them before continuing.${NC}"
    echo -e "${YELLOW}📖 See PROJECT-GUIDE.md for installation instructions.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are installed!${NC}"
echo

# Check AWS configuration
echo -e "${YELLOW}🔐 Checking AWS configuration...${NC}"
if aws sts get-caller-identity >/dev/null 2>&1; then
    print_status "AWS credentials configured" 0
    aws_account=$(aws sts get-caller-identity --query Account --output text)
    aws_user=$(aws sts get-caller-identity --query Arn --output text | cut -d'/' -f2)
    echo "   Account: $aws_account"
    echo "   User: $aws_user"
else
    print_status "AWS credentials not configured" 1
    echo -e "${YELLOW}Please run 'aws configure' to set up your credentials.${NC}"
    exit 1
fi

echo

# Setup project configuration
echo -e "${YELLOW}⚙️ Setting up project configuration...${NC}"

# Create terraform.tfvars if it doesn't exist
if [ ! -f "terraform/terraform.tfvars" ]; then
    echo "Creating terraform/terraform.tfvars..."
    
    read -p "Enter your project name (default: aws-devops): " project_name
    project_name=${project_name:-aws-devops}
    
    read -p "Enter your GitHub username: " github_owner
    
    read -p "Enter your GitHub repository name: " github_repo
    
    read -p "Enter your GitHub personal access token: " github_token
    
    read -p "Enter your SSH public key: " public_key
    
    read -p "Enter allowed IP range (default: 0.0.0.0/0): " allowed_ip_range
    allowed_ip_range=${allowed_ip_range:-0.0.0.0/0}
    
    read -p "Enter AWS region (default: us-east-1): " aws_region
    aws_region=${aws_region:-us-east-1}
    
    cat > terraform/terraform.tfvars << EOF
aws_region = "$aws_region"
project_name = "$project_name"
github_owner = "$github_owner"
github_repo = "$github_repo"
github_token = "$github_token"
allowed_ip_range = "$allowed_ip_range"
public_key = "$public_key"
EOF
    
    print_status "Created terraform/terraform.tfvars" 0
else
    print_status "terraform/terraform.tfvars already exists" 0
fi

echo

# Install Go dependencies
echo -e "${YELLOW}📦 Installing Go dependencies...${NC}"
cd tests
if go mod tidy; then
    print_status "Go dependencies installed" 0
else
    print_status "Failed to install Go dependencies" 1
fi
cd ..

echo

# Install Node.js dependencies
echo -e "${YELLOW}📦 Installing Node.js dependencies...${NC}"
cd app
if npm install; then
    print_status "Node.js dependencies installed" 0
else
    print_status "Failed to install Node.js dependencies" 1
fi
cd ..

echo

# Validate Terraform configuration
echo -e "${YELLOW}🔍 Validating Terraform configuration...${NC}"
cd terraform
if terraform init && terraform validate; then
    print_status "Terraform configuration valid" 0
else
    print_status "Terraform configuration has issues" 1
fi
cd ..

echo

# Run application tests
echo -e "${YELLOW}🧪 Running application tests...${NC}"
cd app
if npm test; then
    print_status "Application tests passed" 0
else
    print_status "Application tests failed" 1
fi
cd ..

echo

# Summary
echo -e "${BLUE}📋 Setup Summary${NC}"
echo "================="
echo -e "${GREEN}✅ Project is ready for deployment!${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review terraform/terraform.tfvars for your configuration"
echo "2. Set up GitHub repository secrets (see PROJECT-GUIDE.md)"
echo "3. Deploy infrastructure: cd terraform && terraform apply"
echo "4. Push code to GitHub to trigger CI/CD pipeline"
echo
echo -e "${YELLOW}📖 For detailed instructions, see PROJECT-GUIDE.md${NC}"
echo -e "${YELLOW}🔧 For troubleshooting, check the logs and documentation${NC}"
echo
