#!/bin/bash

set -e

# ==============================================================================
# Litmus Chaos GitHub Action Environment Variables
# ==============================================================================
# The following environment variables can be set to customize chaos experiments:
#
# REQUIRED SDK Authentication Variables:
#   LITMUS_ENDPOINT     - URL of Litmus Chaos Center (default: http://localhost:9091)
#   LITMUS_USERNAME     - Username for authentication (default: admin)
#   LITMUS_PASSWORD     - Password for authentication (default: litmus)
#   LITMUS_PROJECT_ID   - Project ID in Litmus (default: admin-project)
#
# Common Environment Variables:
#   KUBECONFIG               - Path to kubeconfig file (default: /home/runner/.kube/config)
#   APP_NS                   - Application namespace (default: litmus)
#   INSTALL_INFRA           - Whether to install infrastructure (default: true)
#   ACTIVATE_INFRA          - Whether to activate infrastructure (default: true)
#   CREATE_ENV              - Whether to create environment (default: true)
#   ENV_NAME                - Environment name (default: ci-test-env)
#   ENV_TYPE                - Environment type (default: NON_PROD)
#   INFRA_NAMESPACE         - Infrastructure namespace (default: litmus)
#   INFRA_ACTIVATION_TIMEOUT - Timeout for infrastructure activation (default: 5)
#
# Probe Configuration:
#   LITMUS_CREATE_PROBE         - Create probe (default: true)
#   LITMUS_USE_EXISTING_PROBE   - Use existing probe (default: false)
#   LITMUS_PROBE_TYPE           - Probe type (default: httpProbe)
#   LITMUS_PROBE_MODE           - Probe mode (default: SOT)
#   LITMUS_PROBE_TIMEOUT        - Probe timeout (default: 30s)
#   LITMUS_PROBE_INTERVAL       - Probe interval (default: 10s)
#   LITMUS_PROBE_ATTEMPTS       - Probe attempts (default: 1)
#   LITMUS_PROBE_RESPONSE_CODE  - Expected response code (default: 200)
#
# Experiment-Specific Variables (auto-set based on EXPERIMENT_NAME):
#   APP_LABEL           - Application label for targeting
#   INFRA_NAME          - Infrastructure name
#   INFRA_SCOPE         - Infrastructure scope (cluster/namespace)
#   LITMUS_PROBE_NAME   - Probe name
#   LITMUS_PROBE_URL    - Probe URL
#
# Special Variables for container-kill experiment:
#   SOCKET_PATH         - Container runtime socket path
#   CONTAINER_RUNTIME   - Container runtime type
# ==============================================================================

##Extract the base64 encoded config data and write this to the KUBECONFIG
if [ ! -z "$KUBE_CONFIG_DATA" ]
then
  mkdir -p ${HOME}/.kube
  echo "$KUBE_CONFIG_DATA" | base64 --decode > ${HOME}/.kube/config
  export KUBECONFIG=${HOME}/.kube/config
fi 

##Setup AWS credentials if provided
if [[ ! -z $AWS_ACCESS_KEY_ID ]] && [[ ! -z $AWS_SECRET_ACCESS_KEY ]] && [[ ! -z $AWS_DEFAULT_REGION ]]
then 
  aws configure set default.region ${AWS_DEFAULT_REGION}
  aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
  aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
fi

# Set default values for common environment variables
export KUBECONFIG=${KUBECONFIG:-"/home/runner/.kube/config"}
export LITMUS_ENDPOINT=${LITMUS_ENDPOINT:-"http://localhost:9091"}
export LITMUS_USERNAME=${LITMUS_USERNAME:-"admin"}
export LITMUS_PASSWORD=${LITMUS_PASSWORD:-"litmus"}
export LITMUS_PROJECT_ID=${LITMUS_PROJECT_ID:-"admin-project"}

# Application and Infrastructure Setup
export APP_NS=${APP_NS:-"litmus"}
export INSTALL_INFRA=${INSTALL_INFRA:-"true"}
export ACTIVATE_INFRA=${ACTIVATE_INFRA:-"true"}
export CREATE_ENV=${CREATE_ENV:-"true"}
export ENV_NAME=${ENV_NAME:-"ci-test-env"}
export ENV_TYPE=${ENV_TYPE:-"NON_PROD"}
export INFRA_NAMESPACE=${INFRA_NAMESPACE:-"litmus"}
export INFRA_ACTIVATION_TIMEOUT=${INFRA_ACTIVATION_TIMEOUT:-"5"}

# Probe Configuration
export LITMUS_CREATE_PROBE=${LITMUS_CREATE_PROBE:-"true"}
export LITMUS_USE_EXISTING_PROBE=${LITMUS_USE_EXISTING_PROBE:-"false"}
export LITMUS_PROBE_TYPE=${LITMUS_PROBE_TYPE:-"httpProbe"}
export LITMUS_PROBE_MODE=${LITMUS_PROBE_MODE:-"SOT"}
export LITMUS_PROBE_TIMEOUT=${LITMUS_PROBE_TIMEOUT:-"30s"}
export LITMUS_PROBE_INTERVAL=${LITMUS_PROBE_INTERVAL:-"10s"}
export LITMUS_PROBE_ATTEMPTS=${LITMUS_PROBE_ATTEMPTS:-"1"}
export LITMUS_PROBE_RESPONSE_CODE=${LITMUS_PROBE_RESPONSE_CODE:-"200"}

# Set experiment-specific defaults based on experiment name
case "$EXPERIMENT_NAME" in
  "container-kill")
    export APP_LABEL=${APP_LABEL:-"app=nginx-container-kill"}
    export INFRA_NAME=${INFRA_NAME:-"ci-infra-container-kill"}
    export INFRA_SCOPE=${INFRA_SCOPE:-"cluster"}
    export LITMUS_PROBE_NAME=${LITMUS_PROBE_NAME:-"ci-http-probe-container-kill"}
    export LITMUS_PROBE_URL=${LITMUS_PROBE_URL:-"http://nginx-service-container-kill.litmus.svc.cluster.local:80"}
    export SOCKET_PATH=${SOCKET_PATH:-"/run/containerd/containerd.sock"}
    export CONTAINER_RUNTIME=${CONTAINER_RUNTIME:-"containerd"}
    ;;
  "node-cpu-hog"|"node-memory-hog"|"node-io-stress")
    export APP_LABEL=${APP_LABEL:-"app=nginx-${EXPERIMENT_NAME}"}
    export INFRA_NAME=${INFRA_NAME:-"ci-infra-${EXPERIMENT_NAME}"}
    export INFRA_SCOPE=${INFRA_SCOPE:-"cluster"}
    export LITMUS_PROBE_NAME=${LITMUS_PROBE_NAME:-"ci-http-probe-${EXPERIMENT_NAME}"}
    export LITMUS_PROBE_URL=${LITMUS_PROBE_URL:-"http://nginx-service-${EXPERIMENT_NAME}.litmus.svc.cluster.local:80"}
    ;;
  "disk-fill"|"pod-autoscaler"|"pod-cpu-hog"|"pod-delete"|"pod-memory-hog"|"pod-network-corruption"|"pod-network-duplication"|"pod-network-latency"|"pod-network-loss")
    export APP_LABEL=${APP_LABEL:-"app=nginx-${EXPERIMENT_NAME}"}
    export INFRA_NAME=${INFRA_NAME:-"ci-infra-${EXPERIMENT_NAME}"}
    export INFRA_SCOPE=${INFRA_SCOPE:-"namespace"}
    export LITMUS_PROBE_NAME=${LITMUS_PROBE_NAME:-"ci-http-probe-${EXPERIMENT_NAME}"}
    export LITMUS_PROBE_URL=${LITMUS_PROBE_URL:-"http://nginx-service-${EXPERIMENT_NAME}.litmus.svc.cluster.local:80"}
    ;;
  *)
    # Default values for unspecified experiments
    export APP_LABEL=${APP_LABEL:-"app=nginx"}
    export INFRA_NAME=${INFRA_NAME:-"ci-infra-default"}
    export INFRA_SCOPE=${INFRA_SCOPE:-"namespace"}
    export LITMUS_PROBE_NAME=${LITMUS_PROBE_NAME:-"ci-http-probe-default"}
    export LITMUS_PROBE_URL=${LITMUS_PROBE_URL:-"http://nginx-service.litmus.svc.cluster.local:80"}
    ;;
esac

# Set default values for experiment configuration
EXPERIMENT_IMAGE=${EXPERIMENT_IMAGE:-"litmuschaos/go-runner"}
EXPERIMENT_IMAGE_TAG=${EXPERIMENT_IMAGE_TAG:-"3.18.0"}
TOTAL_CHAOS_DURATION=${TOTAL_CHAOS_DURATION:-60}

# Map experiment names to their corresponding scripts in chaos-ci-lib
case "$EXPERIMENT_NAME" in
  "pod-delete")
    /app/pod-delete
    ;;
  "container-kill")
    /app/container-kill
    ;;
  "pod-cpu-hog")
    /app/pod-cpu-hog
    ;;
  "pod-memory-hog")
    /app/pod-memory-hog
    ;;
  "node-cpu-hog")
    /app/node-cpu-hog
    ;;
  "node-memory-hog")
    /app/node-memory-hog
    ;;
  "node-io-stress")
    /app/node-io-stress
    ;;
  "disk-fill")
    /app/disk-fill
    ;;
  "pod-network-latency")
    /app/pod-network-latency
    ;;
  "pod-network-loss")
    /app/pod-network-loss
    ;;
  "pod-network-corruption")
    /app/pod-network-corruption
    ;;
  "pod-network-duplication")
    /app/pod-network-duplication
    ;;
  "pod-autoscaler")
    /app/pod-autoscaler
    ;;
  "all")
    /app/all-experiments
    ;;
  *)
    echo "Unknown experiment: $EXPERIMENT_NAME"
    echo "Available experiments: pod-delete, container-kill, pod-cpu-hog, pod-memory-hog, node-cpu-hog, node-memory-hog, node-io-stress, disk-fill, pod-network-latency, pod-network-loss, pod-network-corruption, pod-network-duplication, pod-autoscaler, all"
    exit 1
    ;;
esac

# Handle Litmus cleanup after experiment if requested
if [ "$LITMUS_CLEANUP" = "true" ] && [ ! -z "$EXPERIMENT_NAME" ]; then
  echo "Cleaning up Litmus after experiment..."
  /app/uninstall-litmus
fi
