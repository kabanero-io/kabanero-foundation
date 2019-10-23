#!/bin/bash


set -x pipefail

# Eclipse Che instance

# Kabanero instance
oc delete -f cr-kabanero.yaml

# Knative Serving instance
oc delete -f cr-knative-serving.yaml

# Service Mesh member namespaces
oc delete -f cr-servicemeshmemberrole.yaml

# Service Mesh Control Plane
oc delete -f cr-servicemeshcontrolplane.yaml










