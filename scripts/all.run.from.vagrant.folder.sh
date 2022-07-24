# prerequirment:  vagrant plugin install vagrant-scp
WORKSTATION=master-1
## 00 generate root CA on the workstation instance
vagrant ssh -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y " $WORKSTATION

## 00 download binary files
SCRIPT=00.downloadBinaryFiles.sh
../scripts/$SCRIPT

## 00 copy master-1 public cert to all nodes
SCRIPT=00.setupAuthorizedSshKnownhost.sh
../scripts/$SCRIPT

## 00 copy binary files
SCRIPT=00.copyBinaryFiles.sh
../scripts/$SCRIPT

for instance in master-1 master-2
  do
    vagrant ssh -c "sudo /bin/cp ~/kubectl ~/kube-apiserver ~/kube-controller-manager ~/kube-scheduler /usr/local/bin/" $instance
    vagrant ssh -c "sudo chmod +x /usr/local/bin/kube*" $instance
  done

## 01.provision ca and assign certs
SCRIPT=01.provisionCA.certs.sh
vagrant scp ../scripts/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

#02.Setup.kubernetes-configuration.sh
SCRIPT=02.SetupKubernetes-configuration.sh
vagrant scp ../scripts/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1


#03 data encryption keys
SCRIPT=03.dataEncryptionKeys.sh
vagrant scp ../scripts/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x ~/$SCRIPT ;  ~/$SCRIPT" master-1

#04 bootscrap ectd
SCRIPT=04.bootstrapping-etcd.sh
for instance in master-1 master-2; do
  vagrant scp ../scripts/$SCRIPT $instance:$SCRIPT
  vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" $instance
done


#05 control plane
for instance in master-1 master-2; do
  SCRIPT=05.BootstrappingtheKubernetesControlPlane.sh
  echo "setting up ${instance} "
  vagrant scp ../scripts/$SCRIPT $instance:$SCRIPT
  vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" $instance
done
echo "control plane ------ DONE, checking:"
CMD='kubectl get componentstatuses --kubeconfig admin.kubeconfig'
#vagrant ssh -c $CMD master-1

#06 Frontend proxy

SCRIPT=06.frontend-load-balancer.sh
vagrant scp ../scripts/$SCRIPT loadbalancer:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" loadbalancer
echo "Frontend proxy ------ DONE"

#07 worker config
SCRIPT=07.Setup-worker-configuration.sh
vagrant scp ../scripts/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" master-1
echo "setting up workers ------ DONE"


#8 bootstrap workers
for instance in worker-1 worker-2; do
INSTALL_KUBUWOKER=07.Bootstrap-kubernetes-worker.sh
vagrant scp ../scripts/$INSTALL_KUBUWOKER $instance:$INSTALL_KUBUWOKER
vagrant ssh -c "chmod +x $INSTALL_KUBUWOKER;  ~/$INSTALL_KUBUWOKER" $instance
done

CMD='kubectl get nodes --kubeconfig admin.kubeconfig'
#vagrant ssh -c $CMD master-1

#09 set Admin Kubernetes Configuration File
SCRIPT=09.setupAdminConfFile.sh
vagrant scp ../scripts/$SCRIPT master-1:$SCRIPT
vagrant ssh -c "chmod +x $SCRIPT;  ~/$SCRIPT" master-1
echo "setting up workers ------ DONE"

##10 pod networking
for instance in worker-1 worker-2; do
POD_NETWORKING=10.1.pod-networking.sh
vagrant scp ../scripts/$POD_NETWORKING $instance:$POD_NETWORKING
vagrant ssh -c "chmod +x $POD_NETWORKING;  ~/$POD_NETWORKING" $instance
done

for instance in master-1; do
POD_NETWORKING=10.2.pod-networking.sh
vagrant scp ../scripts/$POD_NETWORKING $instance:$POD_NETWORKING
vagrant ssh -c "chmod +x $POD_NETWORKING;  ~/$POD_NETWORKING" $instance
done



# The connection to the server localhost:8080 was refused - did you specify the right host or port?
# serviceaccount/weave-net configured
# clusterrole.rbac.authorization.k8s.io/weave-net configured
# clusterrolebinding.rbac.authorization.k8s.io/weave-net configured
# role.rbac.authorization.k8s.io/weave-net configured
# rolebinding.rbac.authorization.k8s.io/weave-net configured
# daemonset.apps/weave-net configured

generate : master.admin.kubeconfig