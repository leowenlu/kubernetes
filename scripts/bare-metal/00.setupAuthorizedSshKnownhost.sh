PUB_CERT=$(vagrant ssh -c "cat ~/.ssh/id_rsa.pub" master-1)
for vm in master-1 master-2 worker-1 worker-2 loadbalancer
  do
    echo "Copying pub key to ${vm}"
    vagrant ssh -c "echo $PUB_CERT >> ~/.ssh/authorized_keys" $vm
    vagrant ssh -c "ssh-keyscan ${vm} >> ~/.ssh/known_hosts" master-1
  done

echo " knownhosts is :  "
vagrant ssh -c "cat ~/.ssh/known_hosts" master-1