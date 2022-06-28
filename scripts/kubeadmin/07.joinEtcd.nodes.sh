## join etcd
join_token=$(vagrant ssh -c "kubeadm token list -o json" master-1 | jq .token)

ca_cert_hash=$(vagrant ssh -c "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'" master-1)
vagrant ssh -c "sudo kubeadm join 192.168.1.30:6443 --token $join_token --discovery-token-ca-cert-hash sha256:${ca_cert_hash//[[:blank:]]/} --control-plane" master-2

for vm in node-1 node-2
  do
    vagrant ssh -c "sudo kubeadm join 192.168.1.30:6443 --token $join_token --discovery-token-ca-cert-hash sha256:$ca_cert_hash" $vm
  done
