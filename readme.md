This document is about to create a kubernetes cluster from scatch, this step-by-step instruction will provide a guide to setup your first cluster.

## Prerequirement

`vagrant plugin install vagrant-scp`
## Kubernets on VirtualBox
* This tutorial walks you through setting up Kubernetes the hard way on a local machine using VirtualBox.
* This lab is optimized for learning, it's not a fully automated command to bring up a Kubernets cluster.

Ref: [Kelsey Hightower](https://github.com/kelseyhightower/kubernetes-the-hard-way).
ref: [kubernetes-the-hard-way](https://github.com/mmumshad/kubernetes-the-hard-way)

## Cluster Details

* kubernetes v1.20.0
* docker
* coredns
* cni
* etcd v3.4.15

* [Kubernetes](https://github.com/kubernetes/kubernetes)
* [Docker Container Runtime](https://github.com/containerd/containerd)
* [CNI Container Networking](https://github.com/containernetworking/cni)
* [Weave Networking](https://www.weave.works/docs/net/latest/kubernetes/kube-addon/)
* [etcd](https://github.com/coreos/etcd)
* [CoreDNS](https://github.com/coredns/coredns)

## Prequeistes
I am running this lab with my laptop which is Macbook Pro 2.6 GHz 6-Core Intel Core i7, for  [VirtualBox](https://www.virtualbox.org) and  [Vagrant](https://www.vagrantup.com/)  on any supported platforms as below should be ok:
- Windows
- Linux
- Mac


## Set's IP addresses in the range

    | VM            |  VM Name | Purpose       | IP           | Forwarded Port   |
    | ------------  | -------- |:-------------:| ------------:| ----------------:|
    | master-1      | master-1 | Master        | 192.168.1.11 |     2711         |
    | master-2      | master-2 | Master        | 192.168.1.12 |     2712         |
    | worker-1      | worker-1 | Worker        | 192.168.1.21 |     2721         |
    | worker-2      | worker-2 | Worker        | 192.168.1.22 |     2722         |
    | loadbalancer  | lb       | LoadBalancer  | 192.168.1.30 |     2730         |


## Labs

## TODO
1. currently the `workstation` is used to init the k8s setup, work need to do to make a to admin k8s.


## labs to do  [X]
1. currently the `workstation` is used to init the k8s setup, work need to do to make a to admin k8s.


## labs

 kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
