# init after vagrant up
vagrantBackupStage=Init
for vm in master-1 master-2 node-1 node-2 loadbalancer
  do
    vagrant snapshot save $vm "${vm}-${vagrantBackupStage}"
  done

# restore to init and start again
for vm in master-1 master-2 node-1 node-2 lb
  do
    vagrant snapshot restore $vm "${vm}-${vagrantBackupStage}"
  done

# install kube

