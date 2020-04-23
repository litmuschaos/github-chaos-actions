#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
mkdir -p ${HOME}/.kube
echo "$KUBE_CONFIG_DATA" | base64 --decode > ${HOME}/.kube/config
export KUBECONFIG=${HOME}/.kube/config

#Setup 
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
mkdir -p $HOME/go/src/github.com/uditgaurav
rsync -az --delete ${GOPATH}/src/github.com/uditgaurav/
cd ${GOPATH}/src/github.com/uditgaurav/
git clone https://github.com/uditgaurav/central-ci.git
cd central-ci

##Install litmus if it is not already installed
if [ $INSTALL_LITMUS = true ]
then
  go test tests/install-litmus_test.go -v -count=1
fi

##Select an experiment 
if [ $EXPERIMENT_NAME = "pod-delete" ]
then
  go test tests/${EXPERIMENT_NAME}_test.go -v -count=1
fi

##litmus cleanup
if [ $LITMUS_CLEANUP = true ]
then
  go test tests/uninstall-litmus_test.go -v -count=1
fi
