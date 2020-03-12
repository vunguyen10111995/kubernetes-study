# /bin/sh

# Install docker
sudo apt-get update \
  && sudo apt-get install -qy docker.io

# Add the Kubernetes package source
sudo apt-get update \
  && sudo apt-get install -y apt-transport-https \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Perform a packages update
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" \
  | sudo tee -a /etc/apt/sources.list.d/kubernetes.list \
  && sudo apt-get update 

# Install kubelet, kubeadm and kubernetes-cni
sudo apt-get update \
  && sudo apt-get install -yq \
  kubelet \
  kubeadm \
  kubernetes-cni

# Check Kubernetes packages on hold
sudo apt-mark hold kubelet kubeadm kubectl
