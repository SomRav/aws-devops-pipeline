# AWS DevOps Pipeline with Terraform and DevSecOps

This project implements a complete AWS CodePipeline using Terraform with DevSecOps integration using GitHub Actions and Kubernetes Sealed Secrets.

## 🏗️ Architecture Overview

- **Source**: GitHub repository
- **Build**: AWS CodeBuild with Docker image creation
- **Deploy**: AWS CodeDeploy to EC2 instances
- **Security**: Integrated security scanning with tfsec and Trivy
- **Secrets Management**: Kubernetes Sealed Secrets for secure secret handling

## 📋 Prerequisites

Before you begin, ensure you have:

1. **AWS Account** with appropriate permissions
2. **GitHub Account** and repository
3. **Terraform** installed (>= 1.0)
4. **AWS CLI** configured
5. **kubectl** for Kubernetes management
6. **kubeseal** for creating sealed secrets

## 🔧 Setup Instructions

### Step 1: Configure AWS Credentials

```bash
aws configure
```

### Step 2: Generate SSH Key Pair

```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

Copy the public key content for the `public_key` variable.

### Step 3: Create GitHub Personal Access Token

1. Go to GitHub Settings > Developer settings > Personal access tokens
2. Generate a new token with `repo` and `admin:repo_hook` permissions
3. Save the token securely

### Step 4: Configure Terraform Variables

Edit `terraform/terraform.tfvars`:

```hcl
# AWS Configuration
aws_region = "us-east-1"

# Project Configuration
project_name = "your-project-name"

# GitHub Configuration
github_owner = "your-github-username"
github_repo = "your-repo-name"
github_token = "your-github-token"

# Network Configuration
allowed_ip_range = "your-ip/32"  # Your public IP for SSH access

# SSH Configuration
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAA... your-public-key"
```

### Step 5: Deploy Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Step 6: Set up GitHub Secrets

In your GitHub repository, go to Settings > Secrets and add:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key  
- `EC2_PUBLIC_KEY`: Your SSH public key

### Step 7: Set up Sealed Secrets (Optional - for Kubernetes)

If you're using Kubernetes:

1. Install sealed-secrets controller:
```bash
kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/controller.yaml
```

2. Create secrets and seal them:
```bash
# Create a secret
kubectl create secret generic mysecret --from-literal=mykey=myvalue --dry-run=client -o yaml > mysecret.yaml

# Seal the secret
kubeseal -o yaml < mysecret.yaml > mysealedsecret.yaml

# Apply the sealed secret
kubectl apply -f mysealedsecret.yaml
```

## 🧪 Running Tests

### Infrastructure Tests with Terratest

```bash
cd tests
go mod init aws-devops-tests
go mod tidy
go test -v -timeout 30m
```

### Application Tests

```bash
cd app
npm install
npm test
```

## 🔒 Security Features

### 1. Terraform Security Scanning (tfsec)
- Scans Terraform code for security issues
- Integrated into GitHub Actions workflow
- Results uploaded to GitHub Security tab

### 2. Container Image Scanning (Trivy)
- Scans Docker images for vulnerabilities
- Runs on every build
- Blocks deployment on critical vulnerabilities

### 3. Sealed Secrets
- Encrypts Kubernetes secrets at rest
- Secrets can only be decrypted by the target cluster
- Version controlled safely

## 📊 Pipeline Stages

### 1. Source Stage
- Triggers on code push to main branch
- Pulls latest code from GitHub

### 2. Build Stage
- Runs security scans (tfsec, Trivy)
- Builds Docker image
- Pushes to ECR repository
- Runs application tests

### 3. Deploy Stage
- Deploys application to EC2 instances
- Uses CodeDeploy for blue-green deployment
- Applies Sealed Secrets to Kubernetes (if applicable)

## 📈 Monitoring and Outputs

After deployment, you'll get these outputs:

- **Pipeline URL**: Access your CodePipeline
- **Application URL**: Access your deployed application
- **ECR Repository**: Container registry URL
- **S3 Bucket**: Artifacts storage location

## 🔍 Troubleshooting

### Common Issues:

1. **IAM Permissions**: Ensure your AWS user has sufficient permissions
2. **GitHub Token**: Check token permissions and expiry
3. **SSH Key**: Verify public key format is correct
4. **Security Groups**: Ensure allowed_ip_range includes your IP

### Useful Commands:

```bash
# Check pipeline status
aws codepipeline get-pipeline-state --name your-pipeline-name

# Check deployment status
aws deploy get-deployment --deployment-id your-deployment-id

# Check application logs on EC2
ssh -i your-key.pem ec2-user@your-instance-ip
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

## 🧹 Cleanup

To destroy all resources:

```bash
cd terraform
terraform destroy
```

## 📚 Additional Resources

- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Sealed Secrets Documentation](https://sealed-secrets.netlify.app/)
- [Terratest Documentation](https://terratest.gruntwork.io/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.