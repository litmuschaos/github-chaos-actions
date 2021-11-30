# Container Kill Experiment

This experiment executes SIGKILL on container of random replicas of an application deployment. It tests the deployment sanity (replica availability & uninterrupted service) and recovery workflows of an application. Check <a href="https://docs.litmuschaos.io/docs/container-kill/">container kill docs</a> for more info. To know more and get started with chaos-actions visit <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/README.md">github-chaos-actions</a>.

#### Sample workflow

A Sample workflow to run the container-kill experiment:

`.github/workflows/main.yml`

```yaml
name: CI

on:
  push:
    branches: [master]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Running container kill chaos experiment
        uses: litmuschaos/github-chaos-actions@v0.4.0
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
          ##If litmus is not installed
          INSTALL_LITMUS: true
          ##Give application info under chaos
          APP_NS: default
          APP_LABEL: run=nginx
          APP_KIND: deployment
          EXPERIMENT_NAME: container-kill
          ##Custom images can also be used
          EXPERIMENT_IMAGE: litmuschaos/go-runner
          EXPERIMENT_IMAGE_TAG: latest
          IMAGE_PULL_POLICY: Always
          TARGET_CONTAINER: nginx
          TOTAL_CHAOS_DURATION: 20
          CHAOS_INTERVAL: 10
          CONTAINER_RUNTIME: docker
          ##Select true if you want to uninstall litmus after chaos
          LITMUS_CLEANUP: true
```

## Environment Variabels

The application pod for container-kill will be identified with the app info variables.

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
    <td> For Running container kill experiment keep it container-kill</td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> TARGET_CONTAINER </td>
    <td> The name of container to be killed inside the pod </td>
    <td> Optional </td>
    <td> Default value is nginx</td>
  </tr>
  <tr> 
    <td> CHAOS_INTERVAL </td>
    <td>Time interval b/w two successive container kill (in seconds) </td>
    <td> Optional </td>
    <td> Default value is 10s </td>
  </tr>
  <tr> 
    <td> TOTAL_CHAOS_DURATION </td>
    <td> The time duration for chaos injection (seconds) </td>
    <td> Optional </td>
    <td> Default value is 20s </td>
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
    <td> CONTAINER_RUNTIME </td>
    <td> Give the target container runtime </td>
    <td> Optional </td>
    <td> Default value is <code>'docker'</code> </td>
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
