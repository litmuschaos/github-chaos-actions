FROM golang:latest

LABEL name="Kubernetes Chaos"
LABEL repository="http://github.com/mayadata-io/github-chaos-actions"
LABEL homepage="http://github.com/mayadata-io/github-chaos-actions"

LABEL maintainer="LitmusChaos"
LABEL com.github.actions.name="Kubernetes Chaos"
LABEL com.github.actions.description="Different Chaos Experiment for Kubernetes"
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

ARG KUBECTL_VERSION=1.17.0
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

RUN apt-get update && apt-get install -y git && \
    apt-get install -y ssh && \
    apt install ssh rsync

COPY README.md /
COPY entrypoint.sh /entrypoint.sh
COPY experiments ./experiments

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
