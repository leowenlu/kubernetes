# Update packages

sudo apt-get update && sudo apt-get -y upgrade

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

sudo apt-get install -y apt-transport-https ca-certificates docker.io


# Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

kube_version=1.20.0

sudo apt install -y kubeadm=${kube_version}-00 kubelet=${kube_version}-00 kubectl=${kube_version}-00

kubeadm version -o short

# Docker Cgroup Driver

sudo cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF
sudo systemctl restart docker

sudo apt-mark hold kubelet kubeadm kubectl
