# Github Action for Chaos Engineering in Kubernetes

This action provides a way to perform different chaos experiments on the Kubernetes environment. It contains Litmus Chaos experiments to run the chaos and find a weakness in the system. For more details about chaos engineering in Kubernetes using Litmus visit <a href="https://docs.litmuschaos.io/docs/next/getstarted.html"> litmus-docs </a>.

## Pre-requisites

Kubernetes 1.11 or later.

## Overview.

There is a number of chaos experiments that can be performed using `github-chaos-actions`, you can select the one which you want to perform, and for more details about the experiment please visit the <a href="https://docs.litmuschaos.io/docs/getstarted"> experiment docs </a>section.

## Run a chaos experiment using this action

We just need  to follow these simple steps to run a chaos experiment using this action:

- **Install Litmus**: Before running any experiment we need to setup litmus in the cluster. If litmus is not already installed then we can install it from `github-chaos-action` by just passing an ENV `INSTALL-LITMUS` with `true` value. This will bring up litmus with all infra components running in litmus namespace.

- **Deploy Application**: After having litmus installed in the cluster we need to have an application running on which the chaos will be performed. The user has to create an application and pass the application details through action's ENV. The details involved application kind (deployment,statefulset,daemonset), application label, and namespace.

- **Select experiment**: Select an experiment from the list of experiments mentioned in the below section which you want to perform on an application. Get the details of the experiment and how to run the actions for a particular experiment.

**The different experiments that can be performed using `github-chaos-actions` are:**

- **Pod Delete**:  This chaos action causes random (forced/graceful) pod delete of application deployment replicas. It tests deployment sanity (high availability & uninterrupted service) and recovery workflows of the application pod. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-delete/README.md"> pod delete chaos action</a> and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-delete"> pod delete docs</a>.

- **Container Kill**: This chaos action executes SIGKILL on the container of random replicas of application deployment. It tests the deployment sanity (high availability & uninterrupted service) and recovery workflows of an application. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/container-kill/README.md"> container kill chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/container-kill"> container kill docs</a>.

- **Node CPU Hog**: This chaos action causes CPU resource exhaustion on the Kubernetes node. The experiment aims to verify the resiliency of applications that operate under resource constraints wherein replicas may sometimes be evicted on account on nodes turning unschedulable (Not Ready) due to lack of CPU resources. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/node-cpu-hog/README.md">node cpu hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/node-cpu-hog"> node cpu hog docs</a> .

- **Node Memory Hog**: This chaos action causes Memory exhaustion on the Kubernetes node. The experiment aims to verify the resiliency of applications that operate under resource constraints wherein replicas may sometimes be evicted on account on nodes turning unschedulable due to lack of Memory resources. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/node-memory-hog/README.md"> node memory hog chaos action  </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/node-memory-hog"> node memory hog docs</a>.

- **Pod CPU Hog**: This chaos action causes CPU resource consumption on specified application containers by starting one or more md5sum calculation process on the special file /dev/zero. It Can test the application's resilience to potential slowness/unavailability of some replicas due to high CPU load. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-cpu-hog/README.md"> pod cpu hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-cpu-hog"> pod cpu hog docs</a>.

- **Pod Memory Hog**: This chaos action causes Memory resource consumption on specified application containers by using dd command which will be used to consume memory of the application container for a certain duration of time. It can test the application's resilience to potential slowness/unavailability of some replicas due to high Memory load. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-memory-hog/README.md">pod memory hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-memory-hog"> Pod Memory hog docs</a>.

- **Disk Fill**: This chaos action causes Disk Stress by filling up the Ephemeral Storage of the Pod using one of it containers. It forced the Pod to get Evicted if the Pod exceeds it Ephemeral Storage Limit.It tests the Ephemeral Storage Limits, to ensure those parameters are sufficient.Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/disk-fill/README.md"> disk fill chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/disk-fill"> Disk Fill hog docs</a>.

- **Pod Network Corruption**: This chaos action Injects packet corruption on the specified container by starting a traffic control (tc) process with netem rules to add egress packet corruption. Corruption is injected via pumba library with command Pumba netem corruption bypassing the relevant network interface, packet-corruption-percentage, chaos duration, and regex filter for the container name. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-network-corruption/README.md">pod network corruption chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-corruption"> pod network corruption docs</a>.

- **Pod Network Latency**: This chaos action causes flaky access to application replica by injecting network delay using Pumba. It injects latency on the specified container by starting a traffic control (tc) process with netem rules to add egress delays. It Can test the application's resilience to lossy/flaky network. Check a sample usage of<a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-network-latency/README.md"> pod network latency chaos action</a> and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-latency"> pod network latency docs</a>.

- **Pod Network Loss**: This chaos action injects chaos to disrupt network connectivity to Kubernetes pods. The application pod should be healthy once chaos is stopped. It causes loss of access to application replica by injecting packet loss using Pumba. Check a sample usage of <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-network-loss/README.md">pod network loss chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-loss"> pod network loss docs</a>

## Usage

A sample pod delete experiment workflow:

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
      
    - name: Running Litmus pod delete chaos experiment
      uses: mayadata-io/github-chaos-actions@master
      env:
        ##Pass kubeconfig data from secret in base 64 encoded form 
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##If litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        APP_NS: default
        APP_LABEL: run=nginx
        APP_KIND: deployment
        EXPERIMENT_NAME: pod-delete
        ##Custom image can also been used
        EXPERIMENT_IMAGE: litmuschaos/ansible-runner:latest        
        TOTAL_CHAOS_DURATION: 30
        CHAOS_INTERVAL: 10
        FORCE: false
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true
```
Get the details of the chaos action tunables for pod delete (above example) <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/experiments/pod-delete/README.md">here</a>

## Secrets

`KUBE_CONFIG_DATA` – **required**: A base64-encoded kubeconfig file with credentials for Kubernetes to access the cluster. You can get it by running the following command:

```bash
cat $HOME/.kube/config | base64
```

## Environment Variables

Some comman environment variables used for running the `github-chaos-actions` are:


<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> EXPERIMENT_NAME </td>
    <td> Give the experiment name you want to run(check the list of experiments available under experiment folder)</td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> APP_NS </td>
    <td> Provide namespace of application under chaos </td>
    <td> Optional </td>
    <td> Default value is default</td>
  </tr>
  <tr>
    <td> APP_LABEL  </td>
    <td> Provide application label of application under chaos. </td>
    <td> Optional </td>
    <td> Default value is run=nginx </td>
  </tr>
  <tr>
    <td> APP_KIND </td>
    <td> Provide the kind of application   </td>
    <td> Optional  </td>
    <td> Default value is deployment </td>
  </tr>
  <tr>
    <td> INSTALL_LITMUS </td>
    <td> Keep it true to install litmus if litmus is not already installed.</td>
    <td> Optional </td>
    <td> Default value is not set to true </td>
  </tr>
  <tr>
    <td> LITMUS_CLEANUP </td>
    <td> Keep it true to uninstall litmus after chaos </td>
    <td> Optional </td>
    <td> Default value is not set to true </td>
  </tr>
  <tr>
    <td> EXPERIMENT_IMAGE </td>
    <td>We can provide cumstom image for running litmus chaos experiment </td>
    <td> Optional </td>
    <td> Default value is litmuschaos/ansible-runner:latest </td>
  </tr>
</table>