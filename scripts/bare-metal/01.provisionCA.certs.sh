## the following two lines have been moved to 00.copyBinaryFiles.sh
# sudo cp ~/downloads/kubectl ~/downloads/kube-apiserver ~/downloads/kube-controller-manager ~/downloads/kube-scheduler /usr/bin/
# sudo chmod +x /usr/bin/kube*
# Create private key for CA
openssl genrsa -out ca.key 2048

# Comment line starting with RANDFILE in /etc/ssl/openssl.cnf definition to avoid permission issues
sudo sed -i '0,/RANDFILE/{s/RANDFILE/\#&/}' /etc/ssl/openssl.cnf
# Create CSR using the private key
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
# Self sign the csr using its own private key
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial  -out ca.crt -days 1000

# Generate private key for admin user
openssl genrsa -out admin.key 2048
# Generate CSR for admin user. Note the OU.
openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr
# Sign certificate for admin user using CA servers private key
openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out admin.crt -days 1000


# The Controller Manager Client Certificate
openssl genrsa -out kube-controller-manager.key 2048
openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr
openssl x509 -req -in kube-controller-manager.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-controller-manager.crt -days 1000

# The Kube Proxy Client Certificate
openssl genrsa -out kube-proxy.key 2048
openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr
openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-proxy.crt -days 1000

# The Scheduler Client Certificate
openssl genrsa -out kube-scheduler.key 2048
openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr
openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-scheduler.crt -days 1000

# The Kubernetes API Server Certificate
cat > openssl.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.0.1
IP.2 = 192.168.1.11
IP.3 = 192.168.1.12
IP.5 = 192.168.1.30
IP.6 = 127.0.0.1
EOF

openssl genrsa -out kube-apiserver.key 2048
openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl.cnf
openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf -days 1000


# The ETCD Server Certificate
cat > openssl-etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 192.168.1.11
IP.2 = 192.168.1.12
IP.3 = 127.0.0.1
EOF

openssl genrsa -out etcd-server.key 2048
openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr -config openssl-etcd.cnf
openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf -days 1000

# The Service Account Key Pair

openssl genrsa -out service-account.key 2048
openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out service-account.crt -days 1000
# read -n 1 -s -r -p "Check the output if right, then press any key to continue"
for instance in master-1 master-2
  do
    scp ca.crt ca.key kube-apiserver.key kube-apiserver.crt \
    service-account.key service-account.crt \
    etcd-server.key etcd-server.crt \
    ${instance}:~
  done

LOADBALANCER_ADDRESS=192.168.1.30
# workers

for instance in worker-1 worker-2
  do
    cat > openssl-${instance}.cnf <<EOF
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = worker-2
    IP.1 = 192.168.5.22
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
