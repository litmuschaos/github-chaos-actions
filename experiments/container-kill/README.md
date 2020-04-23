# Container Kill Experiment

This experiment executes SIGKILL on container of random replicas of an application deployment. It tests the deployment sanity (replica availability & uninterrupted service) and recovery workflows of an application. Visit <a href="https://docs.litmuschaos.io/docs/container-kill/">container kill docs</a> for more info.

A Sample workflow to run container-kill experiment:


`.github/workflows/push.yml`

```yaml
name: CI

on:
  push:
    branches: [ master ]

jobs:
  build:
    
    runs-on: ubuntu-latest

    - uses: actions/checkout@master
      
    - name: Running container kill chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: container-kill
        TARGET_CONTAINER: nginx
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```
## Environment Variabels

The application pod for container-kill will be identified with the app info variables.

`TARGET_CONTAINER` (Optional): The container to be killed inside the pod. Default value is `nginx`