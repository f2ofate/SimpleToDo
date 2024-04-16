#!/bin/bash
apt-get update
apt-get update
apt-get install docker.io -y
usermod -aG docker $USER  # Replace with your system's username, e.g., 'ubuntu'
newgrp docker
chmod 777 /var/run/docker.sock