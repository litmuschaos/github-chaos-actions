# Github Action for Chaos Engineering in Kubernetes

This action provides a way to perform different chaos engineering experiments in the Kubernetes environment. It contains Litmus Chaos experiments to run the chaos and find the weakness in the system. For more details about chaos engineering in Kubernetes using Litmus visit <a href="https://docs.litmuschaos.io/docs/next/getstarted.html"> litmus-docs </a>.

## Pre-requisites

Kubernetes 1.11 or later.

## Overview.

There are number of chaos experiments that can be performed using this github action you can find the experiments under experiment folder. These experiments are:

- **Pod Delete**:  This experiment causes (forced/graceful) pod failure of random replicas of an application deployment. It tests deployment sanity (replica availability & uninterrupted service) and recovery workflows of the application pod. Visit <a href="https://docs.litmuschaos.io/docs/pod-delete"> pod delete docs</a> for more info.

- **Container Kill**: This experiment executes SIGKILL on container of random replicas of an application deployment. It tests the deployment sanity (replica availability & uninterrupted service) and recovery workflows of an application. Visit <a href="https://docs.litmuschaos.io/docs/container-kill"> container kill docs</a> for more info.

- **Node CPU Hog**: This experiment causes CPU resource exhaustion on the Kubernetes node. The experiment aims to verify resiliency of applications whose replicas may be evicted on account on nodes turning unschedulable (Not Ready) due to lack of CPU resources. Visit <a href="https://docs.litmuschaos.io/docs/node-cpu-hog"> node cpu hog docs</a> for more info.

- **Node Memory Hog**: This experiment causes Memory exhaustion on the Kubernetes node. The experiment aims to verify resiliency of applications whose replicas may be evicted on account on nodes turning unschedulable due to lack of Memory resources. Visit <a href="https://docs.litmuschaos.io/docs/node-memory-hog"> node memory hog docs</a> for more info.

- **Pod CPU Hog**: This experiment causes CPU resource consumption on specified application containers by starting one or more md5sum calculation process on the special file /dev/zero. It Can test the application's resilience to potential slowness/unavailability of some replicas due to high CPU load. Visit <a href="https://docs.litmuschaos.io/docs/pod-cpu-hog"> pod cpu hog docs</a> for more info.

- **Pod Memory Hog**: This experiment causes Memory resource consumption on specified application containers by using dd command which will used to consume memory of the application container for certain duration of time. It can test the application's resilience to potential slowness/unavailability of some replicas due to high Memory load. Visit <a href="https://docs.litmuschaos.io/docs/pod-memory-hog"> Pod Memory hog docs</a> for more info.

- **Pod Network Corruption**: Inject network packet corruption into application pod. Visit <a href="https://docs.litmuschaos.io/docs/pod-network-corruption"> pod network corruption docs</a> for more info.

- **Pod Network Latency**: This experiment causes flaky access to application replica by injecting network delay using pumba. It injects latency on the specified container by starting a traffic control (tc) process with netem rules to add egress delays. It Can test the application's resilience to lossy/flaky network. Visit pod <a href="https://docs.litmuschaos.io/docs/pod-network-latency"> network latency docs</a> 

- **Pod Network Loss**: This experiment injects chaos to disrupt network connectivity to kubernetes pods.The application pod should be healthy once chaos is stopped. It causes loss of access to application replica by injecting packet loss using pumba. Visit <a href="https://docs.litmuschaos.io/docs/pod-network-loss"> pod network loss docs</a>

## Run a chaos experiment using this action

We just need  to follow these simple steps to run a chaos experiment using this action:

- **Install Litmus**: Before running any experiment we need to setup litmus in the cluster. If litmus is not already installed then we can install it from action by just passing an evn `INSTALL-LITMUS` with `true` value or else we can keep it `false`. You can find more details under `setup` folder.

- **Deploy Application**: After having litmus installed in the cluster we need to have an application runnning on which the chaos will be performed. We can create the application also by passing `APP_DEPLOY` as `true` in env along with other variables using this action. You can find more details under `setup` folder.

- **Select experiment**: Select an experiment from experiment folder which you want to use. Get the details of how to run the experiment there only. A sample pod delte experiment workflow is shown here.



## Usage

`.github/workflows/main.yml`

```yaml
name: CI

on:
  push:
    branches: [ master ]

jobs:
  build:
    
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@master
      
    - name: Running pod delete chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: pod-delete
        TOTAL_CHAOS_DURATION: 30
        CHAOS_INTERVAL: 10
        FORCE: false
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true
```

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

## Environment Variables

Add the environment variables as mentioned in the experiment readme under experiment folder. Some of the comman environment variables are mentioned here.

`INSTALL_LITMUS` - (Optional): Keep it `true` if true to install litmus.

`APP_DEPLOY` - (Optional): Keep it `true` to deploy a sample application. 

`EXPERIMENT_NAME` - (Optional): Pass the name of chaos experiment. 
