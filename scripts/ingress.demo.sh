#!/bin/bash

# copy file to workstation
vagrant scp ../concepts/examples master-1:~/examples

echo " deploy demo app"
vagrant ssh -c "kubectl apply -f ~/examples/leo_flask_demo.yml; kubectl apply -f ~/examples/leo_demo_service.yml" master-1
vagrant ssh -c "kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/baremetal/deploy.yaml" master-1


vagrant ssh -c "kubectl apply -f ~/examples/leo_demo_ingress.yml"  master-1

# get ingress-nginx-controller port number.
# update haproxy.cfg with the port number.
kubectl get svc -A | grep ingress-nginx-controller

