FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    gnupg software-properties-common curl git build-essential libguestfs-tools

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com focal main"
RUN apt-get update && apt-get install -y terraform

# Install Ansible
RUN apt-get update && apt-get install -y ansible

# Install Helm
RUN curl https://baltocdn.com/helm/signing.asc | apt-key add -
RUN apt-get install -y apt-transport-https --no-install-recommends
RUN echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update && apt-get install -y helm

# Install Golang
RUN curl -LO https://golang.org/dl/go1.20.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.20.3.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Create workspaces directory
RUN mkdir -p /workspaces/iac/terraform
RUN mkdir -p /workspaces/iac/ansible
RUN mkdir -p /workspaces/iac/helm

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone the Proxmox provider repository
RUN git clone https://github.com/Telmate/terraform-provider-proxmox.git /workspaces/iac/terraform-provider-proxmox

# Edit go.mod file to ensure compatibility
RUN cd /workspaces/iac/terraform-provider-proxmox && \
    sed -i '/toolchain/d' go.mod && \
    sed -i 's/go 1.21/go 1.20/' go.mod && \
    go mod tidy && \
    go build -o terraform-provider-proxmox

# Move the provider to the correct directory for Terraform
RUN mkdir -p ~/.terraform.d/plugins/local/proxmox/0.0.1/linux_amd64
RUN mv /workspaces/iac/terraform-provider-proxmox/terraform-provider-proxmox ~/.terraform.d/plugins/local/proxmox/0.0.1/linux_amd64
