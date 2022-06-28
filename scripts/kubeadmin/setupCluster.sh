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
SCRIPT=02.install.kubes.sh
for instance in node-1 node-2 master-1 master-2
  do
    vagrant scp ../scripts/kubeadmin/$SCRIPT $instance:$SCRIPT
    vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" $instance
  done

echo "########----------------#########"
echo "#   3. run kubeadm on master-1  #"
echo "########----------------#########"
SCRIPT=03.kubeadm.init.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1


echo "########----------------#########"
echo "#   4. Set up ssh for scp      #"
echo "########----------------#########"
SCRIPT=04.setupCertsLogin.sh
chmod +x ../scripts/kubeadmin/$SCRIPT
../scripts/kubeadmin/$SCRIPT

echo "########----------------#########"
echo "#   5. copy certs from master-1   #"
echo "########----------------#########"

SCRIPT=05.copy.certs.to.msters.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

echo "########----------------#########"
echo "#   6.Relocate certs location   #"
echo "########----------------#########"
SCRIPT=06.relocate.certs.sh
vagrant scp ../scripts/kubeadmin/$SCRIPT master-2:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-2

echo "########----------------#########"
echo "#   7. join master and nodes   #"
echo "########----------------#########"
SCRIPT=07.joinEtcd.nodes.sh
chmod +x  ../scripts/kubeadmin//$SCRIPT ;
 ../scripts/kubeadmin/$SCRIPT

echo "copy examples"