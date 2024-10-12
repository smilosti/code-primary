#!/bin/bash

# Variables
TEMPLATE_ID=9011
TEMPLATE_NAME="cloud-init-template-Ubu2204"
IMAGE_PATH="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"  # Path to pre-downloaded image
STORAGE="local-zfs-376g"
MEMORY=2048
CORES=2
SOCKETS=2
CIUSER="k3s"  # Set your desired default username
CIPASSWORD="m@xFr@sh992.2"  # Set your desired default password
SSHKEY="ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABJSydkOrqbOfUgUYGR8LOOen3ndqPre+wORRKAt7QQNAoa2YOE+2hb+xqTczLsT6JrZ+xqi9Yamm0OL9WCo52k7wC282CBs1vKDqQ/7yB13cndeiaTsudNWUyTEJj034PgLZhWnESOlCBAf2xHLsilU0jELclml0v3vwtqcnU3XXEL/Q== apex@r12"  # Paste your public SSH key here
VLAN1=2201  # Replace with your VLAN ID for the first network card
VLAN2=2202  # Replace with your VLAN ID for the second network card
BRIDGE1="vmbr2200"  # Replace with your bridge name for the first network card
BRIDGE2="vmbr2201"  # Replace with your bridge name for the second network card
DNS_DOMAIN="hci2.ducerent.local"  # Set your DNS domain
DNS_SERVER="172.20.20.1"  # Set your DNS server

# Create VM
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $MEMORY --cores $CORES --sockets $SOCKETS --net0 virtio,bridge=$BRIDGE1,tag=$VLAN1 --net1 virtio,bridge=$BRIDGE2,tag=$VLAN2

# Import disk
qm importdisk $TEMPLATE_ID $IMAGE_PATH $STORAGE

# Configure VM
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$TEMPLATE_ID-disk-0
qm set $TEMPLATE_ID --boot order=scsi0
qm set $TEMPLATE_ID --vga std
qm set $TEMPLATE_ID --machine q35
qm set $TEMPLATE_ID --cpu host
qm set $TEMPLATE_ID --numa 1

# Add cloud-init drive
qm set $TEMPLATE_ID --ide2 $STORAGE:cloudinit
qm set $TEMPLATE_ID --boot c --bootdisk scsi0

# Create a temporary file for the SSH key
TMP_SSHKEY=$(mktemp)
echo "$SSHKEY" > $TMP_SSHKEY

# Configure cloud-init
qm set $TEMPLATE_ID --ciuser $CIUSER --cipassword $CIPASSWORD --sshkey $TMP_SSHKEY
qm set $TEMPLATE_ID --nameserver $DNS_SERVER --searchdomain $DNS_DOMAIN

# Enable QEMU guest agent
qm set $TEMPLATE_ID --agent enabled=1

# Resize the disk if needed (example: resize to 32G)
qm resize $TEMPLATE_ID scsi0 32G

# Add EFI disk after a delay
qm set $TEMPLATE_ID --efidisk0 $STORAGE:vm-$TEMPLATE_ID-disk-1,efitype=4m,pre-enrolled-keys=1,size=1M
qm set $TEMPLATE_ID --bios ovmf  # Set BIOS to OVMF (UEFI)

# Convert to template
qm template $TEMPLATE_ID

# Clean up temporary SSH key file
rm $TMP_SSHKEY

# Clean up (optional, only if you had downloaded the image during the script execution)
# rm /tmp/ubuntu-cloud-init.img

echo "Cloud-init template created successfully with ID $TEMPLATE_ID"
