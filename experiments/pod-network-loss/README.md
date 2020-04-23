# Pod Network Loss Experiment

This experiment injects chaos to disrupt network connectivity to kubernetes pods.The application pod should be healthy once chaos is stopped. It causes loss of access to application replica by injecting packet loss using pumba. Visit <a href="https://docs.litmuschaos.io/docs/pod-network-loss/">pod network loss</a> for more info.

A Sample workflow to run pod-network-loss experiment:


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
      
    - name: Running pod-network-loss chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: pod-network-loss
        TARGET_CONTAINER: nginx
        TOTAL_CHAOS_DURATION: 60
        NETWORK_INTERFACE: eth0
        NETWORK_PACKET_LOSS_PERCENTAGE: 100
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for pod-network-loss will be identified with the app info variables.

`TARGET_CONTAINER` (Optional): Name of the container subjected to CPU stress. Default value is `nginx` container.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `60s`

`NETWORK_INTERFACE` (Optional): Name of ethernet interface considered for shaping traffic. Default value is `eth0`

`NETWORK_PACKET_LOSS_PERCENTAGE` (Optional): The packet loss in percentage. Default value is `100`
