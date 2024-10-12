#!/bin/bash

# File containing list of IP addresses (one per line)
IP_LIST="ip_list.txt"

# SSH user
SSH_USER="k3s"

# Command to run on each target
CLEANUP_COMMANDS="
sudo apt-get update && sudo apt-get upgrade -y
sudo dpkg --configure -a
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /tmp/*
sudo shutdown -h now
"

# Read IP addresses from file and execute commands via SSH
while IFS= read -r IP
do
  echo "Connecting to $IP..."
  ssh -o StrictHostKeyChecking=no "$SSH_USER@$IP" "$CLEANUP_COMMANDS"
  if [ $? -eq 0 ]; then
    echo "Cleanup completed on $IP."
  else
    echo "Cleanup failed on $IP."
  fi
done < "$IP_LIST"

echo "All done."
