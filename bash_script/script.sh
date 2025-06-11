#!/bin/bash
set -e

# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install essential dependencies
sudo apt-get install -y software-properties-common gnupg curl ca-certificates apt-transport-https lsb-release

# -----------------------------
# Install Java 17
# -----------------------------
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk

# -----------------------------
# Install Jenkins (without GPG check)
# -----------------------------
echo "deb [trusted=yes] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# -----------------------------
# Install Ansible (without GPG check)
# -----------------------------
sudo add-apt-repository --yes --no-update ppa:ansible/ansible
sudo sed -i 's/^deb /deb [trusted=yes] /' /etc/apt/sources.list.d/ansible-ubuntu-ansible-*.list
sudo apt-get update -y
sudo apt-get install -y ansible

# -----------------------------
# Install Docker (without GPG check)
# -----------------------------
sudo mkdir -p /etc/apt/keyrings
echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add default user to the docker group
sudo usermod -aG docker ubuntu || true

# -----------------------------
# Open Jenkins port (optional)
# -----------------------------
sudo ufw allow 8080 || true
