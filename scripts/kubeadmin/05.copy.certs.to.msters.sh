source ../scripts/set_env_from_file.sh -f ../scripts/env.cfg
# copy and relocate cert

cmd_cp_home="sudo cp -r /etc/kubernetes/pki/ ~/ ; sudo chown -R vagrant ./* "
vagrant ssh -c "$cmd_cp_home" master-1

for ((n=2;n<=$NUM_MASTER_NODE;n++))
    do
        cmd_cp="scp ~/pki/ca.crt master-$n:~ ; \
        scp ~/pki/ca.key master-$n:~ ; \
        scp ~/pki/sa.key master-$n:~ ; \
        scp ~/pki/sa.pub master-$n:~ ; \
        scp ~/pki/front-proxy-ca.crt master-$n:~ ; \
        scp ~/pki/front-proxy-ca.key master-$n:~ ; \
        scp ~/pki/etcd/ca.crt master-$n:~/etcd-ca.crt ; \
        scp ~/pki/etcd/ca.key master-$n:~/etcd-ca.key ; \
        "
        #cmd_cp="scp -r ~/pki/ master-$n:~ "

        cmd_relocate="sudo mkdir -p /etc/kubernetes/pki/etcd ;\
        sudo mv ~/ca.crt /etc/kubernetes/pki/ ;\
        sudo mv ~/ca.key /etc/kubernetes/pki/ ;\
        sudo mv ~/sa.pub /etc/kubernetes/pki/ ;\
        sudo mv ~/sa.key /etc/kubernetes/pki/ ;\
        sudo mv ~/front-proxy-ca.crt /etc/kubernetes/pki/ ;\
        sudo mv ~/front-proxy-ca.key /etc/kubernetes/pki/ ;\
        sudo mv ~/etcd-ca.crt /etc/kubernetes/pki/etcd/ca.crt ;\
        sudo mv ~/etcd-ca.key /etc/kubernetes/pki/etcd/ca.key ;\
        "

        #cmd_relocate="sudo mkdir -p /etc/kubernetes; sudo mv ~/pki /etc/kubernetes/pki"
        vagrant ssh -c "$cmd_cp" master-1
        vagrant ssh -c "$cmd_relocate" master-$n
    done