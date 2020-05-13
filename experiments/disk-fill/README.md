# Disk Fill Experiment

This chaos action causes Disk Stress by filling up the Ephemeral Storage of the Pod using one of it containers. It forced the Pod to get Evicted if the Pod exceeds it Ephemeral Storage Limit.It tests the Ephemeral Storage Limits, to ensure those parameters are sufficient. Check <a href="https://docs.litmuschaos.io/docs/disk-fill/">disk fill docs</a> for more info. To know more and get started with chaos-actions visit <a href="https://github.com/mayadata-io/github-chaos-actions/blob/master/README.md">github-chaos-actions</a>. 

**NOTE**: Appropriate Ephemeral Storage Requests and Limits should be set for the application before running the chaos action. 

#### Sample workflow 

A Sample workflow to run disk-fill experiment:


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
      
    - name: Running disk-fill chaos experiment
      uses: mayadata-io/github-chaos-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##If litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        APP_NS: default
        APP_LABEL: run=nginx
        APP_KIND: deployment
        EXPERIMENT_NAME: disk-fill
        FILL_PERCENTAGE: 80
        TARGET_CONTAINER: nginx
        ##Custom images can also be used
        EXPERIMENT_IMAGE: litmuschaos/ansible-runner:latest        
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for disk-fill will be identified with the app info variables.

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
    <td> For Running disk fill experiment keep it disk-fill</td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> TARGET_CONTAINER </td>
    <td> Name of container which is subjected to disk-fill</td>
    <td> Optional </td>
    <td> Default value is nginx </td>
  </tr>  
  <tr> 
    <td> FILL_PERCENTAGE </td>
    <td> Percentage to fill the Ephemeral storage limit </td>
    <td> Optional </td>
    <td> Default value is 2</td>
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