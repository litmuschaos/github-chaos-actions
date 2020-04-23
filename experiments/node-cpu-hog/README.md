# Node CPU Hog Experiment

This experiment causes CPU resource exhaustion on the Kubernetes node. The experiment aims to verify resiliency of applications whose replicas may be evicted on account on nodes turning unschedulable (Not Ready) due to lack of CPU resources. Visit <a href="https://docs.litmuschaos.io/docs/node-cpu-hog/">node cpu hog docs</a> for more info.

A Sample workflow to run node-cpu-hog experiment:


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
      
    - name: Running node-cpu-hog chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: node-cpu-hog
        TOTAL_CHAOS_DURATION: 30
        NODE_CPU_CORE: 2
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for node-cpu-hog will be identified with the app info variables.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `60s`

`NODE_CPU_CORE` (Optional): Number of cores of CPU that has to be consumed by node. Default value is `2` core
