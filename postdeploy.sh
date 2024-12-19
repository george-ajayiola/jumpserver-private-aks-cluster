#!/bin/bash

sudo apt -qq update

# install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# install Kubectl CLI
snap install kubectl --classic

# Add the alias for kubectl as 'k' to ~/.bashrc
echo "alias k=\"kubectl\"" >> ~/.bashrc

# Reload .bashrc to apply changes immediately
source ~/.bashrc

# login to Azure using VM's Managed Identity
# az login --identity

# az aks list -o table

# kubectl get nodes