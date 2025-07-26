#!/bin/bash

# Script to set up the project environment

echo "🚀 Setting up AWS DevOps Pipeline Environment..."

# Check if required tools are installed
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 is not installed. Please install it first."
        exit 1
    else
        echo "✅ $1 is installed"
    fi
}

echo "📋 Checking required tools..."
check_tool "terraform"
check_tool "aws"
check_tool "git"
check_tool "npm"

# Check AWS configuration
echo "🔐 Checking AWS configuration..."
if aws sts get-caller-identity &> /dev/null; then
    echo "✅ AWS CLI is configured"
    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    echo "📊 AWS Account ID: $ACCOUNT_ID"
else
    echo "❌ AWS CLI is not configured. Run 'aws configure' first."
    exit 1
fi

# Initialize terraform
echo "🏗️ Initializing Terraform..."
cd terraform
terraform init

# Validate terraform configuration
echo "✅ Validating Terraform configuration..."
terraform validate

if [ $? -eq 0 ]; then
    echo "✅ Terraform configuration is valid"
else
    echo "❌ Terraform configuration has errors"
    exit 1
fi

# Install Node.js dependencies
echo "📦 Installing Node.js dependencies..."
cd ../app
npm install

# Run tests
echo "🧪 Running application tests..."
npm test

if [ $? -eq 0 ]; then
    echo "✅ All tests passed"
else
    echo "❌ Some tests failed"
    exit 1
fi

cd ..

echo "🎉 Environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Configure your terraform.tfvars file"
echo "2. Add your GitHub secrets to the repository"
echo "3. Run 'terraform plan' to review the infrastructure"
echo "4. Run 'terraform apply' to deploy the infrastructure"
