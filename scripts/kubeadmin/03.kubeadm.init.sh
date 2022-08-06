#! /bin/bash

source ../scripts/set_env_from_file.sh -f ../vagrant/env.cfg

#echo " PUBLIC_FACINGE_IP: $PUBLIC_FACINGE_IP"

cmd="sudo kubeadm init --control-plane-endpoint 192.168.101.252  \
--apiserver-advertise-address 192.168.101.11 \
--pod-network-cidr 10.23.0.0/16 \
--upload-certs ;\
sleep 5 ; \
echo 'generating kubeconfig file' ; \
mkdir -p ~/.kube ; \
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config ; \
sudo chown $(id -u):$(id -g) ~/.kube/config ; \
cat ~/.kube/config | tee kube-config "
vagrant ssh -c "$cmd" master-1
mkdir -p ~/.kube
vagrant scp master-1:kube-config ~/.kube/config
# test command
kubectl get pods -A
kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\" ;  \

# install network addon weave
#sleep 5
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
