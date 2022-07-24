#!/bin/bash

KUBEADM_INSTANCE=master-1

## 00 download binary files
SCRIPT=00.downloadBinaryFiles.sh
../scripts/$SCRIPT
# prerequirment:  vagrant plugin install vagrant-scp

## 00 copy binary files
SCRIPT=00.copyBinaryFiles.sh
../scripts/kubeadmin/$SCRIPT


SCRIPT=01.frontend-load-balancer.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT loadbalancer:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" loadbalancer
echo "Frontend proxy ------ DONE"


SCRIPT=02.init.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

SCRIPT=03.install.kubes.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT master-2:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-2


kubeadm join 192.168.1.30:6443 --token a5bqme.8rogq772ile6more \
    --discovery-token-ca-cert-hash sha256:02203281cca9857b283848dcbf540c5d6768d824138930b8d7b95b5b5a332d8c \
    --control-plane


SCRIPT=03.install.kubes.sh
for instance in worker-1 worker-2
  do
    mkdir /etc/kubernetes/pki/
    vagrant scp ../scripts/kubeadmin/$SCRIPT $instance:$SCRIPT
    vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" $instance
  done

