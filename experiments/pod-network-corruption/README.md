# Pod Network Corruption Experiment

Inject network packet corruption into application pod. Visit <a href="https://docs.litmuschaos.io/docs/pod-network-corruption/">pod network corruption docs</a> for more info.

A Sample workflow to run pod network corruption experiment:


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
      
    - name: Running pod network corruption chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: pod-network-corruption
        TARGET_CONTAINER: nginx
        TOTAL_CHAOS_DURATION: 60
        NETWORK_INTERFACE: eth0
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true        
```

## Environment Variabels

The application pod for pod-network-corruption will be identified with the app info variables.

`TARGET_CONTAINER` (Optional): Name of container which is subjected to network latency. Default value is `nginx` container.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (seconds). Default value is `60s`

`NETWORK_INTERFACE` (Optional): Name of ethernet interface considered for shaping traffic. Default value is `eth0`
