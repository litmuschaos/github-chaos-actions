FROM litmuschaos/chaos-ci-lib:v0.5.0

LABEL name="Kubernetes Chaos"
LABEL repository="http://github.com/litmuschaos/github-chaos-actions"
LABEL homepage="http://github.com/litmuschaos/github-chaos-actions"

LABEL maintainer="LitmusChaos"
LABEL com.github.actions.name="Kubernetes Chaos"
LABEL com.github.actions.description="Different Chaos Experiment for Kubernetes"
LABEL com.github.actions.icon="terminal"
LABEL com.github.actions.color="blue"

COPY README.md /
COPY entrypoint.sh /entrypoint.sh
COPY experiments ./experiments

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
