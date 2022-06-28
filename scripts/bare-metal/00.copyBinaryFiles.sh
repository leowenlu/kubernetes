#! /bin/bash
for instance in master-1 master-2
  do
    vagrant scp ../downloads/kubectl $instance:~
    vagrant ssh -c "sudo mv ~/kubectl /usr/local/bin" $instance

    vagrant scp ../downloads/kube-apiserver $instance:~
    vagrant ssh -c "sudo mv ~/kube-apiserver /usr/local/bin" $instance

    vagrant scp ../downloads/kube-controller-manager $instance:~
    vagrant ssh -c "sudo mv ~/kube-controller-manager /usr/local/bin" $instance

    vagrant scp ../downloads/kube-scheduler $instance:~
    vagrant ssh -c "sudo mv ~/kube-scheduler /usr/local/bin" $instance

    vagrant scp ../downloads/etcd-v3.4.15-linux-amd64/etcd $instance:~
    vagrant scp ../downloads/etcd-v3.4.15-linux-amd64/etcdctl $instance:~

    vagrant ssh -c "sudo mv ~/etcd* /usr/local/bin" $instance
  done

for instance in worker-1 worker-2
  do
    vagrant scp ../downloads/kubectl $instance:~
    vagrant ssh -c "sudo mv ~/kubectl /usr/local/bin" $instance

    vagrant scp ../downloads/kube-proxy $instance:~
    vagrant ssh -c "sudo mv ~/kube-proxy /usr/local/bin" $instance

    vagrant scp ../downloads/kubelet $instance:~
    vagrant ssh -c "sudo mv ~/kubelet /usr/local/bin" $instance
  done
# copy exce to /usr/bin/

for instance in worker-1 worker-2
  do
    vagrant ssh -c "sudo mkdir -p /opt/cni/bin" $instance
    vagrant scp ../downloads/cni-plugins-linux-amd64-v1.0.1.tgz $instance:~
    vagrant ssh -c "sudo tar -xzvf ~/cni-plugins-linux-amd64-v1.0.1.tgz -C /opt/cni/bin" $instance
  done