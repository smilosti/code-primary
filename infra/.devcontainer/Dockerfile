# Use the official Ubuntu 22.04 image as the base
FROM ubuntu:22.04

# Ensure the container starts with an updated base image
RUN apt-get update && apt-get upgrade -y

# Install common dependencies and tools
RUN apt-get install -y \
    curl \
    sudo \
    git \
    unzip \
    jq \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    bash-completion

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install -y terraform

# Install Packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && apt-get install -y packer

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add - && \
    apt-add-repository "deb https://baltocdn.com/helm/stable/debian/ all main" && \
    apt-get update && apt-get install -y helm

# Install ArgoCD CLI
RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && \
    sudo chmod +x /usr/local/bin/argocd

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

# Add bash completion for Helm, Terraform, and ArgoCD
RUN echo 'source <(helm completion bash)' >> ~/.bashrc && \
    echo 'source <(terraform -install-autocomplete)' >> ~/.bashrc && \
    echo 'source <(argocd completion bash)' >> ~/.bashrc

# Set up the user environment
ARG USERNAME=vscode
RUN useradd -m $USERNAME && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the work directory
WORKDIR /workspace

# Entrypoint to keep the container running
ENTRYPOINT ["sleep", "infinity"]
