#!/bin/bash

KUBEADM_INSTANCE=master-1
echo "########----------------#########"
echo "#        1. setup LB            #"
echo "########----------------#########"

SCRIPT=01.frontend-load-balancer.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT loadbalancer:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" loadbalancer

echo "########----------------#########"
echo "#   2. install kubes commands   #"
echo "########----------------#########"
../scripts/kubeadmin/02.install.binary.sh

echo "########----------------#########"
echo "#   3. run kubeadm on master-1  #"
echo "########----------------#########"
../scripts/kubeadmin/03.kubeadm.init.sh

# get kubeadmin config file, and copy to local workstation


echo "########----------------#########"
echo "#    4. Set up ssh for scp      #"
echo "########----------------#########"
SCRIPT=04.setupCertsLogin.sh
chmod +x ../scripts/kubeadmin/$SCRIPT
../scripts/kubeadmin/$SCRIPT

echo "########----------------#########"
echo "#   5. copy relocate certs      #"
echo "########----------------#########"
../scripts/kubeadmin/05.copy.certs.to.msters.sh

echo "########----------------#########"
echo "#   6. join master and nodes   #"
echo "########----------------#########"

 ../scripts/kubeadmin/06.joinEtcd.nodes.sh

echo "copy examples"