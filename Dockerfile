FROM golang:latest

LABEL name="Kubernetes Chaos"
LABEL repository="http://github.com/litmuschaos/github-chaos-actions"
LABEL homepage="http://github.com/litmuschaos/github-chaos-actions"

LABEL maintainer="LitmusChaos"
LABEL com.github.actions.name="Kubernetes Chaos"
LABEL com.github.actions.description="Different Chaos Experiment for Kubernetes"
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

ENV GOPATH=/github/home/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
ARG HELM_VERSION=3.2.3
ARG RELEASE_ROOT="https://get.helm.sh"
ARG RELEASE_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

ARG KUBECTL_VERSION=1.22.0
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

RUN apt-get update && apt-get install -y git \
    curl \
    unzip \
    pipx \
    && apt-get clean

RUN apt-get update && \
    curl -L ${RELEASE_ROOT}/${RELEASE_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm    

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

RUN pipx install oci-cli==3.29.0

COPY README.md /
COPY entrypoint.sh /entrypoint.sh
COPY experiments ./experiments

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
