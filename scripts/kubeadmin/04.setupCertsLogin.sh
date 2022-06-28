#!/bin/bash
# copy cers from master-1 to master-2
vagrant ssh -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa <<< y " master-1
PUB_CERT=$(vagrant ssh -c "cat ~/.ssh/id_rsa.pub" master-1)
for vm in master-2
  do
    echo "Copying pub key to ${vm}"
    vagrant ssh -c "echo '$PUB_CERT' >> ~/.ssh/authorized_keys" $vm
    vagrant ssh -c "ssh-keyscan ${vm} >> ~/.ssh/known_hosts" master-1
  done