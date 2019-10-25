#!/bin/bash

SLEEP_LONG="${SLEEP_LONG:-5}"
SLEEP_SHORT="${SLEEP_SHORT:-2}"

# Optional components (yes/no)
ENABLE_KAPPNAV="${ENABLE_KAPPNAV:-no}"
ENABLE_CHE="${ENABLE_CHE:-NO}"

set -Eeox pipefail

# Service Mesh Control Plane
oc apply -f cr-servicemeshcontrolplane.yaml

# Service Mesh member namespaces
oc apply -f cr-servicemeshmemberrole.yaml

# Knative Serving instance
oc apply -f cr-knative-serving.yaml

# Kabanero instance
oc apply -f cr-kabanero.yaml

# Configure an Eclipse Che instance if selected
if [ "$ENABLE_CHE" == "yes" ]
then
   oc apply -f cr-che.yaml
fi

# Github Sources
oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.9.0/github.yaml

# Need to wait for knative serving CRDs before installing tekton webhook extension
until oc get crd services.serving.knative.dev 
do
  sleep $SLEEP_SHORT
done

# Tekton Dashboard
oc new-project tekton-pipelines || true
oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml
oc apply -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml
