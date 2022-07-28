source ../scripts/set_env_from_file.sh -f ../scripts/env.cfg
## join etcd

#
join_token=$(vagrant ssh -c "kubeadm token list -o json" master-1 | jq .token)

if [[!join_token]]
  then
    echo "No token found, creating a new token."
    vagrant ssh -c "kubeadm token create --print-join-command" master-1
    join_token=$(vagrant ssh -c "kubeadm token list -o json" master-1 | jq .token)
fi

ca_cert_hash=$(vagrant ssh -c "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'" master-1)



for ((n=2;n<=$NUM_MASTER_NODE;n++))
  do
    echo "Please wait join master-$n"
    vagrant ssh -c "sudo kubeadm join 192.168.1.30:6443 --token $join_token --discovery-token-ca-cert-hash sha256:${ca_cert_hash//[[:blank:]]/} --control-plane" master-$n
  done

for ((n=1;n<=$NUM_WORKER_NODE;n++))
  do
    echo "Please wait join node-$n"
    vagrant ssh -c "sudo kubeadm join 192.168.1.30:6443 --token $join_token --discovery-token-ca-cert-hash sha256:$ca_cert_hash" node-$n
  done
