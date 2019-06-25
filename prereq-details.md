## Kabanero Foundation Components
| Namespace | Pod | Container | CPU Requests | CPU Limits | Memory Requests | Memory Limits |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| istio-system | cluster-local-gateway-65c8b667c8-wt6d6 | | | | | |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-citadel-76bd44d8f7-bfxbk | | | | | |
| | | citadel | 10m |  |  |  |
| istio-system | istio-cleanup-secrets-kd65z | | | | | |
| | | hyperkube |  |  |  |  |
| istio-system | istio-egressgateway-b9d56b4f8-j4t47 | | | | | |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-galley-7db7db89db-f5wd5 | | | | | |
| | | validator | 10m |  |  |  |
| istio-system | istio-ingressgateway-f77fbc787-fjcf5 | | | | | |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-pilot-69f975bf4f-cmgvn | | | | | |
| | | discovery | 500m |  | 2Gi |  |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-pilot-69f975bf4f-hwqm4 | | | | | |
| | | discovery | 500m |  | 2Gi |  |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-pilot-69f975bf4f-lb7xv | | | | | |
| | | discovery | 500m |  | 2Gi |  |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-policy-8db48cbcd-xw9hs | | | | | |
| | | mixer | 10m |  |  |  |
| | | istio-proxy | 10m |  |  |  |
| istio-system | istio-security-post-install-d5vdz | | | | | |
| | | hyperkube |  |  |  |  |
| istio-system | istio-sidecar-injector-cd54ffccd-znzj4 | | | | | |
| | | sidecar-injector-webhook | 10m |  |  |  |
| istio-system | istio-telemetry-d78cd45db-95x44 | | | | | |
| | | mixer | 10m |  |  |  |
| | | istio-proxy | 10m |  |  |  |
| kabanero | kabanero-operator-596c78d5bf-s55nb | | | | | |
| | | kabanero-operator |  |  |  |  |
| kabanero | knative-eventing-operator-67cdf5dc9f-xlrnv | | | | | |
| | | knative-eventing-operator |  |  |  |  |
| kabanero | knative-serving-operator-b64558bbc-2sd7g | | | | | |
| | | knative-serving-operator |  |  |  |  |
| kabanero | openshift-pipelines-operator-7fc5d956c5-z5zbs | | | | | |
| | | openshift-pipelines-operator |  |  |  |  |
| kabanero | tekton-pipelines-controller-6467577f67-czlxj | | | | | |
| | | tekton-pipelines-controller |  |  |  |  |
| kabanero | tekton-pipelines-webhook-66bf4ff96d-d8wxb | | | | | |
| | | webhook |  |  |  |  |
| olm | catalog-operator-6bb8ffd7c5-ldl58 | | | | | |
| | | catalog-operator |  |  |  |  |
| olm | olm-operator-78ff5d69cf-p4p9g | | | | | |
| | | olm-operator |  |  |  |  |
| olm | olm-operators-gdkdq | | | | | |
| | | configmap-registry-server |  |  |  |  |
| olm | operatorhubio-catalog-lcghw | | | | | |
| | | registry-server |  |  |  |  |
| olm | packageserver-7f87994ff4-9s2lc | | | | | |
| | | packageserver |  |  |  |  |
| olm | packageserver-7f87994ff4-df26z | | | | | |
| | | packageserver |  |  |  |  |
## Optional Recommended Openshift Components
| Namespace | Pod | Container | CPU Requests | CPU Limits | Memory Requests | Memory Limits |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| openshift-infra | hawkular-cassandra-1-pr848 | | | | | |
| | | hawkular-cassandra-1 |  |  | 1G | 2G |
| openshift-infra | hawkular-metrics-62bj2 | | | | | |
| | | hawkular-metrics |  |  | 1500M | 2500M |
| openshift-infra | hawkular-metrics-schema-p56sx | | | | | |
| | | hawkular-metrics-schema |  |  |  |  |
| openshift-infra | heapster-hk97p | | | | | |
| | | heapster |  |  | 937500k | 3750M |
| openshift-logging | logging-curator-1561458600-l9bv8 | | | | | |
| | | curator | 100m |  | 256Mi | 256Mi |
| openshift-logging | logging-es-data-master-6cogj3rx-1-2297z | | | | | |
| | | elasticsearch | 1 |  | 8G | 8G |
| | | proxy | 100m |  | 64Mi | 64Mi |
| openshift-logging | logging-fluentd-52zbh | | | | | |
| | | fluentd-elasticsearch | 100m |  | 756Mi | 756Mi |
| openshift-logging | logging-fluentd-8llnh | | | | | |
| | | fluentd-elasticsearch | 100m |  | 756Mi | 756Mi |
| openshift-logging | logging-fluentd-jr5z2 | | | | | |
| | | fluentd-elasticsearch | 100m |  | 756Mi | 756Mi |
| openshift-logging | logging-kibana-1-hrgpj | | | | | |
| | | kibana | 100m |  | 736Mi | 736Mi |
| | | kibana-proxy | 100m |  | 256Mi | 256Mi |
| openshift-monitoring | alertmanager-main-0 | | | | | |
| | | alertmanager |  |  | 200Mi |  |
| | | config-reloader | 5m | 5m | 10Mi | 10Mi |
| | | alertmanager-proxy |  |  |  |  |
| openshift-monitoring | alertmanager-main-1 | | | | | |
| | | alertmanager |  |  | 200Mi |  |
| | | config-reloader | 5m | 5m | 10Mi | 10Mi |
| | | alertmanager-proxy |  |  |  |  |
| openshift-monitoring | alertmanager-main-2 | | | | | |
| | | alertmanager |  |  | 200Mi |  |
| | | config-reloader | 5m | 5m | 10Mi | 10Mi |
| | | alertmanager-proxy |  |  |  |  |
| openshift-monitoring | cluster-monitoring-operator-6465f8fbc7-hqwbj | | | | | |
| | | cluster-monitoring-operator | 20m | 20m | 50Mi | 50Mi |
| openshift-monitoring | grafana-6b9f85786f-bfvml | | | | | |
| | | grafana | 100m | 200m | 100Mi | 200Mi |
| | | grafana-proxy |  |  |  |  |
| openshift-monitoring | kube-state-metrics-7449d589bc-q8c88 | | | | | |
| | | kube-rbac-proxy-main | 10m | 20m | 20Mi | 40Mi |
| | | kube-rbac-proxy-self | 10m | 20m | 20Mi | 40Mi |
| | | kube-state-metrics |  |  |  |  |
| openshift-monitoring | node-exporter-2bmhf | | | | | |
| | | node-exporter |  |  |  |  |
| | | kube-rbac-proxy | 10m | 20m | 20Mi | 40Mi |
| openshift-monitoring | node-exporter-f6kxn | | | | | |
| | | node-exporter |  |  |  |  |
| | | kube-rbac-proxy | 10m | 20m | 20Mi | 40Mi |
| openshift-monitoring | node-exporter-hjvxb | | | | | |
| | | node-exporter |  |  |  |  |
| | | kube-rbac-proxy | 10m | 20m | 20Mi | 40Mi |
| openshift-monitoring | prometheus-k8s-0 | | | | | |
| | | prometheus |  |  |  |  |
| | | prometheus-config-reloader | 10m | 10m | 50Mi | 50Mi |
| | | prometheus-proxy |  |  |  |  |
| | | rules-configmap-reloader | 5m | 5m | 10Mi | 10Mi |
| openshift-monitoring | prometheus-k8s-1 | | | | | |
| | | prometheus |  |  |  |  |
| | | prometheus-config-reloader | 10m | 10m | 50Mi | 50Mi |
| | | prometheus-proxy |  |  |  |  |
| | | rules-configmap-reloader | 5m | 5m | 10Mi | 10Mi |
| openshift-monitoring | prometheus-operator-6644b8cd54-rdqz5 | | | | | |
| | | prometheus-operator |  |  |  |  |
