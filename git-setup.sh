#!/bin/bash

# Git Setup and Push Script
echo "🚀 Setting up Git repository and pushing code..."

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
    git branch -M main
fi

# Add GitHub remote if not exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "🔗 Adding GitHub remote..."
    git remote add origin https://github.com/SomRav/aws-devops-pipeline.git
fi

# Create .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    echo "📝 Creating .gitignore..."
    cat > .gitignore << EOF
# Terraform
*.tfstate
*.tfstate.backup
.terraform/
.terraform.lock.hcl
terraform.tfvars

# Node.js
node_modules/
npm-debug.log*
.npm

# Environment variables
.env
.env.local

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Go
go.sum
EOF
fi

# Stage all files
echo "📦 Staging files..."
git add .

# Commit if there are changes
if git diff --staged --quiet; then
    echo "✅ No changes to commit"
else
    echo "💾 Committing changes..."
    git commit -m "Initial AWS DevOps pipeline setup

- Complete Terraform infrastructure
- Node.js application with tests  
- GitHub Actions CI/CD workflow
- Kubernetes deployment configs
- Sealed secrets configuration
- DevSecOps security scanning"
fi

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push -u origin main

echo ""
echo "✅ Code successfully pushed to GitHub!"
echo ""
echo "🔗 Repository: https://github.com/SomRav/aws-devops-pipeline"
echo "📊 Actions: https://github.com/SomRav/aws-devops-pipeline/actions"
echo ""
echo "⚠️  Next steps:"
echo "1. Set up GitHub repository secrets (see GITHUB-SECRETS-SETUP.md)"
echo "2. Check GitHub Actions workflow execution"
echo "3. Monitor Terraform deployment completion"
