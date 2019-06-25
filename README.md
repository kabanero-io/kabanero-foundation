## Kabanero Foundation in a Kubernetes Cluster Prerequisites 

### Software Installation

- [OKD](https://www.okd.io/) v3.11.0+
- [Operator Lifecycle Manager](https://github.com/operator-framework/operator-lifecycle-manager/releases) 0.10.0+


### Cluster Hardware Capacity

The full suite of Kabanero foundation components include: 
  - Istio
  - Knative 
    - Eventing
    - Serving
  - Tekton 
    - Dashboard
    - Pipelines

The default configuration for the Kabanero foundation components require a scheduling capacity of approximately:
  - 6 CPU cores
  - 16GB of memory

Optional Recommended Openshift Components include:

  - [openshift-logging](https://docs.openshift.com/container-platform/3.11/install_config/aggregate_logging.html)
  - [openshift-metrics](https://docs.openshift.com/container-platform/3.11/install_config/cluster_metrics.html)
  - [openshift-monitoring](https://docs.openshift.com/container-platform/3.11/install_config/prometheus_cluster_monitoring.html)

The default configuration for the optional recommended Openshift components with defined resource requests and limits has an upper bound requiring approximately:
  - 3.5 + ( 0.25 * #nodes ) CPU Cores
  - 26GB + ( 1GB * #nodes ) Memory
    - Notably elasticsearch requires a large memory node to schedule on

The [](prereq-details.md) illustrates the default container resource requests and limits in a 3 node cluster.
