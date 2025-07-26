#!/bin/bash

# Script to generate Kubernetes Sealed Secrets
# Prerequisites: kubectl and kubeseal must be installed

set -e

echo "🔐 Generating Kubernetes Sealed Secrets..."

# Check if kubeseal is installed
if ! command -v kubeseal &> /dev/null; then
    echo "❌ kubeseal is not installed. Installing..."
    
    # Install kubeseal on Linux/WSL
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/kubeseal-0.24.0-linux-amd64.tar.gz
        tar -xvzf kubeseal-0.24.0-linux-amd64.tar.gz kubeseal
        sudo install -m 755 kubeseal /usr/local/bin/kubeseal
        rm kubeseal kubeseal-0.24.0-linux-amd64.tar.gz
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        brew install kubeseal
    else
        echo "❌ Please install kubeseal manually for your OS"
        exit 1
    fi
fi

# Check if kubectl is configured
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ kubectl is not configured or cluster is not accessible"
    echo "Please configure kubectl to connect to your Kubernetes cluster"
    exit 1
fi

# Install Sealed Secrets controller if not present
if ! kubectl get deployment sealed-secrets-controller -n kube-system &> /dev/null; then
    echo "📦 Installing Sealed Secrets controller..."
    kubectl apply -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.24.0/controller.yaml
    
    echo "⏳ Waiting for Sealed Secrets controller to be ready..."
    kubectl wait --for=condition=available --timeout=300s deployment/sealed-secrets-controller -n kube-system
fi

# Function to create sealed secret
create_sealed_secret() {
    local secret_name=$1
    local key_name=$2
    local secret_value
    
    echo "🔑 Enter value for secret '$key_name':"
    read -s secret_value
    
    echo "🔒 Creating sealed secret for $key_name..."
    echo -n "$secret_value" | kubectl create secret generic temp-secret \
        --dry-run=client \
        --from-file=$key_name=/dev/stdin \
        -o yaml | kubeseal -o yaml --merge-into k8s/sealed-secret.yaml
    
    echo "✅ Sealed secret for $key_name created successfully"
}

# Create directory if it doesn't exist
mkdir -p k8s

# Create the initial sealed secret structure
cat > k8s/sealed-secret.yaml << EOF
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: app-secrets
  namespace: default
spec:
  encryptedData: {}
  template:
    metadata:
      name: app-secrets
      namespace: default
    type: Opaque
EOF

echo "📋 Creating sealed secrets for the application..."

# Create sealed secrets
create_sealed_secret "app-secrets" "db-password"
create_sealed_secret "app-secrets" "api-key"

echo ""
echo "🎉 Sealed secrets have been generated and saved to k8s/sealed-secret.yaml"
echo ""
echo "📝 To apply the sealed secrets to your cluster, run:"
echo "   kubectl apply -f k8s/sealed-secret.yaml"
echo ""
echo "🔍 To verify the secrets were created, run:"
echo "   kubectl get secrets app-secrets"
echo "   kubectl get sealedsecrets app-secrets"
