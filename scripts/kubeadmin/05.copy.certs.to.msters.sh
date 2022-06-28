for host in master-2
    do
        sudo cp -r /etc/kubernetes/pki/ ~
        sudo chown -R vagrant ./*
        scp ~/pki/ca.crt $host:~
        scp ~/pki/ca.key $host:~
        scp ~/pki/sa.key $host:~
        scp ~/pki/sa.pub $host:~
        scp ~/pki/front-proxy-ca.crt $host:~
        scp ~/pki/front-proxy-ca.key $host:~
        scp ~/pki/etcd/ca.crt $host:~/etcd-ca.crt
        # Skip the next line if you are using external etcd
        scp ~/pki/etcd/ca.key $host:~/etcd-ca.key
    done