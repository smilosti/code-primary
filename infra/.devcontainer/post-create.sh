#!/bin/bash

echo "Running post-create tasks..."

# Terraform: Initialize modules
if [ -d "/workspace/infra/terraform" ]; then
  echo "Initializing Terraform..."
  cd /workspace/infra/terraform/environments/shared && terraform init
fi

# Packer: Verify installation
echo "Verifying Packer installation..."
packer --version

# ArgoCD: Check installation
echo "Verifying ArgoCD CLI installation..."
argocd version --client

echo "Post-create tasks completed."
