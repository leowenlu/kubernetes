#! /bin/bash
# "Set env"

source ../scripts/set_env_from_file.sh -f ../scripts/env.cfg
USR_BIN_PATH=/usr/local/bin

#sudo mkdir -p /opt/cni/bin

cd ../downloads
# Download cni
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz" -o "cni-plugins-linux-${ARCH}-${CNI_VERSION}.tgz"

## crictl
curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz" -o "crictl-${CRICTL_VERSION}-linux-${ARCH}.tar.gz"

## download ubeadm,kubelet,kubectl
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${KUBENETES_VERSION}/bin/linux/${ARCH}/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}



curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${KUBEADMIN_RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service" | sed "s:/usr/bin:${USR_BIN_PATH}:g" | tee kubelet.service
#sudo mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/release/${KUBEADMIN_RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf" | sed "s:/usr/bin:${USR_BIN_PATH}:g" | tee 10-kubeadm.conf