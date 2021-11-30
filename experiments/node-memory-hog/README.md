# Node Memory Hog Experiment

This experiment causes Memory exhaustion on the Kubernetes node. The experiment aims to verify the resiliency of applications whose replicas may be evicted on account on nodes turning unschedulable due to lack of Memory resources. Check <a href="https://docs.litmuschaos.io/docs/node-memory-hog/">node memory hog docs</a> for more info. To know more and get started with chaos-actions visit <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/README.md">github-chaos-actions</a>.

#### Sample workflow

A Sample workflow to run node-memory-hog experiment:

`.github/workflows/push.yml`

```yaml
name: CI

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Running node-memory-hog chaos experiment
      uses: litmuschaos/github-chaos-actions@v0.4.0
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        APP_NS: default
        APP_LABEL: run=nginx
        APP_KIND: deployment
        EXPERIMENT_NAME: node-memory-hog
        ##Custom images can also be used
        EXPERIMENT_IMAGE: litmuschaos/go-runner
        EXPERIMENT_IMAGE_TAG: latest
        IMAGE_PULL_POLICY: Always
        TOTAL_CHAOS_DURATION: 120
        MEMORY_PERCENTAGE: 90
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true
```

## Environment Variabels

The application pod for node-memory-hog will be identified with the app info variables.

**Supported Chaos Action Tunables**

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> EXPERIMENT_NAME </td>
    <td> For Running node memory hog experiment keep it node-memory-hog</td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> MEMORY_PERCENTAGE </td>
    <td> The size as percent of total available memory </td>
    <td> Optional </td>
    <td> Default value is 90</td>
  </tr>
  <tr> 
    <td> TOTAL_CHAOS_DURATION </td>
    <td> The time duration for chaos injection (seconds) </td>
    <td> Optional </td>
    <td> Default value is 120s </td>
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
