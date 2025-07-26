# GitHub Repository Secrets Setup

## Required Secrets for GitHub Actions

After your Terraform deployment completes, add these secrets to your GitHub repository:

### 1. AWS Credentials
- **AWS_ACCESS_KEY_ID**: Your AWS access key ID
- **AWS_SECRET_ACCESS_KEY**: Your AWS secret access key

### 2. GitHub and SSH
- **GITHUB_TOKEN**: Your GitHub personal access token
- **SSH_PUBLIC_KEY**: Your SSH public key (already in terraform.tfvars)

### 3. Project Configuration (Optional - can use defaults)
- **PROJECT_NAME**: devops-pipeline
- **ALLOWED_IP_RANGE**: 0.0.0.0/0 (or your specific IP range)

### 4. ECR Repository (Will be available after Terraform apply)
- **ECR_REPOSITORY**: devops-pipeline-app (from Terraform output)

### 5. EKS Cluster (If using Kubernetes deployment)
- **EKS_CLUSTER_NAME**: Your EKS cluster name (if you add EKS later)

## How to Add Secrets:

1. Go to https://github.com/SomRav/aws-devops-pipeline
2. Click Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add each secret name and value
5. Click "Add secret"

## Example Values:
```
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=abc123...
GITHUB_TOKEN=your-github-token
SSH_PUBLIC_KEY=ssh-rsa AAAAB3NzaC1yc2E...
PROJECT_NAME=devops-pipeline
ALLOWED_IP_RANGE=0.0.0.0/0
ECR_REPOSITORY=devops-pipeline-app
```
