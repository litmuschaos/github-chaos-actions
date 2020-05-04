#!/bin/sh

set -e

##Installing litmus
echo "#########################################"
echo "#######     INSTALLING LITMUS     #######"
echo "#########################################"

echo "Installing Litmus"

kubectl apply -f https://raw.githubusercontent.com/litmuschaos/pages/master/docs/litmus-operator-latest.yaml

echo "Litmus installed successfully"
