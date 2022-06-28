
sudo mkdir -p \
/etc/cni/net.d \
/opt/cni/bin \
/var/lib/kubelet \
/var/lib/kube-proxy \
/var/lib/kubernetes \
/var/run/kubernetes

chmod +x kubectl kube-proxy kubelet

sudo cp ${HOSTNAME}.key ${HOSTNAME}.crt /var/lib/kubelet/
sudo cp ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo cp ca.crt /var/lib/kubernetes/

cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
    kind: KubeletConfiguration
    apiVersion: kubelet.config.k8s.io/v1beta1
    authentication:
    anonymous:
      enabled: false
    webhook:
      enabled: true
    x509:
        clientCAFile: "/var/lib/kubernetes/ca.crt"
    authorization:
      mode: Webhook
    clusterDomain: "cluster.local"
    clusterDNS:
      - "10.96.0.10"
    resolvConf: "/run/systemd/resolve/resolv.conf"
    runtimeRequestTimeout: "15m"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
    [Unit]
    Description=Kubernetes Kubelet
    Documentation=https://github.com/kubernetes/kubernetes
    After=docker.service
    Requires=docker.service

    [Service]
    ExecStart=/usr/local/bin/kubelet \\
    --config=/var/lib/kubelet/kubelet-config.yaml \\
    --image-pull-progress-deadline=2m \\
    --kubeconfig=/var/lib/kubelet/kubeconfig \\
    --tls-cert-file=/var/lib/kubelet/${HOSTNAME}.crt \\
    --tls-private-key-file=/var/lib/kubelet/${HOSTNAME}.key \\
    --cgroup-driver=systemd \\
    --network-plugin=cni \\
    --register-node=true \\
    --v=2
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
EOF


sudo cp kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig

cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
    kind: KubeProxyConfiguration
    apiVersion: kubeproxy.config.k8s.io/v1alpha1
    clientConnection:
      kubeconfig: "/var/lib/kube-proxy/kubeconfig"
    mode: "iptables"
    clusterCIDR: "192.168.1.0/24"
EOF

echo "created kube-proxy-config.yaml "

cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
    [Unit]
    Description=Kubernetes Kube Proxy
    Documentation=https://github.com/kubernetes/kubernetes

    [Service]
    ExecStart=/usr/local/bin/kube-proxy \\
    --config=/var/lib/kube-proxy/kube-proxy-config.yaml
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable kubelet kube-proxy
    sudo systemctl restart kubelet kube-proxy
