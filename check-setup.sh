#!/bin/bash

# AWS DevOps Pipeline Setup Script
# This script helps you set up all required tools and configurations

set -e

echo "🚀 AWS DevOps Pipeline Setup"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if running on Windows (Git Bash)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    echo "Detected Windows environment"
    IS_WINDOWS=true
else
    IS_WINDOWS=false
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "📋 Checking Prerequisites..."
echo

# Check AWS CLI
if command_exists aws; then
    print_status "AWS CLI is installed"
    aws --version
else
    print_error "AWS CLI is not installed"
    echo "Install from: https://aws.amazon.com/cli/"
    if [ "$IS_WINDOWS" = true ]; then
        echo "For Windows: Download and run the MSI installer"
    else
        echo "For Linux/Mac: curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && unzip awscliv2.zip && sudo ./aws/install"
    fi
fi

# Check Terraform
if command_exists terraform; then
    print_status "Terraform is installed"
    terraform version
else
    print_error "Terraform is not installed"
    echo "Install from: https://www.terraform.io/downloads"
    if [ "$IS_WINDOWS" = true ]; then
        echo "For Windows: Download the zip file and add to PATH"
    else
        echo "For Linux/Mac: Use package manager or download binary"
    fi
fi

# Check Node.js
if command_exists node; then
    print_status "Node.js is installed"
    node --version
    npm --version
else
    print_error "Node.js is not installed"
    echo "Install from: https://nodejs.org/"
    echo "Recommended: Node.js 18 LTS"
fi

# Check Docker
if command_exists docker; then
    print_status "Docker is installed"
    docker --version
else
    print_error "Docker is not installed"
    echo "Install from: https://www.docker.com/products/docker-desktop"
fi

# Check kubectl
if command_exists kubectl; then
    print_status "kubectl is installed"
    kubectl version --client
else
    print_warning "kubectl is not installed (optional for Kubernetes features)"
    echo "Install from: https://kubernetes.io/docs/tasks/tools/"
fi

# Check kubeseal
if command_exists kubeseal; then
    print_status "kubeseal is installed"
else
    print_warning "kubeseal is not installed (optional for Sealed Secrets)"
    echo "Install from: https://github.com/bitnami-labs/sealed-secrets/releases"
fi

# Check Git
if command_exists git; then
    print_status "Git is installed"
    git --version
else
    print_error "Git is not installed"
    echo "Install from: https://git-scm.com/"
fi

# Check Go (for Terratest)
if command_exists go; then
    print_status "Go is installed"
    go version
else
    print_warning "Go is not installed (needed for Terratest)"
    echo "Install from: https://golang.org/dl/"
fi

echo
echo "🔧 Configuration Checks..."
echo

# Check AWS credentials
if aws sts get-caller-identity >/dev/null 2>&1; then
    print_status "AWS credentials are configured"
    aws sts get-caller-identity
else
    print_error "AWS credentials are not configured"
    echo "Run: aws configure"
    echo "You'll need:"
    echo "  - AWS Access Key ID"
    echo "  - AWS Secret Access Key"
    echo "  - Default region (e.g., us-east-1)"
fi

echo
echo "📁 Project Setup..."
echo

# Install Node.js dependencies
if [ -f "app/package.json" ]; then
    echo "Installing Node.js dependencies..."
    cd app
    npm install
    cd ..
    print_status "Node.js dependencies installed"
else
    print_warning "app/package.json not found"
fi

# Initialize Terraform
if [ -d "terraform" ]; then
    echo "Initializing Terraform..."
    cd terraform
    terraform init
    cd ..
    print_status "Terraform initialized"
else
    print_warning "terraform directory not found"
fi

echo
echo "🔐 Required Secrets and Tokens..."
echo

echo "You need to obtain the following:"
echo "1. GitHub Personal Access Token:"
echo "   - Go to GitHub Settings > Developer settings > Personal access tokens"
echo "   - Generate new token with 'repo' and 'admin:repo_hook' permissions"
echo
echo "2. SSH Key Pair:"
echo "   - Generate: ssh-keygen -t rsa -b 4096 -C 'your-email@example.com'"
echo "   - Copy the public key content from ~/.ssh/id_rsa.pub"
echo
echo "3. Your Public IP (for security group):"
echo "   - Find your IP: curl ifconfig.me"
echo "   - Format as CIDR: YOUR_IP/32"
echo

echo "📝 Next Steps..."
echo

echo "1. Edit terraform/terraform.tfvars with your values:"
echo "   github_token = \"your-github-token\""
echo "   public_key = \"ssh-rsa AAAAB3NzaC1yc2E...\""
echo "   allowed_ip_range = \"YOUR_IP/32\""
echo
echo "2. Set up GitHub repository secrets:"
echo "   - AWS_ACCESS_KEY_ID"
echo "   - AWS_SECRET_ACCESS_KEY"
echo "   - EC2_PUBLIC_KEY"
echo
echo "3. Deploy infrastructure:"
echo "   cd terraform"
echo "   terraform plan"
echo "   terraform apply"
echo

echo "🎉 Setup script completed!"
echo "Check the output above for any missing requirements."
