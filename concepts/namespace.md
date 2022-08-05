---
Date: 07-28-2022
Title: kubernetes namespaces
Tags:
    - namespaces
---
Kubernetes `namespaces` help different projects, teams, or customers to share a Kubernetes cluser.

* a scope for Names
* A machnism to attach authorization and policy to a subsection of the cluster.


# create new namespaces

```
kubectl create ns demo
kubectl create ns gitlab
```

## Namespaces and DNS
When you create a Service, it creates a corresponding DNS entry. This entry is of the form <service-name>.<namespace-name>.svc.cluster.local, which means that if a container only uses <service-name>, it will resolve to the service which is local to a namespace. This is useful for using the same configuration across multiple namespaces such as Development, Staging and Production. If you want to reach across namespaces, you need to use the fully qualified domain name (FQDN).