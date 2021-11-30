# GitHub Action for Chaos Engineering in Kubernetes

This action provides a way to perform different chaos experiments on the Kubernetes environment. It contains Litmus Chaos experiments to run the chaos and find a weakness in the system. For more details about chaos engineering in Kubernetes using Litmus visit <a href="https://docs.litmuschaos.io/docs/next/getstarted.html"> litmus-docs </a>.

## Pre-requisites

Kubernetes 1.16 or later.

## Overview.

There is a number of chaos experiments that can be performed using `github-chaos-actions`, you can select the one which you want to perform, and for more details about the experiment please visit the <a href="https://docs.litmuschaos.io/docs/getstarted"> experiment docs </a>section.

## Run a chaos experiment using this action

We just need to follow these simple steps to run a chaos experiment using this action:

- **Deploy Application**: We need to have an application running on which the chaos will be performed. The user has to create an application and pass the application details through action's ENV. The details involved application kind (deployment,statefulset,daemonset), application label, and namespace.

- **Install Litmus**: Before running any experiment we need to setup litmus in the cluster. If litmus is not already installed then we can install it from `github-chaos-action` by just passing an ENV `INSTALL-LITMUS` with `true` value. This will bring up litmus with all infra components running in litmus namespace.

- **Select experiment**: Select an experiment from the list of experiments mentioned in the below section which you want to perform on an application. Get the details of the experiment and how to run the actions for a particular experiment.

**The different experiments that can be performed using `github-chaos-actions` are:**

- **Pod Delete**: This chaos action causes random (forced/graceful) pod delete of application deployment replicas. It tests deployment sanity (high availability & uninterrupted service) and recovery workflows of the application pod. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-delete/README.md"> pod delete chaos action</a> and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-delete"> pod delete docs</a>.

- **Container Kill**: This chaos action executes SIGKILL on the container of random replicas of application deployment. It tests the deployment sanity (high availability & uninterrupted service) and recovery workflows of an application. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/container-kill/README.md"> container kill chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/container-kill"> container kill docs</a>.

- **Node CPU Hog**: This chaos action causes CPU resource exhaustion on the Kubernetes node. The experiment aims to verify the resiliency of applications that operate under resource constraints wherein replicas may sometimes be evicted on account on nodes turning unschedulable (Not Ready) due to lack of CPU resources. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/node-cpu-hog/README.md">node cpu hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/node-cpu-hog"> node cpu hog docs</a> .

- **Node Memory Hog**: This chaos action causes Memory exhaustion on the Kubernetes node. The experiment aims to verify the resiliency of applications that operate under resource constraints wherein replicas may sometimes be evicted on account on nodes turning unschedulable due to lack of Memory resources. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/node-memory-hog/README.md"> node memory hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/node-memory-hog"> node memory hog docs</a>.

- **Pod CPU Hog**: This chaos action causes CPU resource consumption on specified application containers by starting one or more md5sum calculation process on the special file /dev/zero. It Can test the application's resilience to potential slowness/unavailability of some replicas due to high CPU load. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-cpu-hog/README.md"> pod cpu hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-cpu-hog"> pod cpu hog docs</a>.

- **Pod Memory Hog**: This chaos action causes Memory resource consumption on specified application containers by using dd command which will be used to consume memory of the application container for a certain duration of time. It can test the application's resilience to potential slowness/unavailability of some replicas due to high Memory load. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-memory-hog/README.md">pod memory hog chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-memory-hog"> Pod Memory hog docs</a>.

- **Disk Fill**: This chaos action causes Disk Stress by filling up the Ephemeral Storage of the Pod using one of it containers. It forced the Pod to get Evicted if the Pod exceeds it Ephemeral Storage Limit.It tests the Ephemeral Storage Limits, to ensure those parameters are sufficient.Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/disk-fill/README.md"> disk fill chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/disk-fill"> Disk Fill hog docs</a>.

- **Pod Network Corruption**: This chaos action Injects packet corruption on the specified container by starting a traffic control (tc) process with netem rules to add egress packet corruption. Corruption is injected via pumba library with command Pumba netem corruption bypassing the relevant network interface, packet-corruption-percentage, chaos duration, and regex filter for the container name. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-network-corruption/README.md">pod network corruption chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-corruption"> pod network corruption docs</a>.

- **Pod Network Latency**: This chaos action causes flaky access to application replica by injecting network delay using Pumba. It injects latency on the specified container by starting a traffic control (tc) process with netem rules to add egress delays. It Can test the application's resilience to lossy/flaky network. Check a sample usage of<a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-network-latency/README.md"> pod network latency chaos action</a> and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-latency"> pod network latency docs</a>.

- **Pod Network Loss**: This chaos action injects chaos to disrupt network connectivity to Kubernetes pods. The application pod should be healthy once chaos is stopped. It causes loss of access to application replica by injecting packet loss. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-network-loss/README.md">pod network loss chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-loss"> pod network loss docs</a>

- **Pod Network Duplication**: This chaos action injects pod-network-duplication injects chaos to disrupt network connectivity to kubernetes podsThe application pod should be healthy once chaos is stopped. Service-requests should be served despite chaos. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-network-duplication/README.md">pod network duplication chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-network-duplication"> pod network duplication docs</a>

- **Pod Autoscaler**: This chaos action can be used for other scenarios as well, such as for checking the Node auto-scaling feature. For example, check if the pods are successfully rescheduled within a specified period in cases where the existing nodes are already running at the specified limits. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-autoscaler/README.md">pod autoscaler chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/pod-autoscaler"> pod autoscaler docs</a>

- **Node IO Stress**: This chaos action injects IO stress on the Kubernetes node. The experiment aims to verify the resiliency of applications that share this disk resource for ephemeral or persistent storage purposes. The amount of disk stress can be either specifed as the size in percentage of the total free space on the file system or simply in Gigabytes(GB). When provided both it will execute with the utilization percentage specified and non of them are provided it will execute with default value of 10%. Check a sample usage of <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/node-io-stress/README.md">node io stress chaos action </a>and for more details about the experiment please visit <a href="https://docs.litmuschaos.io/docs/node-io-stress"> node io stress docs</a>

## Usage

A sample pod delete experiment workflow:

`.github/workflows/main.yml`

```yaml
name: chaos-pipeline
#events can be modified as per requirements
on:
  workflow_dispatch:

jobs:
  chaos-action:
    runs-on: ubuntu-latest
    steps:
      # KUBE_CONFIG_DATA is required env for litmuschaos/github-chaos-actions.
      - name: Setting up kubeconfig ENV for Github Chaos Action
        run: echo ::set-env name=KUBE_CONFIG_DATA::$(base64 -w 0 ~/.kube/config)
        env:
          ACTIONS_ALLOW_UNSECURE_COMMANDS: true

      - name: Setup Litmus
        uses: litmuschaos/github-chaos-actions@master
        env:
          INSTALL_LITMUS: true

      - name: Running Litmus pod delete chaos experiment
        uses: litmuschaos/github-chaos-actions@master
        env:
          EXPERIMENT_NAME: pod-delete
          EXPERIMENT_IMAGE: litmuschaos/go-runner
          EXPERIMENT_IMAGE_TAG: latest
          JOB_CLEANUP_POLICY: delete

      - name: Uninstall Litmus
        if: always()
        uses: litmuschaos/github-chaos-actions@master
        env:
          LITMUS_CLEANUP: true
```

#### For EKS Clusters

A sample pod delete experiment workflow for EKS Clusters:

`.github/workflows/main.yml`

```yaml
name: chaos-pipeline
#events can be modified as per requirements
on:
  workflow_dispatch:

jobs:
  chaos-action:
    runs-on: ubuntu-latest
    # AWS secrets are required to configure & run chaos
    env:
      AWS_SECRET_ACCESS_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}

    steps:
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      # Optionally kubeconfig can be passed from github secrets in base64 encoded form as mentioned above.
      - name: Writing kubeconfig for eks cluster
        run: |
          aws eks --region ${{ secrets.AWS_REGION }} update-kubeconfig --name <eks_cluster_name>

      - name: Setting up kubeconfig ENV for Github Chaos Action
        run: echo ::set-env name=KUBE_CONFIG_DATA::$(base64 -w 0 ~/.kube/config)
        env:
          ACTIONS_ALLOW_UNSECURE_COMMANDS: true

      - name: Setup Litmus
        uses: litmuschaos/github-chaos-actions@master
        env:
          INSTALL_LITMUS: true

      - name: Running Litmus pod delete chaos experiment
        uses: litmuschaos/github-chaos-actions@master
        env:
          EXPERIMENT_NAME: pod-delete
          EXPERIMENT_IMAGE: litmuschaos/go-runner
          EXPERIMENT_IMAGE_TAG: latest
          JOB_CLEANUP_POLICY: delete

      - name: Uninstall Litmus
        if: always()
        uses: litmuschaos/github-chaos-actions@master
        env:
          LITMUS_CLEANUP: true
```

Get the details of the chaos action tunables for pod delete (above example) <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/experiments/pod-delete/README.md">here</a>

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
    <td> We can provide custom image for running chaos experiment </td>
    <td> Optional </td>
    <td> Default value is litmuschaos/go-runner </td>
  </tr>
  <tr>
    <td> EXPERIMENT_IMAGE_TAG </td>
    <td> We can set the image tag while using custom image for the chaos experiment </td>
    <td> Optional </td>
    <td> Default value is latest </td>
  </tr>  
  <tr>
    <td>IMAGE_PULL_POLICY </td>
    <td> We can set the image pull policy while using custom image for running chaos experiment </td>
    <td> Optional </td>
    <td> Default value is Always </td>
  </tr>  
</table>

#### For EKS Cluster

Setup AWS Credentials using [GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets). The secrets should now be populated to action using ENVs.

```yaml
jobs:
  chaos-action:
    runs-on: ubuntu-latest
    # AWS secrets are required to configure & run chaos
    env:
      AWS_SECRET_ACCESS_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_REGION: ${{ secrets.AWS_REGION }}
```

> Note: Either these secrets can be setup at Job level or have to be provided in all chaos-action steps.
