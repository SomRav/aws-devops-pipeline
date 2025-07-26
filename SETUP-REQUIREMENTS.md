# 📋 Complete Setup Requirements for AWS DevOps Pipeline

## 🔧 Required Software Installation

### **1. Essential Tools (MUST HAVE)**

#### **AWS CLI v2**
- **Purpose**: Interact with AWS services
- **Install**: https://aws.amazon.com/cli/
- **Windows**: Download MSI installer
- **Verify**: `aws --version`

#### **Terraform >= 1.0**
- **Purpose**: Infrastructure as Code
- **Install**: https://www.terraform.io/downloads
- **Windows**: Download ZIP, extract to PATH
- **Verify**: `terraform version`

#### **Node.js 18 LTS**
- **Purpose**: Application runtime and npm packages
- **Install**: https://nodejs.org/
- **Windows**: Download MSI installer
- **Verify**: `node --version` and `npm --version`

#### **Docker Desktop**
- **Purpose**: Container building and testing
- **Install**: https://www.docker.com/products/docker-desktop
- **Windows**: Download installer and enable WSL2
- **Verify**: `docker --version`

#### **Git**
- **Purpose**: Version control
- **Install**: https://git-scm.com/
- **Windows**: Download installer with Git Bash
- **Verify**: `git --version`

### **2. Optional Tools (RECOMMENDED)**

#### **kubectl**
- **Purpose**: Kubernetes cluster management
- **Install**: https://kubernetes.io/docs/tasks/tools/
- **Verify**: `kubectl version --client`

#### **kubeseal**
- **Purpose**: Sealed Secrets creation
- **Install**: https://github.com/bitnami-labs/sealed-secrets/releases
- **Windows**: Download binary and add to PATH

#### **Go >= 1.19**
- **Purpose**: Running Terratest
- **Install**: https://golang.org/dl/
- **Verify**: `go version`

## 🔐 Required Accounts and Credentials

### **1. AWS Account Setup**
- **Create AWS Account**: https://aws.amazon.com/
- **IAM User with permissions**:
  - AdministratorAccess (for full setup)
  - Or specific policies for CodePipeline, CodeBuild, CodeDeploy, EC2, S3, ECR, IAM
- **AWS Access Keys**: Access Key ID and Secret Access Key
- **Configure**: Run `aws configure`

### **2. GitHub Account Setup**
- **GitHub Account**: https://github.com/
- **Personal Access Token**:
  - Go to Settings > Developer settings > Personal access tokens
  - Generate token with permissions: `repo`, `admin:repo_hook`
  - Save the token securely

### **3. SSH Key Pair**
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# View public key (copy this content)
cat ~/.ssh/id_rsa.pub
```

## 🏗️ Project Configuration

### **1. Edit terraform/terraform.tfvars**
```hcl
# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "dp"  # Change if needed

# GitHub Configuration
github_owner = "SomRav"  # Your GitHub username
github_repo = "aws-devops"  # Your repository name
github_token = "ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"  # Your GitHub token

# Network Configuration
allowed_ip_range = "YOUR_PUBLIC_IP/32"  # Find with: curl ifconfig.me

# SSH Configuration
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7..."  # Your SSH public key
```

### **2. Set GitHub Repository Secrets**
Go to GitHub repo Settings > Secrets and variables > Actions:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key
- `EC2_PUBLIC_KEY`: Your SSH public key content

### **3. Find Your Public IP**
```bash
# Find your public IP
curl ifconfig.me

# Use it as: YOUR_IP/32 (e.g., 203.0.113.1/32)
```

## 🚀 Deployment Steps

### **Step 1: Initialize and Install Dependencies**
```bash
# Clone/navigate to project
cd aws-devops

# Make setup script executable (if on Linux/Mac)
chmod +x check-setup.sh

# Run setup checker
./check-setup.sh

# Install Node.js dependencies
cd app
npm install
cd ..

# Initialize Terraform
cd terraform
terraform init
cd ..
```

### **Step 2: Configure Variables**
1. Edit `terraform/terraform.tfvars` with your values
2. Set GitHub repository secrets
3. Ensure your IP is in `allowed_ip_range`

### **Step 3: Deploy Infrastructure**
```bash
cd terraform

# Review what will be created
terraform plan

# Apply the infrastructure
terraform apply

# Note the outputs (save these URLs)
```

### **Step 4: Verify Deployment**
- Check AWS Console for CodePipeline
- Visit the application URL from Terraform outputs
- Monitor the pipeline execution

## 🧪 Testing Setup

### **Application Tests**
```bash
cd app
npm test
```

### **Infrastructure Tests (Terratest)**
```bash
cd tests
go mod init aws-devops-tests
go mod tidy
go test -v -timeout 30m
```

### **Security Scans**
```bash
# Install tfsec (optional local testing)
# Windows: Download from https://github.com/aquasecurity/tfsec/releases
tfsec terraform/

# Docker image scan (optional local testing)
docker build -f docker/Dockerfile -t test-app .
trivy image test-app
```

## ⚠️ Common Issues and Solutions

### **1. Terraform State Issues**
```bash
# If state is corrupted
terraform refresh
terraform import aws_instance.app_server i-xxxxxxxxx
```

### **2. Docker Issues on Windows**
- Enable WSL2 in Docker Desktop
- Ensure Docker daemon is running
- Check Docker Desktop settings

### **3. AWS Permissions**
- Ensure IAM user has required permissions
- Check AWS credential configuration: `aws sts get-caller-identity`

### **4. GitHub Token Issues**
- Token must have `repo` and `admin:repo_hook` permissions
- Check token expiry
- Regenerate if needed

### **5. SSH Key Format**
- Must be OpenSSH format starting with `ssh-rsa`
- No line breaks in terraform.tfvars
- Include the email part at the end

## 🧹 Cleanup

### **Destroy All Resources**
```bash
cd terraform
terraform destroy
```

## 📞 Quick Start Checklist

- [ ] Install AWS CLI and configure credentials
- [ ] Install Terraform
- [ ] Install Node.js and npm
- [ ] Install Docker Desktop
- [ ] Create GitHub Personal Access Token
- [ ] Generate SSH key pair
- [ ] Find your public IP address
- [ ] Edit terraform/terraform.tfvars
- [ ] Set GitHub repository secrets
- [ ] Run terraform init
- [ ] Run terraform apply
- [ ] Test the deployed application

**Estimated Setup Time**: 30-60 minutes (depending on download speeds)

Run the setup checker script to verify your environment:
```bash
./check-setup.sh
```
