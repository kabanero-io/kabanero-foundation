#!/bin/bash

set -Eeuox pipefail

### Configuration ###

# Resultant Appsody container image #
DOCKER_IMAGE="${DOCKER_IMAGE:-docker-registry.default.svc:5000/kabanero/java-microprofile}"

# Appsody project GitHub repository #
APP_REPO="${APP_REPO:-https://github.com/dacleyra/appsody-hello-world/}"

### Tekton Example ###

# Create deploy target Project Namespace #
# oc new-project appsody-project || true

# Add Namespace to Service Mesh #
# oc label namespace appsody-project istio-injection=enabled --overwrite

# Namespace #
namespace=kabanero

# Grant SecurityContext to appsody-sa. Example PV uses hostPath
oc -n ${namespace} create sa appsody-sa || true
oc adm policy add-cluster-role-to-user cluster-admin -z appsody-sa -n ${namespace}
oc adm policy add-scc-to-user hostmount-anyuid -z appsody-sa -n ${namespace}

sleep 120

# Workaround https://github.com/tektoncd/pipeline/issues/1103
# Restart pipeline operator to avoid issue
oc scale -n ${namespace} deploy openshift-pipelines-operator --replicas=0
sleep 5
oc scale -n ${namespace} deploy openshift-pipelines-operator --replicas=1
readyReplicas=0
until [ "$readyReplicas" -ge 1 ]; do
  readyReplicas=$(oc get -n kabanero deploy openshift-pipelines-operator -o template --template={{.status.readyReplicas}})
  sleep 1
done

# Workaround https://github.com/tektoncd/pipeline/issues/1103
# Restart pipeline controller to avoid issue
oc scale -n openshift-pipelines deploy tekton-pipelines-controller --replicas=0
sleep 5
oc scale -n openshift-pipelines deploy tekton-pipelines-controller --replicas=1
readyReplicas=0
until [ "$readyReplicas" -ge 1 ]; do
  readyReplicas=$(oc get -n openshift-pipelines deploy tekton-pipelines-controller -o template --template={{.status.readyReplicas}})
  sleep 1
done

sleep 120


# Pipeline Resources: Source repo and destination container image
oc -n ${namespace} delete pipelineresource docker-image git-source || true
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
oc -n ${namespace} delete pipelinerun manual-pipeline-run || true
cat <<EOF | oc -n ${namespace} apply -f -
apiVersion: tekton.dev/v1alpha1
kind: PipelineRun
metadata:
  name: manual-pipeline-run
spec:
  serviceAccount: appsody-sa
  timeout: "1h0m0s"  
  pipelineRef:
    name: java-microprofile-build-deploy-pipeline
  trigger:
    type: manual
  resources:
    - name: git-source
      resourceRef:
        name: git-source
    - name: docker-image
      resourceRef:
        name: docker-image
EOF
