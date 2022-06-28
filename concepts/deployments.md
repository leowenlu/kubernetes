## what is deployments

A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

* one example of deployment

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
kubectl create deployment leotest  --image=leowenlu/test:latest


``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: leo-app-demo
  labels:
    app: leoflaskdemo
spec:
  replicas: 2
  selector:
    matchLabels:
       app: leoflaskdemo
  template:
    metadata:
      labels:
        app: leoflaskdemo
    spec:
      containers:
      - name: leoflaskapp
        image: leowenlu/flask:demo
        ports:
        - containerPort: 8080
```

1. Create the Deployment by running the following command:
` kubectl apply -f concepets/examples/leo_flask_demo.yml `

2. Run `kubectl get deployments` to check if the Deployment was created.
``` bash
vagrant@master-1:~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
leo-app-demo-5f65764f75-jrkwd   1/1     Running   0          105s
leo-app-demo-5f65764f75-t5vw6   1/1     Running   0          105s

vagrant@master-1:~$ kubectl get deployments leo-app-demo
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
leo-app-demo   2/2     2            2           10m

```
3. To see the Deployment rollout status, run `kubectl rollout status`

```
vagrant@master-1:~$ kubectl rollout status deployment/leo-app-demo
deployment "leo-app-demo" successfully rolled out
```

4. To see the ReplicaSet (rs) created by the Deployment, run `kubectl get rs`. The output is similar to this:

```
vagrant@master-1:~$ kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
leo-app-demo-5f65764f75   2         2         2       12m
```

5. To see the labels automatically generated for each Pod, run kubectl get pods --show-labels. The output is similar to:

```
vagrant@master-1:~$ kubectl get pods --show-labels
NAME                            READY   STATUS    RESTARTS   AGE   LABELS
leo-app-demo-5f65764f75-jrkwd   1/1     Running   0          13m   app=leoflaskdemo,pod-template-hash=5f65764f75
leo-app-demo-5f65764f75-t5vw6   1/1     Running   0          13m   app=leoflaskdemo,pod-template-hash=5f65764f75
```

## Pod-template-hash label
The `pod-template-hash` label is added by the Deployment controller to every ReplicaSet that a Deployment creates or adopts.

This label ensures that child ReplicaSets of a Deployment do not overlap. It is generated by hashing the PodTemplate of the ReplicaSet and using the resulting hash as the label value that is added to the ReplicaSet selector, Pod template labels, and in any existing Pods that the ReplicaSet might have.

> Caution: Do not change this label.


## Updating a Deployment
> Note: A Deployment's rollout is triggered if and only if the Deployment's Pod template (that is, .spec.template) is changed, for example if the labels or container images of the template are updated. Other updates, such as scaling the Deployment, do not trigger a rollout.

If `kubectl edit deployment/leo-app-demo` and change `spec.replicas=2` to `spec.replicas=1`, then:

```
vagrant@master-1:~$ kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
leo-app-demo-5f65764f75   1         1         1       25m
```

## Rolling Back a Deployment


## Checking Rollout History of a Deployment