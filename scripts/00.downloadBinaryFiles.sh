mkdir ../downloads

## Download kube
echo "Downloading kubectl"
wget -O ../downloads/kube-apiserver -q --show-progress --https-only --timestamping "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-apiserver"
wget -O ../downloads/kube-controller-manager -q --show-progress --https-only --timestamping "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-controller-manager"
wget -O ../downloads/kube-scheduler -q --show-progress --https-only --timestamping "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-scheduler"
wget -O ../downloads/kubectl -q --show-progress --https-only --timestamping "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl"
wget -O ../downloads/kube-proxy "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-proxy"
wget -O ../downloads/kubelet "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubelet"
wget -O ../downloads/kubeadm -q --show-progress --https-only --timestamping "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubeadm"

chmod +x ../downloads/kube*

# download etc
wget -O ../downloads/etcd-v3.4.15-linux-amd64.tar.gz -q --show-progress --https-only --timestamping \
  "https://github.com/etcd-io/etcd/releases/download/v3.4.15/etcd-v3.4.15-linux-amd64.tar.gz"
tar -xvf ../downloads/etcd-v3.4.15-linux-amd64.tar.gz -C ../downloads
chmod + downloads/etcd-v3.4.15-linux-amd64/etcd*

# download CNI plugins
wget -O ../downloads/cni-plugins-linux-amd64-v1.0.1.tgz https://github.com/containernetworking/plugins/releases/download/v1.0.1/cni-plugins-linux-amd64-v1.0.1.tgz
mkdir ../downloads/cni
tar -xzvf ../downloads/cni-plugins-linux-amd64-v1.0.1.tgz -C ../downloads/cni



wget -O ../downloads/kubelet "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubeadm"