#!/bin/bash


set -x pipefail

# Tekton Dashboard
oc delete -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml
oc delete -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml

# Github Sources
oc delete -f https://github.com/knative/eventing-contrib/releases/download/v0.9.0/github.yaml

# Eclipse Che instance
oc delete -f cr-che.yaml

# Kabanero instance
oc delete -f cr-kabanero.yaml

# Knative Serving instance
oc delete -f cr-knative-serving.yaml

# Service Mesh member namespaces
oc delete -f cr-servicemeshmemberrole.yaml

# Service Mesh Control Plane
oc delete -f cr-servicemeshcontrolplane.yaml










