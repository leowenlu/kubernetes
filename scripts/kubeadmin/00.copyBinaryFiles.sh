#! /bin/bash
for instance in master-1 master-2
  do

    vagrant scp ../downloads/kubelet $instance:~
    vagrant ssh -c "sudo mv ~/kubelet /usr/local/bin" $instance
  done

for instance in worker-1 worker-2
  do
    vagrant scp ../downloads/kubectl $instance:~
    vagrant ssh -c "sudo mv ~/kubectl /usr/local/bin" $instance

    vagrant scp ../downloads/kube-proxy $instance:~
    vagrant ssh -c "sudo mv ~/kube-proxy /usr/local/bin" $instance

    vagrant scp ../downloads/kubelet $instance:~
    vagrant ssh -c "sudo mv ~/kubelet /usr/local/bin" $instance
    vagrant scp ../downloads/kubeadm $instance:~
    vagrant ssh -c "sudo mv ~/kubeadm /usr/local/bin" $instance
  done
