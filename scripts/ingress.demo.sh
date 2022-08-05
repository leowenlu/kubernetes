#!/bin/bash


echo " deploy demo app"
kubectl apply -f ../concepts/examples/leo_flask_demo.yml -n demo
kubectl apply -f ../concepts/examples/leo_demo_service.yml -n demo
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/baremetal/deploy.yaml
kubectl apply -f ../concepts/examples/leo_demo_ingress.yml -n demo

# get ingress-nginx-controller port number.
# update haproxy.cfg with the port number.
kubectl get service -A