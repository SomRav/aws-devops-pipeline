@echo off
echo 🚀 AWS DevOps Pipeline - Windows Setup Helper
echo ==============================================
echo.

echo This script will help you install required tools on Windows
echo Please run as Administrator for best results
echo.

echo 📋 Installation Guide:
echo.

echo 1. AWS CLI v2:
echo    Download from: https://awscli.amazonaws.com/AWSCLIV2.msi
echo    Run the installer and restart your terminal
echo.

echo 2. Terraform:
echo    Download from: https://www.terraform.io/downloads
echo    Extract to C:\terraform\
echo    Add C:\terraform\ to your PATH environment variable
echo.

echo 3. Node.js 18 LTS:
echo    Download from: https://nodejs.org/en/download/
echo    Run the MSI installer (includes npm)
echo.

echo 4. Docker Desktop:
echo    Download from: https://www.docker.com/products/docker-desktop/
echo    Run installer and enable WSL2 when prompted
echo.

echo 5. Git (if not installed):
echo    Download from: https://git-scm.com/download/win
echo    Install with Git Bash option selected
echo.

echo 📝 After installing all tools:
echo 1. Restart your terminal/command prompt
echo 2. Run: aws configure
echo 3. Generate SSH keys: ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
echo 4. Get your public IP: curl ifconfig.me
echo 5. Create GitHub Personal Access Token
echo 6. Edit terraform/terraform.tfvars with your values
echo.

echo 🔍 To check if everything is installed correctly:
echo    Run: bash check-setup.sh
echo.

echo ⚠️  Important Notes:
echo - Make sure to restart your terminal after each installation
echo - Docker Desktop requires Windows 10/11 Pro or Enterprise (or WSL2)
echo - You'll need administrative privileges for some installations
echo.

pause
