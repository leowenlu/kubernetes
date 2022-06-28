sudo mkdir -p /etc/kubernetes/pki/etcd
sudo mv ~/ca.crt /etc/kubernetes/pki/
sudo mv ~/ca.key /etc/kubernetes/pki/
sudo mv ~/sa.pub /etc/kubernetes/pki/
sudo mv ~/sa.key /etc/kubernetes/pki/
sudo mv ~/front-proxy-ca.crt /etc/kubernetes/pki/
sudo mv ~/front-proxy-ca.key /etc/kubernetes/pki/
sudo mv ~/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt
# Skip the next line if you are using external etcd
sudo mv ~/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key