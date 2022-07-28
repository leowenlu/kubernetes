#! /bin/bash

# "Set env"
source ../scripts/set_env_from_file.sh -f ../scripts/env.cfg

# copy binary to vm
## download and install cni to both master and node

CNI_BIN_PATH=/opt/cni/bin
USR_BIN_PATH=/usr/local/bin
CNI_TAR_FILE=cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz
CRICTL_TART_FILE=crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz
setup_cni="sudo mkdir -p ${CNI_BIN_PATH}; sudo tar -xzf ./downloads/${CNI_TAR_FILE} -C ${CNI_BIN_PATH};  sudo cp ./downloads/kubelet.service /etc/systemd/system/kubelet.service"
setup_kubeadmin="sudo mkdir -p ${USR_BIN_PATH} /etc/systemd/system/kubelet.service.d/; sudo tar -xzf  ${CRICTL_TART_FILE} -C ${USR_BIN_PATH}; sudo cp ./downloads/10-kubeadm.conf /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
insrall_setup_kube="sudo mkdir -p ${CNI_BIN_PATH} ${USR_BIN_PATH} /etc/systemd/system/kubelet.service.d  ; \
                    sudo tar -xzf ./downloads/${CNI_TAR_FILE} -C ${CNI_BIN_PATH} ; \
                    sudo cp ./downloads/kubelet.service /etc/systemd/system/kubelet.service ; \
                    sudo cp {./downloads/kubeadm,./downloads/kubelet,./downloads/kubectl} ${USR_BIN_PATH} ; \
                    sudo tar -xzf  ./downloads/${CRICTL_TART_FILE} -C ${USR_BIN_PATH} ; \
                    sudo cp ./downloads/10-kubeadm.conf /etc/systemd/system/kubelet.service.d/10-kubeadm.conf ; \
                    sudo systemctl enable --now kubelet \n
                    "

for ((n=1;n<=$NUM_MASTER_NODE;n++))
  do
    echo "coping files from ../downloads to master-${n} "
    vagrant scp ../downloads/ master-$n:~
    echo "Ceating and seting up cni crictl and kubectl kubadmin "
    vagrant ssh -c "${insrall_setup_kube}" master-$n
  done

for ((n=1;n<=$NUM_WORKER_NODE;n++))
  do
    echo "coping files from ../downloads to node-${n} "
    vagrant scp ../downloads/ node-$n:~
    echo "Ceating and seting up cni crictl and kubectl kubadmin "
    vagrant ssh -c "${insrall_setup_kube}" node-$n
  done
#troubleshoot

# sudo journalctl -xeu kubelet