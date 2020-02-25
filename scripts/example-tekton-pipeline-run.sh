#!/bin/bash

set -Eeuox pipefail

### Configuration ###

# Resultant Appsody container image #
DOCKER_IMAGE="${DOCKER_IMAGE:-image-registry.openshift-image-registry.svc:5000/kabanero/java-microprofile}"

# Appsody project GitHub repository #
APP_REPO="${APP_REPO:-https://github.com/dacleyra/appsody-hello-world/}"

### Tekton Example ###
namespace=kabanero

# Cleanup
oc -n ${namespace} delete pipelinerun java-microprofile-manual-pipeline-run || true
oc -n ${namespace} delete pipelineresource docker-image git-source || true

# Pipeline Resources: Source repo and destination container image
cat <<EOF | oc -n ${namespace} apply -f -
apiVersion: v1
items:
- apiVersion: tekton.dev/v1alpha1
  kind: PipelineResource
  metadata:
    name: docker-image
  spec:
    params:
    - name: url
      value: ${DOCKER_IMAGE}
    type: image
- apiVersion: tekton.dev/v1alpha1
  kind: PipelineResource
  metadata:
    name: git-source
  spec:
    params:
    - name: revision
      value: master
    - name: url
      value: ${APP_REPO}
    type: git
kind: List
EOF


# Manual Pipeline Run
cat <<EOF | oc -n ${namespace} apply -f -
apiVersion: tekton.dev/v1alpha1
kind: PipelineRun
metadata:
  name: java-microprofile-manual-pipeline-run
  namespace: kabanero
spec:
  pipelineRef:
    name: java-microprofile-build-push-deploy-pipeline
  resources:
  - name: git-source
    resourceRef:
      name: git-source
  - name: docker-image
    resourceRef:
      name: docker-image
  serviceAccount: kabanero-operator
  timeout: 60m
EOF
