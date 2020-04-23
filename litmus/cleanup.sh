#!/bin/sh

set -e

##Uninstalling litmus
echo "###########################################"
echo "#######     UNINSTALLING LITMUS     #######"
echo "###########################################"

##Deleting Chaos Experiment
echo "Removing chaos experiment"
kubectl delete chaosexperiment $EXPERIMENT_NAME -n $APP_NS

##Deleting Experiment Service Account
echo "Removing service account"
serviceaccountname="${EXPERIMENT_NAME}-sa"
kubectl delete serviceaccount $serviceaccountname -n $APP_NS
echo "Experiment serviceaccount deleted successfully"

##Deleting Chaos Engine
echo "Removing chaos engine"
kubectl delete chaosengine -n $APP_NS --all
echo "Chaos Engine deleted successfully"

##Deleting operator and other deployments in litmus
kubectl delete deploy -n litmus --all
echo "Operator deleted successfully"

##Deleting litmus namespace
kubectl delete ns litmus
echo "Litmus deleted successfully"
 