sudo apt-get update && sudo apt-get install -y haproxy
cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg
global
    maxconn 512
    spread-checks 5
    log 127.0.0.1 local0
defaults
    retries 3
    option  redispatch
    timeout client 30s
    timeout connect 4s
    timeout server 30s

frontend kubernetes
    log global
    bind *:6443
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server master-1 192.168.1.11:6443 check fall 3 rise 2
    server master-2 192.168.1.12:6443 check fall 3 rise 2

frontend Local_Server
    bind 192.168.101.252:80
    mode http
    default_backend k8s_server
    log global
backend k8s_server
    mode http
    balance roundrobin
    server node-1 192.168.1.21:30745 check fall 3 rise 2
    server node-2 192.168.1.22:30745 check fall 3 rise 2
EOF

sudo ip route delete default
sudo ip route add default via 192.168.101.1
sudo systemctl restart haproxy
``