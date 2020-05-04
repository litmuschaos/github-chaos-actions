#!/bin/sh

set -e

##Running pod-memory-hog experiment
echo "#######################################################"
echo "#######     RUNNING POD MEMORY HOG EXPERIMENT      #######"
echo "#######################################################"

##Fetching the RBAC file
printf "Creating RBAC for pod-memory-hog experiment\n"
git clone https://github.com/litmuschaos/chaos-charts.git

##Changing the required fild
sed -i 's/namespace: default/namespace: '"$APP_NS"'/' chaos-charts/charts/generic/pod-memory-hog/rbac.yaml
## Creating the Service Account for the experiment
sh -c "kubectl apply -f chaos-charts/charts/generic/pod-memory-hog/rbac.yaml -n $APP_NS"
echo "Service Account has been created"

##Creating pod-memory-hog experiment
printf "Creating pod-memory-hog experiment\n"
sh -c "kubectl create -f chaos-charts/charts/generic/pod-memory-hog/experiment.yaml -n $APP_NS"
echo "Chaos Eperiment has been created"

##Fetching the engine file
printf "Creating engine for pod-memory-hog experiment\n"
##Changing the required fild
sed -i "s/namespace: default/namespace: '"$APP_NS"'/g;"\
"s/name: nginx-chaos/name: engine6/g;"\
"s/appns: 'default'/appns: "$APP_NS"/g;"\
"s/jobCleanUpPolicy: 'delete'/jobCleanUpPolicy: retain/g;"\
"s/applabel: 'app=nginx'/applabel: '"$APP_LABEL"'/g" chaos-charts/charts/generic/pod-memory-hog/engine.yaml
##Modify ENVs of chaos engine
sed -i -e\
"/name: TOTAL_CHAOS_DURATION/{n;s/.*/              value: '"$TOTAL_CHAOS_DURATION"'/};"\
"/name: MEMORY_CONSUMPTION/{n;s/.*/              value: '"$MEMORY_CONSUMPTION"'/};"\
"/name: TARGET_CONTAINER/{n;s/.*/              value: '"$TARGET_CONTAINER"'/}" chaos-charts/charts/generic/pod-memory-hog/engine.yaml
## Creating the ChaosEngine for the experiment
sh -c "kubectl apply -f chaos-charts/charts/generic/pod-memory-hog/engine.yaml"
echo "ChaosEngine for pod-memory-hog has been created"

##Waiting for engine to come in running state
printf "Waiting for the runner pod to come in running state\n"
sleep 15
runnerPodStatus=$(kubectl get pod engine6-runner -n $APP_NS --no-headers -o custom-columns=:status.phase)
echo "$runnerPodStatus"

##Waiting for Runner pod to get completed
while [ $runnerPodStatus != "Succeeded" ]; do
  echo "Runner pod is in ${runnerPodStatus} state please wait"
  runnerPodStatus=$(kubectl get pod engine6-runner -n $APP_NS --no-headers -o custom-columns=:status.phase)
  sleep 10
done

##Getting the experiment pod namespace
jobpodName=$(kubectl get pod -l name=pod-memory-hog -n $APP_NS -o custom-columns=:metadata.name)

kubectl logs -f $jobpodName -n $APP_NS

##Getting the verdict of chaosresult
chaosResultVerdict=$(kubectl get chaosresult engine6-pod-memory-hog -n $APP_NS -o jsonpath='{.status.experimentstatus.verdict}')
echo "Verdict is: $chaosResultVerdict"
if [ $chaosResultVerdict = "Pass" ]
then
   echo "Congratulations the verdict of the experiment is: ${chaosResultVerdict}"
else
    echo "Chaos result verdict is: ${chaosResultVerdict}"
    exit 1
fi

