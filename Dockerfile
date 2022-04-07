ARG UBUNTU_VERSION=20.04

FROM ubuntu:${UBUNTU_VERSION}

# Install common apps
RUN apt-get update \
    && apt-get install -y curl \
    && apt-get install -y  unzip \
    && apt-get install -y git \
    && apt-get install -y make 
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
# AWS Cli install
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
# Go install
RUN curl -OL https://go.dev/dl/go1.18.linux-amd64.tar.gz \
    && tar -C /usr/local -xvf go1.18.linux-amd64.tar.gz \
    && export PATH=$PATH:/usr/local/go/bin
RUN mkdir -p $GOPATH/src/go.mozilla.org/sops/ \
    && git clone https://github.com/mozilla/sops.git $GOPATH/src/go.mozilla.org/sops/ 
RUN cd $GOPATH/src/go.mozilla.org/sops/ \
    && git checkout develop \
    && apt-get install -y make \
    && export PATH=$PATH:/usr/local/go/bin \ 
    && make install 
ENTRYPOINT ["/bin/bash"]