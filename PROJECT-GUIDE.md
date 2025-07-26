# AWS DevOps Pipeline Project - Complete Guide

## Project Overview

This project implements a complete AWS DevOps pipeline using Terraform for infrastructure as code, AWS CodePipeline for CI/CD, and Kubernetes with Sealed Secrets for secure deployments. The project includes DevSecOps practices with security scanning using tfsec and Trivy.

## Project Structure

```
aws-devops/
├── .github/
│   └── workflows/
│       └── ci-cd.yml                # GitHub Actions workflow
├── app/
│   ├── package.json                 # Node.js app dependencies
│   ├── server.js                    # Express.js application
│   └── server.test.js               # Unit tests
├── docker/
│   └── Dockerfile                   # Container configuration
├── k8s/
│   ├── deployment.yaml              # Kubernetes deployment
│   └── sealed-secret.yaml           # Encrypted secrets
├── scripts/
│   ├── create-sealed-secrets.sh     # Script to generate sealed secrets
│   ├── install_dependencies.sh      # CodeDeploy script
│   ├── start_application.sh         # CodeDeploy script
│   └── stop_application.sh          # CodeDeploy script
├── terraform/
│   ├── main.tf                      # Main Terraform configuration
│   ├── variables.tf                 # Input variables
│   ├── outputs.tf                   # Output values
│   └── terraform.tfvars             # Variable values
├── tests/
│   ├── go.mod                       # Go module for Terratest
│   └── main_test.go                 # Infrastructure tests
├── appspec.yml                      # CodeDeploy configuration
├── buildspec.yml                    # CodeBuild configuration
└── README.md                        # This file
```

## Step-by-Step Setup Guide

### Prerequisites

1. **AWS Account** with appropriate permissions
2. **GitHub Account** and repository
3. **Local Development Environment**:
   - AWS CLI configured
   - Terraform >= 1.0
   - Go >= 1.21 (for Terratest)
   - Docker
   - kubectl
   - Node.js >= 18

### Step 1: Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, and region
```

### Step 2: Set Up Terraform Variables

Create a `terraform.tfvars` file:

```hcl
aws_region = "us-east-1"
project_name = "your-project-name"
github_owner = "your-github-username"
github_repo = "your-repository-name"
github_token = "your-github-token"
allowed_ip_range = "0.0.0.0/0"  # Restrict this in production
public_key = "your-ssh-public-key"
```

### Step 3: Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Step 4: Set Up GitHub Secrets

Add these secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `GITHUB_TOKEN`
- `SSH_PUBLIC_KEY`
- `ECR_REPOSITORY` (from Terraform output)
- `EKS_CLUSTER_NAME` (if using EKS)
- `PROJECT_NAME`
- `ALLOWED_IP_RANGE`

### Step 5: Generate Sealed Secrets (if using Kubernetes)

```bash
chmod +x scripts/create-sealed-secrets.sh
./scripts/create-sealed-secrets.sh
```

### Step 6: Run Tests

```bash
# Terraform tests
cd tests
go test -v -timeout 30m

# Application tests
cd ../app
npm install
npm test
```

## DevSecOps Features

### Security Scanning

1. **Terraform Security (tfsec)**:
   - Scans Terraform code for security issues
   - Runs automatically in GitHub Actions
   - Results uploaded to GitHub Security tab

2. **Container Security (Trivy)**:
   - Scans Docker images for vulnerabilities
   - Checks for known CVEs
   - Integrated into CI/CD pipeline

### Sealed Secrets

- Encrypts Kubernetes secrets using public-key cryptography
- Secrets can only be decrypted by the Sealed Secrets controller in the cluster
- Safe to store encrypted secrets in Git

## AWS Resources Created

### Core Infrastructure
- **S3 Bucket**: Stores CodePipeline artifacts
- **ECR Repository**: Stores Docker images
- **IAM Roles & Policies**: Secure service permissions

### CI/CD Pipeline
- **CodePipeline**: Orchestrates the entire CI/CD workflow
- **CodeBuild**: Builds and tests the application
- **CodeDeploy**: Deploys to EC2 instances

### Compute & Networking
- **VPC**: Isolated network environment
- **Subnets**: Public and private subnets
- **Security Groups**: Network access control
- **EC2 Instance**: Application hosting
- **Application Load Balancer**: Distributes traffic

## Workflow Explanation

### GitHub Actions Pipeline

1. **Security Scans**: 
   - tfsec scans Terraform code
   - Trivy scans Docker images

2. **Testing**:
   - Terraform validation and formatting
   - Terratest infrastructure tests
   - Node.js application tests

3. **Deployment** (on main branch):
   - Deploy infrastructure with Terraform
   - Build and push Docker images
   - Deploy to Kubernetes with sealed secrets

### AWS CodePipeline

1. **Source Stage**: Pulls code from GitHub
2. **Build Stage**: Uses CodeBuild to:
   - Install dependencies
   - Run tests
   - Build Docker image
   - Push to ECR
3. **Deploy Stage**: Uses CodeDeploy to deploy to EC2

## Monitoring and Troubleshooting

### Viewing Pipeline Status
- **GitHub Actions**: Check the Actions tab in your repository
- **AWS CodePipeline**: Visit AWS Console → CodePipeline
- **Application Logs**: Check CloudWatch Logs

### Common Issues and Solutions

1. **GitHub Token Permissions**:
   - Ensure token has `repo` and `workflow` permissions

2. **AWS Permissions**:
   - Verify IAM user has necessary permissions for all services

3. **Terraform State**:
   - Consider using remote state storage (S3 + DynamoDB)

4. **Docker Build Issues**:
   - Check Dockerfile syntax and base image availability

## Security Best Practices Implemented

1. **Least Privilege Access**: IAM roles have minimal required permissions
2. **Encrypted Storage**: S3 buckets use server-side encryption
3. **Network Isolation**: Resources deployed in private subnets where appropriate
4. **Secret Management**: Sensitive data stored as sealed secrets
5. **Vulnerability Scanning**: Automated security scans in CI/CD
6. **Infrastructure as Code**: All infrastructure defined declaratively

## Next Steps and Enhancements

1. **Add Monitoring**:
   - CloudWatch dashboards
   - Application performance monitoring

2. **Implement Blue-Green Deployment**:
   - Zero-downtime deployments
   - Automatic rollback on failure

3. **Add Database**:
   - RDS instance with proper backup strategy
   - Database migration scripts

4. **Enhance Security**:
   - WAF for web application protection
   - VPN or bastion host for secure access

5. **Multi-Environment Support**:
   - Separate dev, staging, and production environments
   - Environment-specific configurations

## Cleanup

To avoid AWS charges, destroy the infrastructure when done:

```bash
cd terraform
terraform destroy
```

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review AWS CloudWatch logs
3. Check GitHub Actions workflow logs
4. Consult AWS documentation for specific services

---

**Note**: This project is for educational purposes. For production use, implement additional security measures, monitoring, and backup strategies.
