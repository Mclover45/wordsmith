ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

# Install common apps
RUN apt-get update 
RUN apt-get install -y curl 
# Kops install
RUN curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64 \
    && chmod +x kops \
    && mv kops /usr/local/bin/kops
# Kubectl install
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl
# istio install
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.13.2 TARGET_ARCH=x86_64 sh - \
    && chmod +x istio-1.13.2/bin/istioctl \
    && mv istio-1.13.2/bin/istioctl /usr/local/bin/istioctl
# Helm install
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh

ENTRYPOINT ["/bin/bash"]