LOADBALANCER_ADDRESS=192.168.1.30

#The kube-proxy Kubernetes Configuration File

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.crt \
  --embed-certs=true \
  --server=https://${LOADBALANCER_ADDRESS}:6443 \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=kube-proxy.crt \
  --client-key=kube-proxy.key \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

# The kube-controller-manager Kubernetes Configuration File

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.crt \
    --client-key=kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

# The kube-scheduler Kubernetes Configuration File

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.crt \
    --client-key=kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

# The admin Kubernetes Configuration File
  KUBERNETES_LB_ADDRESS=192.168.1.30
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.crt \
    --client-key=admin.key \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig

# The kubelet Kubernetes Configuration File
for instance in worker-1 worker-2; do
    # Provisioning Kubelet Client Certificates
    IP=$(host -t A $instance | awk '{print $4}')
    cat <<EOF | tee openssl-${instance}.cnf
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = ${instance}
    IP.1 = ${IP}
EOF

  openssl genrsa -out ${instance}.key 2048
  openssl req -new -key ${instance}.key -subj "/CN=system:node:${instance}/O=system:nodes" -out ${instance}.csr -config openssl-${instance}.cnf
  openssl x509 -req -in ${instance}.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out ${instance}.crt -extensions v3_req -extfile openssl-${instance}.cnf -days 1000
  # The kubelet Kubernetes Configuration File
  kubectl config set-cluster kubernetes-the-hard-way \
      --certificate-authority=ca.crt \
      --embed-certs=true \
      --server=https://${LOADBALANCER_ADDRESS}:6443 \
      --kubeconfig=${instance}.kubeconfig
  kubectl config set-credentials system:node:${instance} \
      --client-certificate=${instance}.crt \
      --client-key=${instance}.key \
      --embed-certs=true \
      --kubeconfig=${instance}.kubeconfig
  kubectl config set-context default \
      --cluster=kubernetes-the-hard-way \
      --user=system:node:${instance} \
      --kubeconfig=${instance}.kubeconfig
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://${LOADBALANCER_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.crt \
    --client-key=${instance}.key \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig
  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
  scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done

for instance in master-1 master-2; do
  scp kube-controller-manager.kubeconfig kube-scheduler.kubeconfig admin.kubeconfig ${instance}:~/
done
