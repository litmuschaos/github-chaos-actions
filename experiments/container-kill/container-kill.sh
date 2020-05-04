#!/bin/sh

set -e

##Running pod delete experiment
echo "##########################################################"
echo "#######     RUNNING CONTAINER KILL EXPERIMENT      #######"
echo "##########################################################"

##Fetching the RBAC file
printf "Creating RBAC for container-kill experiment\n"
git clone https://github.com/litmuschaos/chaos-charts.git

##Changing the required fild
sed -i 's/namespace: default/namespace: '"$APP_NS"'/' chaos-charts/charts/generic/container-kill/rbac.yaml
## Creating the Service Account for the experiment
sh -c "kubectl apply -f chaos-charts/charts/generic/container-kill/rbac.yaml -n $APP_NS"
echo "Service Account has been created"

##Creating container-kill experiment
printf "Creating container-kill experiment\n"
sh -c "kubectl create -f chaos-charts/charts/generic/container-kill/experiment.yaml -n $APP_NS"
echo "Chaos Eperiment has been created"

##Fetching the engine file
printf "Creating engine for container-kill experiment\n"
##Changing the required fild
sed -i "s/namespace: default/namespace: '"$APP_NS"'/g;"\
"s/name: nginx-chaos/name: engine2/g;"\
"s/appns: 'default'/appns: "$APP_NS"/g;"\
"s/jobCleanUpPolicy: 'delete'/jobCleanUpPolicy: retain/g;"\
"s/applabel: 'app=nginx'/applabel: '"$APP_LABEL"'/g" chaos-charts/charts/generic/container-kill/engine.yaml
##Modify ENVs of chaos engine
sed -i "/name: TARGET_CONTAINER/{n;s/.*/              value: '"$TARGET_CONTAINER"'/}" chaos-charts/charts/generic/container-kill/engine.yaml
## Creating the ChaosEngine for the experiment
sh -c "kubectl apply -f chaos-charts/charts/generic/container-kill/engine.yaml"
echo "ChaosEngine for container-kill has been created"

##Waiting for engine to come in running state
printf "Waiting for the runner pod to come in running state\n"
sleep 15
runnerPodStatus=$(kubectl get pod engine2-runner -n $APP_NS --no-headers -o custom-columns=:status.phase)
echo "$runnerPodStatus"

##Waiting for Runner pod to get completed
while [ $runnerPodStatus != "Succeeded" ]; do
  echo "Runner pod is in ${runnerPodStatus} state please wait"
  runnerPodStatus=$(kubectl get pod engine2-runner -n $APP_NS --no-headers -o custom-columns=:status.phase)
  sleep 10
done

##Getting the experiment pod namespace
jobpodName=$(kubectl get pod -l name=container-kill -n $APP_NS -o custom-columns=:metadata.name)

kubectl logs $jobpodName -n $APP_NS

##Getting the verdict of chaosresult
chaosResultVerdict=$(kubectl get chaosresult engine2-container-kill -n $APP_NS -o jsonpath='{.status.experimentstatus.verdict}')
echo "Verdict is: $chaosResultVerdict"
if [ $chaosResultVerdict = "Pass" ]
then
   echo "Congratulations the verdict of the experiment is: ${chaosResultVerdict}"
else
    echo "Chaos result verdict is: ${chaosResultVerdict}"
    exit 1
fi

