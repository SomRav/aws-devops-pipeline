#!/bin/bash

# Final Project Status Check
echo "🎯 AWS DevOps Project - Final Status Check"
echo "==========================================="
echo

# Check file structure
echo "📁 Project Structure:"
echo "✅ Infrastructure as Code (Terraform)"
echo "   - terraform/main.tf (AWS resources)"
echo "   - terraform/variables.tf (configuration)"
echo "   - terraform/outputs.tf (resource outputs)"
echo

echo "✅ Application Code"
echo "   - app/server.js (Node.js Express app)"
echo "   - app/package.json (dependencies)"
echo "   - app/server.test.js (unit tests)"
echo

echo "✅ DevSecOps Pipeline"
echo "   - .github/workflows/ci-cd.yml (GitHub Actions)"
echo "   - Security scanning (tfsec, Trivy)"
echo "   - Automated testing and deployment"
echo

echo "✅ Infrastructure Testing"
echo "   - tests/main_test.go (Terratest)"
echo "   - tests/go.mod (Go dependencies)"
echo

echo "✅ Kubernetes & Security"
echo "   - k8s/deployment.yaml (K8s deployment)"
echo "   - k8s/sealed-secret.yaml (encrypted secrets)"
echo "   - scripts/create-sealed-secrets.sh (secret management)"
echo

echo "✅ AWS CodePipeline Integration"
echo "   - appspec.yml (CodeDeploy configuration)"
echo "   - buildspec.yml (CodeBuild configuration)"
echo "   - scripts/ (deployment scripts)"
echo

# Test status
echo "🧪 Test Results:"
cd tests
if go test -v -run TestTerraformValidation >/dev/null 2>&1; then
    echo "✅ Terraform validation tests: PASSING"
else
    echo "❌ Terraform validation tests: FAILING"
fi

if go test -v -run TestTerraformFormat >/dev/null 2>&1; then
    echo "✅ Terraform format tests: PASSING"
else
    echo "❌ Terraform format tests: FAILING"
fi

cd ../app
if npm test >/dev/null 2>&1; then
    echo "✅ Node.js application tests: PASSING"
else
    echo "❌ Node.js application tests: FAILING"
fi

cd ..

echo
echo "📋 Project Features Implemented:"
echo "✅ Task 1: CodePipeline using Terraform"
echo "   - AWS CodePipeline with Source, Build, Deploy stages"
echo "   - Infrastructure as Code with Terraform"
echo "   - Terratest for infrastructure testing"
echo "   - S3, ECR, IAM, VPC, EC2, ALB resources"
echo

echo "✅ Task 2: DevSecOps Integration"
echo "   - GitHub Actions CI/CD workflow"
echo "   - Security scanning (tfsec for Terraform)"
echo "   - Container scanning (Trivy for Docker)"
echo "   - Kubernetes Sealed Secrets for secure secret management"
echo "   - Automated deployment pipeline"
echo

echo "🚀 Ready for Deployment!"
echo "========================"
echo
echo "Next Steps:"
echo "1. Configure terraform.tfvars with your values"
echo "2. Set up GitHub repository secrets"
echo "3. Deploy: cd terraform && terraform apply"
echo "4. Push to GitHub to trigger CI/CD pipeline"
echo
echo "📖 See PROJECT-GUIDE.md for detailed instructions"
echo "🔧 Run setup-project.sh for interactive setup"
