#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

##Install litmus if it is not already installed
if [ $INSTALL_LITMUS = true ]
then
  sh /litmus/installation.sh
fi

##Select an experiment 
if [ $EXPERIMENT_NAME = "pod-delete" ]
then
  sh /experiments/pod-delete/pod-delete.sh

elif [ $EXPERIMENT_NAME = "container-kill" ]
then
  sh /experiments/container-kill/container-kill.sh

elif [ $EXPERIMENT_NAME = "node-cpu-hog" ]
then
  sh /experiments/node-cpu-hog/node-cpu-hog.sh

elif [ $EXPERIMENT_NAME = "node-memory-hog" ]
then
  sh /experiments/node-memory-hog/node-memory-hog.sh

elif [ $EXPERIMENT_NAME = "pod-cpu-hog" ]
then
  sh /experiments/pod-cpu-hog/pod-cpu-hog.sh

elif [ $EXPERIMENT_NAME = "pod-network-corruption" ]
then
  sh /experiments/pod-network-corruption/pod-network-corruption.sh

elif [ $EXPERIMENT_NAME = "pod-network-latency" ]
then
  sh /experiments/pod-network-latency/pod-network-latency.sh

elif [ $EXPERIMENT_NAME = "pod-network-loss" ]
then
  sh /experiments/pod-network-loss/pod-network-loss.sh

fi

##litmus cleanup
if [ $LITMUS_CLEANUP = true ]
then
  sh /litmus/cleanup.sh
fi
