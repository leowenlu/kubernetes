#! /bin/bash

source ../scripts/set_env_from_file.sh -f ../scripts/env.cfg

#echo " PUBLIC_FACINGE_IP: $PUBLIC_FACINGE_IP"
LOADBALANCER_ADDRESS=192.168.1.30

cmd="sudo apt-get install -y apt-transport-https ca-certificates conntrack ; \
sudo kubeadm init --control-plane-endpoint ${LOADBALANCER_ADDRESS}  \
--apiserver-advertise-address 192.168.1.11 \
--apiserver-cert-extra-sans ${PUBLIC_FACINGE_IP} \
--pod-network-cidr 10.23.0.0/16 ;\
sleep 5 ; \
echo 'generating kubeconfig file' ; \
mkdir -p ~/.kube ; \
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config ; \
sudo chown $(id -u):$(id -g) ~/.kube/config ; \
cat ~/.kube/config | sed \"s:${LOADBALANCER_ADDRESS}:${PUBLIC_FACINGE_IP}:g\" | tee kube-config "
vagrant ssh -c "$cmd" master-1
mkdir -p ~/.kube
vagrant scp master-1:kube-config ~/.kube/config
# test command
kubectl get pods -A
kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\" ;  \

# install network addon weave
#sleep 5
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
