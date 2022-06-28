
LOADBALANCER_ADDRESS=192.168.1.30
sudo apt-get install -y apt-transport-https ca-certificates conntrack
sudo kubeadm init --control-plane-endpoint $LOADBALANCER_ADDRESS \
--apiserver-advertise-address 192.168.1.11 \
--pod-network-cidr 10.23.0.0/16

# kubeadm init
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# install network addon weave
sleep 5
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
