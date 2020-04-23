# Pod Memory Hog Experiment

This experiment causes Memory resource consumption on specified application containers by using dd command which will used to consume memory of the application container for certain duration of time. It can test the application's resilience to potential slowness/unavailability of some replicas due to high Memory load. Visit <a href="https://docs.litmuschaos.io/docs/pod-memory-hog/">node memory hog docs</a> for more info.

A Sample workflow to run pod-memory-hog experiment:


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
      
    - name: Running pod-memory-hog chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: pod-cpu-hog
        TARGET_CONTAINER: nginx
        TOTAL_CHAOS_DURATION: 60
        MEMORY_CONSUMPTION: 500
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for pod-cpu-hog will be identified with the app info variables.

`TARGET_CONTAINER` (Optional): Name of the container subjected to CPU stress. Default value is `nginx` container.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `60`s

`MEMORY_CONSUMPTION` (Optional):The amount of memory used of hogging a Kubernetes pod (megabytes). Default value is `500`M
