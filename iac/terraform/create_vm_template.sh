#!/bin/bash

# Variables
TEMPLATE_ID=9011
TEMPLATE_NAME="cloud-init-template-Ubu2204"
IMAGE_PATH="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"  # Path to pre-downloaded image
STORAGE="local-zfs-376g"
MEMORY=16384
CORES=4
SOCKETS=2
NUMA=true  # Enable NUMA
CIUSER="ceph"  # Set your desired default username
CIPASSWORD="m@xFr@sh992.2"  # Set your desired default password
SSHKEY="ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBABJSydkOrqbOfUgUYGR8LOOen3ndqPre+wORRKAt7QQNAoa2YOE+2hb+xqTczLsT6JrZ+xqi9Yamm0OL9WCo52k7wC282CBs1vKDqQ/7yB13cndeiaTsudNWUyTEJj034PgLZhWnESOlCBAf2xHLsilU0jELclml0v3vwtqcnU3XXEL/Q== apex@r12"  # Paste your public SSH key here
VLAN=2201  # Replace with your VLAN ID
DNS_DOMAIN="hci2.ducerent.local"  # Set your DNS domain
DNS_SERVER="172.20.20.1"  # Set your DNS server
OS_DISK_SIZE=64  # OS (boot) partition size in GB

# Create VM
qm create $TEMPLATE_ID --name $TEMPLATE_NAME --memory $MEMORY --cores $CORES --sockets $SOCKETS --numa $NUMA --net0 virtio,bridge=vmbr2200,tag=$VLAN

# Import disk
qm importdisk $TEMPLATE_ID $IMAGE_PATH $STORAGE

# Configure VM
qm set $TEMPLATE_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$TEMPLATE_ID-disk-0,size=${OS_DISK_SIZE}G
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
qm resize $TEMPLATE_ID scsi0 ${OS_DISK_SIZE}G

# Convert to template
qm template $TEMPLATE_ID

# Set BIOS to OVMF (UEFI)
qm set $TEMPLATE_ID --bios ovmf

# Add EFI disk with pre-enrolled keys
qm set $TEMPLATE_ID --efidisk0 $STORAGE:1,format=raw,efitype=4m,pre-enrolled-keys=1

# Wait and check for EFI disk creation
RETRY=10
while [ $RETRY -gt 0 ]; do
    if [ -e /dev/zvol/$STORAGE/vm-$TEMPLATE_ID-disk-1 ]; then
        echo "EFI disk created successfully"
        break
    else
        echo "Waiting for EFI disk to be created..."
        sleep 10
        RETRY=$((RETRY - 1))
    fi
done

if [ $RETRY -eq 0 ]; then
    echo "Error: EFI disk creation timeout"
    exit 1
fi

# Clean up temporary SSH key file
rm $TMP_SSHKEY

# Clean up (optional, only if you had downloaded the image during the script execution)
# rm /tmp/ubuntu-cloud-init.img

echo "Cloud-init template created successfully with ID $TEMPLATE_ID"
