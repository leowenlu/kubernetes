######################
#  Configure RBAC  #
######################


# Clone the Ingress Controller repo and change into the deployments folder:
git clone https://github.com/nginxinc/kubernetes-ingress.git --branch v2.2.2

# Create a namespace and a service account for the Ingress Controller
cd kubernetes-ingress/deployments
# Create a cluster role and cluster role binding for the service account
kubectl apply -f common/ns-and-sa.yaml
# (App Protect only) Create the App Protect role and role binding:
kubectl apply -f rbac/rbac.yaml
# (App Protect DoS only) Create the App Protect DoS role and role binding:
# kubectl apply -f rbac/apdos-rbac.yaml


############################
#  Create Common Resources
###########################



# Create a secret with a TLS certificate and a key for the default server in NGINX:
kubectl apply -f common/default-server-secret.yaml
# Create a config map for customizing NGINX configuration:
kubectl apply -f common/nginx-config.yaml
# Create an IngressClass resource:
# The IngressClass "nginx" is invalid: spec.controller: Invalid value: "nginx.org/ingress-controller": field is immutable
kubectl apply -f common/ingress-class.yaml


#################################
# Deploy the Ingress Controller
#################################

# run the Ingress Controller by using a Deployment
kubectl apply -f deployment/nginx-ingress.yaml
# Now run it as a Daemon set
kubectl apply -f daemon-set/nginx-ingress.yaml
kubectl get all -n nginx-ingress


#################################
# Deploy test service
#################################



###############################
#   create ingress resource
##############################

## ingress-resource.yaml
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: leodemo-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: mycloud.leoonline.net
    http:
      paths:
      - backend:
          serviceName: leotest-service
          servicePort: 8080
```
kubectl describe ing leodemo-ingress


1. install
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/baremetal/deploy.yaml

## setup default route in lb
sudo ip route delete default
sudo ip route add default via 192.168.101.1