FROM golang:latest

LABEL version="1.0.0"
LABEL name="Kubernetes Chaos"
LABEL repository="http://github.com/mayadata-io/chaos-actions"
LABEL homepage="http://github.com/mayadata-io/chaos-actions"

LABEL maintainer="Udit Gaurav <udit.gaurav@mayadata.io>"
LABEL com.github.actions.name="Kubernetes Chaos"
LABEL com.github.actions.description="This Action can perform chaos engineering in Kubernetes system"
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

RUN apt-get update && apt-get install -y git
RUN apt-get update && apt-get install -y ssh 
RUN apt install ssh rsync

COPY LICENSE README.md /
COPY entrypoint.sh /entrypoint.sh
COPY experiments ./experiments

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
