# Pod Network Latency Experiment

This experiment causes flaky access to application replica by injecting network delay using pumba. It injects latency on the specified container by starting a traffic control (tc) process with netem rules to add egress delays. It Can test the application's resilience to lossy/flaky network. Visit <a href="https://docs.litmuschaos.io/docs/pod-network-latency/">pod network latency</a> for more info. To know more and get started with `chaos-actions` visit <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/README.md">github-chaos-actions</a>. 

A Sample workflow to run pod-network-latency experiment:


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
    - uses: actions/checkout@master
      
    - name: Running pod-network-latency chaos experiment
      uses: mayadata-io/github-chaos-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        #If litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        APP_NS: default
        APP_LABEL: run=nginx
        APP_KIND: deployment
        EXPERIMENT_NAME: pod-network-latency
        ##Custom images can also be used
        EXPERIMENT_IMAGE: litmuschaos/ansible-runner:latest        
        TARGET_CONTAINER: nginx
        TOTAL_CHAOS_DURATION: 60
        NETWORK_INTERFACE: eth0
      	NETWORK_LATENCY: 60000
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for pod-network-latency will be identified with the app info variables.

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
    <td> For Running pod network latency experiment keep it pod-network-latency </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> NETWORK_INTERFACE </td>
    <td> Name of ethernet interface considered for shaping traffic </td>
    <td> Optional </td>
    <td> Default value is eth0 </td>
  </tr>
    <tr> 
    <td> NETWORK_LATENCY </td>
    <td> The latency/delay in milliseconds </td>
    <td> Optional </td>
    <td> Default (60000ms) </td>
  </tr>
  <tr> 
    <td> TARGET_CONTAINER </td>
    <td> Name of container which is subjected to network latency. </td>
    <td> Optional </td>
    <td> Default value is nginx </td>
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
    <td> We can provide cumstom image for running litmus chaos experiment </td>
    <td> Optional </td>
    <td> Default value is litmuschaos/ansible-runner:latest </td>
  </tr>
</table>
