# workstation
LOADBALANCER_ADDRESS=192.168.1.30

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

    kubectl config use-context default --kubeconfig=${instance}.kubeconfig
    scp ca.crt ${instance}.crt ${instance}.key ${instance}.kubeconfig ${instance}:~/
done


