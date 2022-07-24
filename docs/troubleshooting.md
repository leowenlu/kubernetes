1. `kubectl describe daemonsets/weave-net -n kube-system`
2. `sudo journalctl  -l --no-pager -u kubelet.service -f`
3. ` kubectl describe node worker-1`™