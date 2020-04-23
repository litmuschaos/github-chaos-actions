# Pod Delete Experiment

This experiment causes (forced/graceful) pod failure of random replicas of an application deployment. It tests deployment sanity (replica availability & uninterrupted service) and recovery workflows of the application pod. Visit <a href="https://docs.litmuschaos.io/docs/pod-delete/">pod delete docs</a> for more info.

A Sample workflow to run pod delete experiment:


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
      
    - name: Running pod delete chaos experiment
      uses: mayadata-io/choas-actions@master
      env:
        KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        ##if litmus is not installed
        INSTALL_LITMUS: true
        ##Give application info under chaos
        ##Currently supporting "deployment" applications.
        APP_NS: default
        APP_LABEL: run=nginx
        EXPERIMENT_NAME: pod-delete
        TOTAL_CHAOS_DURATION: 30
        CHAOS_INTERVAL: 10
        FORCE: false
        ##Select true if you want to uninstall litmus after chaos
        LITMUS_CLEANUP: true
```

## Environment Variabels

The application pod for pod-delete will be identified with the app info variables.

`TOTAL_CHAOS_DURATION` (Optional): The time duration for chaos insertion (in sec). Default value is `30s`

`CHAOS_INTERVAL` (Optional): Time interval b/w two successive pod failures (in sec). Default value is `10s`

`FORCE` (Optional): Application Pod failures type. Default value is `false`
