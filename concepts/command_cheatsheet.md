---
Date: 07-06-2022
Title: Kubectl Command Cheatsheet
Tags:
    - kubernetes
    - cheatsheet
---

## Cluster Management

* kubectl cluster-info
* kubectl version
* kubectl config view
* kubectl api-resources
* kubectl api-versions
* kubectl get all --all-namespaces

##  Daemonsets
Shortcode = ds

* kubectl get daemonset
* kubectl edit daemonset <daemonset_name>
* kubectl delete daemonset <daemonset_name>
* kubectl create daemonset <daemonset_name>
* kubectl rollout daemonset
* kubectl describe ds <daemonset_name> -n <namespace_name>


## Deployments
Shortcode = deploy
* kubectl get deployment
* kubectl describe deployment <deployment_name>
* kubectl edit deployment <deployment_name>
* kubectl create deployment <deployment_name>
* kubectl delete deployment <deployment_name>
* kubectl rollout status deployment <deployment_name>

## Events
Shortcode = ev

* kubectl get events
* kubectl get events --field-selector type=Warning
* kubectl get events --field-selector involvedObject.kind!=Pod
* kubectl get events --field-selector involvedObject.kind=Node, involvedObject.name=<node_name>
* kubectl get events --field-selector type!=Normal

## Logs
* kubectl logs <pod_name>
* kubectl logs --since=1h <pod_name>
* kubectl logs --tail=20 <pod_name>
* kubectl logs -f <service_name> [-c <$container>]
* kubectl logs -f <pod_name>
* kubectl logs -c <container_name> <pod_name>
* kubectl logs <pod_name> pod.log
* kubectl logs --previous <pod_name>

## Manifest Files
* kubectl apply -f manifest_file.yaml
* kubectl create -f manifest_file.yaml
* kubectl create -f ‘url’

## Namespaces
* kubectl create namespace <namespace_name>
* kubectl get namespace <namespace_name>
* kubectl describe namespace <namespace_name>
* kubectl delete namespace <namespace_name>
* kubectl edit namespace <namespace_name>
* kubectl top namespace <namespace_name>

## Nodes
* kubectl taint node <node_name>
* kubectl get node
* kubectl delete node <node_name>
* kubectl top node
* kubectl describe nodes | grep Allocated -A 5
* kubectl get pods -o wide | grep <node_name>
* kubectl annotate node <node_name>
* kubectl cordon node <node_name>
* kubectl uncordon node <node_name>
* kubectl drain node <node_name>
* kubectl label node
10.212.75.99ku

## Pods
* kubectl get pod
* kubectl delete pod <pod_name>
* kubectl describe pod <pod_name>
* kubectl create pod <pod_name>
* kubectl exec <pod_name> -c <container_name> <command>
* kubectl exec -it <pod_name> /bin/sh
* kubectl top pod
* kubectl annotate pod <pod_name> <annotation>
* kubectl label pod <pod_name>


## Replication Controllers
Shortcode = rc
* kubectl get replicasets
* kubectl describe replicasets <replicaset_name>
* kubectl scale --replicas=[x]

## Secrets
* kubectl create secret
* kubectl describe secrets
* kubectl delete secret <secret_name>

## Services
* kubectl get services
* kubectl describe services
* kubectl describe serviceaccounts
* kubectl replace serviceaccount
* kubectl delete serviceaccount <service_account_name>


## StatefulSet
Shortcode = sts

* kubectl get statefulset
* kubectl delete statefulset/[stateful_set_name] --cascade=false

