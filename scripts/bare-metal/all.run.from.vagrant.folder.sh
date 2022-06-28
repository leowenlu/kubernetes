#!/bin/bash
## 00 download binary files
SCRIPT=00.downloadBinaryFiles.sh
../scripts/bare-metal/$SCRIPT
# prerequirment:  vagrant plugin install vagrant-scp
WORKSTATION=master-1
## 00 generate root CA on the workstation instance
vagrant ssh -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y " $WORKSTATION
## 00 copy master-1 public cert to all nodes
SCRIPT=00.setupAuthorizedSshKnownhost.sh
../scripts/bare-metal/$SCRIPT

## 00 copy binary files
SCRIPT=00.copyBinaryFiles.sh
../scripts/bare-metal/$SCRIPT

## 01.provision ca and assign certs
SCRIPT=01.provisionCA.certs.sh
vagrant scp ../scripts/bare-metal/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

#02.Setup.kubernetes-configuration.sh
SCRIPT=02.SetupKubernetes-configuration.sh
vagrant scp ../scripts/bare-metal/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1


#03 data encryption keys
SCRIPT=03.dataEncryptionKeys.sh
vagrant scp ../scripts/bare-metal/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

#04 bootscrap ectd
SCRIPT=04.bootstrapping-etcd.sh
for instance in master-1 master-2; do
  vagrant scp ../scripts/bare-metal/$SCRIPT $instance:$SCRIPT
  vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" $instance
done


#05 control plane
for instance in master-1 master-2; do
  SCRIPT=05.BootstrappingtheKubernetesControlPlane.sh
  echo "setting up ${instance} "
  vagrant scp ../scripts/bare-metal/$SCRIPT $instance:$SCRIPT
  vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" $instance
done
echo "control plane ------ DONE, checking:"
echo 'kubectl get componentstatuses --kubeconfig admin.kubeconfig'

#06 Frontend proxy

SCRIPT=06.frontend-load-balancer.sh
vagrant scp ../scripts/bare-metal/$SCRIPT loadbalancer:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" loadbalancer
echo "Frontend proxy ------ DONE"

#07 worker config
SCRIPT=07.Setup-worker-configuration.sh
vagrant scp ../scripts/bare-metal/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" master-1
echo "setting up workers ------ DONE"


#8 bootstrap workers
for instance in worker-1 worker-2; do
INSTALL_KUBUWOKER=08.Bootstrap-kubernetes-worker.sh
vagrant scp ../scripts/bare-metal/$INSTALL_KUBUWOKER $instance:$INSTALL_KUBUWOKER
vagrant ssh -c "chmod +x $INSTALL_KUBUWOKER;  ~/$INSTALL_KUBUWOKER" $instance
done

CMD='kubectl get nodes --kubeconfig admin.kubeconfig'
#vagrant ssh -c $CMD master-1

#09 set Admin Kubernetes Configuration File
SCRIPT=09.setupAdminConfFile.sh
vagrant scp ../scripts/bare-metal/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" master-1
echo "setting up workers ------ DONE"

#10 pod networking
for instance in worker-1 worker-2; do
POD_NETWORKING=10.1.pod-networking.sh
vagrant scp ../scripts/bare-metal/$POD_NETWORKING $instance:$POD_NETWORKING
vagrant ssh -c "chmod +x $POD_NETWORKING;  ~/$POD_NETWORKING" $instance
done

for instance in master-1; do
POD_NETWORKING=10.2.pod-networking.sh
vagrant scp ../scripts/bare-metal/$POD_NETWORKING $instance:$POD_NETWORKING
vagrant ssh -c "chmod +x $POD_NETWORKING;  ~/$POD_NETWORKING" $instance
done


