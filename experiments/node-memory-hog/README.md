# Node Memory Hog Experiment

This experiment causes Memory exhaustion on the Kubernetes node. The experiment aims to verify resiliency of applications whose replicas may be evicted on account on nodes turning unschedulable due to lack of Memory resources. Visit <a href="https://docs.litmuschaos.io/docs/node-memory-hog/">node memory hog docs</a> for more info.

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
    - uses: actions/checkout@master
      
    - name: Running node-memory-hog chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: node-memory-hog
        TOTAL_CHAOS_DURATION: 120
        MEMORY_PERCENTAGE: 90
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for node-memory-hog will be identified with the app info variables.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `120s`

`MEMORY_PERCENTAGE` (Optional): The size as percent of total available memory. Default value is `90` percent
