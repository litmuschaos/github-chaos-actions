# Pod CPU hog Hog Experiment

This experiment causes CPU resource consumption on specified application containers by starting one or more md5sum calculation process on the special file /dev/zero. It Can test the application's resilience to potential slowness/unavailability of some replicas due to high CPU load. Visit <a href="https://docs.litmuschaos.io/docs/pod-cpu-hog/">pod cpu hog docs</a> for more info.

A Sample workflow to run pod-cpu-hog experiment:


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
      
    - name: Running pod-cpu-hog chaos experiment
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
        CPU_CORES: 1
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for pod-cpu-hog will be identified with the app info variables.

`TARGET_CONTAINER` (Optional): Name of the container subjected to CPU stress. Default value is `nginx` container.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `60s`

`CPU_CORES` (Optional): Name of the container subjected to CPU stress Default value is `1` core
