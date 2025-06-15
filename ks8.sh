#!/bin/bash

sudo apt-get update

# Install Docker
sudo apt install -y docker.io

sudo chmod 666 /var/run/docker.sock
# Note: Avoid using `chmod 666 /var/run/docker.sock` for security reasons

# Install Kubernetes APT dependencies
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Create keyring directory
sudo mkdir -p -m 755 /etc/apt/keyrings

# Add Kubernetes GPG key (corrected URL syntax)
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes APT repository (corrected spelling and version)
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update APT index and install specific versions of kubelet, kubeadm, and kubectl
sudo apt-get update
sudo apt-get install -y kubeadm=1.30.0-1.1 kubelet=1.30.0-1.1 kubectl=1.30.0-1.1

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# The output of above command to run in worker nodes

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f
https://raw.githubusercontent.com/projectcalico/calico/v1.24.0./manifests/calico.yaml

kubectl apply -f
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml

