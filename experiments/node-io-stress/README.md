# Node IO Stress Experiment

This experiment causes IO stress on the Kubernetes node. The experiment aims to verify the resiliency of applications that share this disk resource for ephemeral or persistent storage purposes.
Check <a href="https://docs.litmuschaos.io/docs/node-io-stress/">node io stress docs</a> for more info. To know more and get started with chaos-actions visit <a href="https://github.com/litmuschaos/github-chaos-actions/blob/master/README.md">github-chaos-actions</a>.

#### Sample workflow

A Sample workflow to run node-io-stress experiment:

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
      - name: Running node-io-stress chaos experiment
        uses: litmuschaos/github-chaos-actions@v0.4.0
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
          
          # Litmus SDK Authentication
          LITMUS_ENDPOINT: "https://chaos-center.example.com"
          LITMUS_USERNAME: "admin"
          LITMUS_PASSWORD: ${{ secrets.LITMUS_PASSWORD }}
          LITMUS_PROJECT_ID: "your-project-id"
          
          # Infrastructure Setup
          INSTALL_INFRA: "true"
          INFRA_NAME: "node-io-stress-infra"
          INFRA_NAMESPACE: "litmus"
          INFRA_SCOPE: "cluster"
          
          # Application Info
          APP_NS: default
          APP_LABEL: run=nginx
          APP_KIND: deployment
          
          # Experiment Configuration
          EXPERIMENT_NAME: node-io-stress
          EXPERIMENT_IMAGE: litmuschaos/go-runner
          EXPERIMENT_IMAGE_TAG: 3.18.0
           
          
          # Node IO Stress Specific Configuration
          TOTAL_CHAOS_DURATION: 120
          FILESYSTEM_UTILIZATION_PERCENTAGE: 10
          CONTAINER_RUNTIME: containerd
          SOCKET_PATH: /run/containerd/containerd.sock
          
          # Optional Probe Setup
          LITMUS_CREATE_PROBE: "true"
          LITMUS_PROBE_NAME: "http-status-check"
          LITMUS_PROBE_TYPE: "httpProbe"
          LITMUS_PROBE_MODE: "SOT"
          LITMUS_PROBE_URL: "http://nginx-svc:80/"
          LITMUS_PROBE_RESPONSE_CODE: "200"
          
          # Cleanup
          LITMUS_CLEANUP: true
```

## Environment Variables

The following environment variables are used to configure the node-io-stress experiment.

### SDK Authentication Variables (Required)

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> LITMUS_ENDPOINT </td>
    <td> URL of the Litmus Chaos Center </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> LITMUS_USERNAME </td>
    <td> Username for Litmus authentication </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> LITMUS_PASSWORD </td>
    <td> Password for Litmus authentication </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> LITMUS_PROJECT_ID </td>
    <td> Project ID in Litmus </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
</table>

### Common Environment Variables

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> KUBECONFIG </td>
    <td> Path to kubeconfig file </td>
    <td> Optional </td>
    <td> /home/runner/.kube/config </td>
  </tr>
  <tr> 
    <td> APP_NS </td>
    <td> Application namespace for chaos testing </td>
    <td> Optional </td>
    <td> litmus </td>
  </tr>
  <tr> 
    <td> ACTIVATE_INFRA </td>
    <td> Whether to activate infrastructure </td>
    <td> Optional </td>
    <td> true </td>
  </tr>
  <tr> 
    <td> CREATE_ENV </td>
    <td> Whether to create environment </td>
    <td> Optional </td>
    <td> true </td>
  </tr>
  <tr> 
    <td> ENV_NAME </td>
    <td> Name of the environment </td>
    <td> Optional </td>
    <td> ci-test-env </td>
  </tr>
  <tr> 
    <td> ENV_TYPE </td>
    <td> Type of environment </td>
    <td> Optional </td>
    <td> NON_PROD </td>
  </tr>
  <tr> 
    <td> INFRA_ACTIVATION_TIMEOUT </td>
    <td> Timeout for infrastructure activation </td>
    <td> Optional </td>
    <td> 5 </td>
  </tr>
  <tr> 
    <td> LITMUS_USE_EXISTING_PROBE </td>
    <td> Whether to use existing probe </td>
    <td> Optional </td>
    <td> false </td>
  </tr>
  <tr> 
    <td> APP_LABEL </td>
    <td> Application label for targeting </td>
    <td> Optional </td>
    <td> app=nginx-node-io-stress </td>
  </tr>
</table>

### Infrastructure Setup Variables

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> INSTALL_INFRA </td>
    <td> Whether to install infrastructure </td>
    <td> Optional </td>
    <td> true </td>
  </tr>
  <tr> 
    <td> USE_EXISTING_INFRA </td>
    <td> Whether to use existing infrastructure </td>
    <td> Optional </td>
    <td> false </td>
  </tr>
  <tr> 
    <td> EXISTING_INFRA_ID </td>
    <td> ID of existing infrastructure </td>
    <td> Required if USE_EXISTING_INFRA=true </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> INFRA_NAME </td>
    <td> Name for the infrastructure </td>
    <td> Optional </td>
    <td> ci-infra-node-io-stress </td>
  </tr>
  <tr> 
    <td> INFRA_NAMESPACE </td>
    <td> Kubernetes namespace for infrastructure </td>
    <td> Optional </td>
    <td> litmus </td>
  </tr>
  <tr> 
    <td> INFRA_SCOPE </td>
    <td> Scope of infrastructure </td>
    <td> Optional </td>
    <td> cluster </td>
  </tr>
  <tr> 
    <td> INFRA_SERVICE_ACCOUNT </td>
    <td> Service account for infrastructure </td>
    <td> Optional </td>
    <td> litmus </td>
  </tr>
</table>

### Probe Configuration Variables

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> LITMUS_CREATE_PROBE </td>
    <td> Whether to create a probe </td>
    <td> Optional </td>
    <td> false </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_NAME </td>
    <td> Name of the probe </td>
    <td> Optional </td>
    <td> http-probe </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_TYPE </td>
    <td> Type of probe </td>
    <td> Optional </td>
    <td> httpProbe </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_MODE </td>
    <td> Mode of the probe (SOT, EOT, Continuous) </td>
    <td> Optional </td>
    <td> SOT </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_URL </td>
    <td> URL for HTTP probe </td>
    <td> Required for HTTP probe </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_TIMEOUT </td>
    <td> Timeout for probe </td>
    <td> Optional </td>
    <td> 30s </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_INTERVAL </td>
    <td> Interval for probe </td>
    <td> Optional </td>
    <td> 10s </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_ATTEMPTS </td>
    <td> Number of attempts for probe </td>
    <td> Optional </td>
    <td> 1 </td>
  </tr>
  <tr> 
    <td> LITMUS_PROBE_RESPONSE_CODE </td>
    <td> Expected HTTP response code </td>
    <td> Optional </td>
    <td> 200 </td>
  </tr>
</table>

### Application Info Variables

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> APP_NS </td>
    <td> Provide namespace of application under chaos </td>
    <td> Optional </td>
    <td> default </td>
  </tr>
  <tr>
    <td> APP_LABEL </td>
    <td> Provide application label of application under chaos </td>
    <td> Optional </td>
    <td> run=nginx </td>
  </tr>
  <tr>
    <td> APP_KIND </td>
    <td> Provide the kind of application </td>
    <td> Optional </td>
    <td> deployment </td>
  </tr>
</table>

### Node IO Stress Experiment Variables

<table>
  <tr>
    <th> Variables </th>
    <th> Description </th>
    <th> Specify In Chaos Action </th>
    <th> Default Value </th>
  </tr>
  <tr> 
    <td> EXPERIMENT_NAME </td>
    <td> For Running node io stress experiment keep it node-io-stress </td>
    <td> Mandatory </td>
    <td> No default value </td>
  </tr>
  <tr> 
    <td> FILESYSTEM_UTILIZATION_PERCENTAGE </td>
    <td> The size as percent of total available filesystem space (in percentage) </td>
    <td> Optional </td>
    <td> 10 </td>
  </tr>
  <tr> 
    <td> CONTAINER_RUNTIME </td>
    <td> Give the target container runtime </td>
    <td> Optional </td>
    <td> containerd </td>
  </tr>
  <tr> 
    <td> SOCKET_PATH </td>
    <td> Socket path for the container runtime </td>
    <td> Optional </td>
    <td> /run/containerd/containerd.sock </td>
  </tr>
  <tr> 
    <td> TOTAL_CHAOS_DURATION </td>
    <td> The time duration for chaos injection (seconds) </td>
    <td> Optional </td>
    <td> 120 </td>
  </tr> 
  <tr>
    <td> EXPERIMENT_IMAGE </td>
    <td> We can provide custom image for running chaos experiment </td>
    <td> Optional </td>
    <td> litmuschaos/go-runner </td>
  </tr>
  <tr>
    <td> EXPERIMENT_IMAGE_TAG </td>
    <td> We can set the image tag while using custom image for the chaos experiment </td>
    <td> Optional </td>
    <td> 3.18.0 </td>
  </tr>  
  <tr>
    <td> IMAGE_PULL_POLICY </td>
    <td> We can set the image pull policy while using custom image for running chaos experiment </td>
    <td> Optional </td>
    <td> Always </td>
  </tr>
  <tr>
    <td> INSTALL_LITMUS </td>
    <td> Keep it true to install litmus if litmus is not already installed </td>
    <td> Optional </td>
    <td> Not set to true </td>
  </tr>
  <tr>
    <td> LITMUS_CLEANUP </td>
    <td> Keep it true to uninstall litmus after chaos </td>
    <td> Optional </td>
    <td> Not set to true </td>
  </tr>
</table>

## Experiment Execution Process

The experiment execution has evolved to use a more sophisticated SDK-based approach with these steps:
1. **Authentication & Setup**: Connect to Litmus Chaos Center using SDK credentials
2. **Infrastructure Provisioning**: Create or use existing chaos infrastructure
3. **Experiment Configuration**: Configure experiment parameters and probe settings
4. **Execution & Monitoring**: Run the experiment with unique ID and monitor progress
5. **Result Verification**: Verify results through detailed phase checking
6. **Optional Cleanup**: Remove chaos infrastructure if LITMUS_CLEANUP is set to true
