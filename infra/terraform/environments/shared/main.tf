terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"  # Ensure you use the latest version
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://172.20.20.11:8006/api2/json"
  pm_user         = "terraform-prov@pve"
  pm_password     = "f8d4d680-ccf2-4bd5-934f-4e58d286798b"  # Alternatively, use an API token
  pm_tls_insecure = true
}

resource "null_resource" "create_vm_template" {
  provisioner "remote-exec" {
    inline = [
      "bash -c '$(cat <<EOF > /tmp/create_vm_template.sh && chmod +x /tmp/create_vm_template.sh && /tmp/create_vm_template.sh
#!/bin/bash

# Variables
TEMPLATE_ID=9011
TEMPLATE_NAME=\"cloud-init-template-Ubu2204\"
IMAGE_PATH=\"/var/lib/vz/template/iso/ubuntu-22.04-server-cloudimg-amd64.img\"  # Path to pre-downloaded image
STORAGE=\"local-nvme-2T\"
MEMORY=2048
CORES=2
SOCKETS=2
CIUSER=\"k3s\"  # Set your desired default username
CIPASSWORD=\"m@xFr@sh992.2\"  # Set your desired default password
SSHKEY=\"ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABJSydkOrqbOfUgUYGR8LOOen3ndqPre+wORRKAt7QQNAoa2YOE+2hb+xqTczLsT6JrZ+xqi9Yamm0OL9WCo52k7wC282CBs1vKDqQ/7yB13cndeiaTsudNWUyTEJj034PgLZhWnESOlCBAf2xHLsilU0jELclml0v3vwtqcnU3XXEL/Q== apex@r12\"  # Paste your public SSH key here
VLAN=2102  # Replace with your VLAN ID

# Create VM
qm create \$TEMPLATE_ID --name \$TEMPLATE_NAME --memory \$MEMORY --cores \$CORES --sockets \$SOCKETS --net0 virtio,bridge=vmbr2200,tag=\$VLAN

# Import disk
qm importdisk \$TEMPLATE_ID \$IMAGE_PATH \$STORAGE

# Configure VM
qm set \$TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 \$STORAGE:vm-\$TEMPLATE_ID-disk-0
qm set \$TEMPLATE_ID --boot order=scsi0
qm set \$TEMPLATE_ID --vga std
qm set \$TEMPLATE_ID --machine q35
qm set \$TEMPLATE_ID --cpu host
qm set \$TEMPLATE_ID --numa 1

# Add cloud-init drive
qm set \$TEMPLATE_ID --ide2 \$STORAGE:cloudinit
qm set \$TEMPLATE_ID --boot c --bootdisk scsi0

# Create a temporary file for the SSH key
TMP_SSHKEY=\$(mktemp)
echo \"\$SSHKEY\" > \$TMP_SSHKEY

# Configure cloud-init
qm set \$TEMPLATE_ID --ciuser \$CIUSER --cipassword \$CIPASSWORD --sshkey \$TMP_SSHKEY

# Enable QEMU guest agent
qm set \$TEMPLATE_ID --agent enabled=1

# Resize the disk if needed (example: resize to 32G)
qm resize \$TEMPLATE_ID scsi0 32G

# Add EFI disk after a delay
qm set \$TEMPLATE_ID --efidisk0 \$STORAGE:vm-\$TEMPLATE_ID-disk-1,efitype=4m,pre-enrolled-keys=1,size=1M
qm set \$TEMPLATE_ID --bios ovmf  # Set BIOS to OVMF (UEFI)

# Convert to template
qm template \$TEMPLATE_ID

# Clean up temporary SSH key file
rm \$TMP_SSHKEY

# Clean up (optional, only if you had downloaded the image during the script execution)
# rm /tmp/ubuntu-cloud-init.img

echo \"Cloud-init template created successfully with ID \$TEMPLATE_ID\"
EOF
      )"
    ]

    connection {
      type     = "ssh"
      user     = "root"  # Adjust as needed
      password = "your_password"  # Use an SSH key for better security
      host     = "172.20.20.11"  # Proxmox server IP
    }
  }
}

output "template_id" {
  value = 9011  # Update based on your TEMPLATE_ID in the script
}
