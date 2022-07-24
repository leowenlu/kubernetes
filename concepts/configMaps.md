# What it is
it is an API object that allow you to store data as key-valure paires, k8s pods can use ConfigMaps as configuration files, environment varialbes or command-line arguments.
> ConfigMaps allow you to decouple environment-specific configurations from containers to make applications portable. However, they are not suitable for confidential data storage, instead, use a Secret rather than a ConfigMap.

Another potential drawback of ConfigMaps is that files must be limited to 1MB. Larger datasets may require different storage methods, such as separate file mounts, file services or databases.

## ConfigMaps and Pods

**example**

``` yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: game-demo
data:
  # property-like keys; each key maps to a simple value
  player_initial_lives: "3"
  ui_properties_file_name: "user-interface.properties"

  # file-like keys
  game.properties: |
    enemy.types=aliens,monsters
    player.maximum-lives=5
  user-interface.properties: |
    color.good=purple
    color.bad=yellow
    allow.textmode=true
```

**define container environment variables using ConfigMaps data**

``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        # Define the environment variable
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
              name: special-config
              # Specify the key associated with the value
              key: special.how
  restartPolicy: Never

```
There are four different ways that you can use a ConfigMap to configure a container inside a Pod:

* Inside a container command and args
* Environment variables for a container
* Add a file in read-only volume, for the application to read
* Write code to run inside the Pod that uses the Kubernetes API to read a ConfigMap

# Try it out

[try this link](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
## creating and Viewing

* literal
`kubectl get cm -A`


```
## create
vagrant@master-1:~$ kubectl create cm cm-demo --from-literal=name=leo.li --from-literal=work=auspost
configmap/cm-demo created

## get cm
vagrant@master-1:~$ kubectl get cm
NAME               DATA   AGE
cm-demo            2      31s
kube-root-ca.crt   1      23d

# describe
vagrant@master-1:~$ kubectl describe cm cm-demo
Name:         cm-demo
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
work:
----
auspost
name:
----
leo.li
Events:  <none>
```

* file

``` bash
cat <<EOF | tee leo.properties
name=leo.li
work=auspost
EOF
```

* yaml

## consume
* Create a ConfigMap containing multiple key-value paires
 **configmap/configmap-multikeys.yaml**
``` yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config
  namespace: default
data:
  SPECIAL_LEVEL: very
  SPECIAL_TYPE: charm
```

` kubectl create -f ./configmap-multikeys.yaml `

* pod-configmap-evnFrom.yaml
``` yml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "ls /etc/config/" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        # Provide the name of the ConfigMap containing the files you want
        # to add to the container
        name: special-config
  restartPolicy: Never

```

* add ConfigMap data to Volume

# commands

```bash
kubectl create configmap <name> <data-source>
```