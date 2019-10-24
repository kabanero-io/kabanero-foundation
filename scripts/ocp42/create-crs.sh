#!/bin/bash


set -Eeox pipefail

# Service Mesh Control Plane
oc apply -f cr-servicemeshcontrolplane.yaml

# Service Mesh member namespaces
oc apply -f cr-servicemeshmemberrole.yaml

# Knative Serving instance
oc apply -f cr-knative-serving.yaml

# Kabanero instance
oc apply -f cr-kabanero.yaml

# Eclipse Che instance
oc apply -f cr-che.yaml
