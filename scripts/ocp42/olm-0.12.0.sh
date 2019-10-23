#!/bin/bash


set -x pipefail



# Disable Cluster Version Operator
oc scale --replicas 0 -n openshift-cluster-version deployments/cluster-version-operator

sleep 5

oc scale --replicas 0 -n openshift-operator-lifecycle-manager deploy olm-operator
oc scale --replicas 0 -n openshift-operator-lifecycle-manager deploy catalog-operator
oc scale --replicas 0 -n openshift-operator-lifecycle-manager deploy packageserver

sleep 5

oc delete -n openshift-operator-lifecycle-manager deploy olm-operator
oc delete -n openshift-operator-lifecycle-manager deploy catalog-operator
oc delete -n openshift-operator-lifecycle-manager csv packageserver

sleep 5

cd $GOPATH/src/github.com/operator-framework/operator-lifecycle-manager
git pull
git checkout master

oc apply -f deploy/ocp/manifests/0.12.0/

# Patch OLM Operator Deployment

