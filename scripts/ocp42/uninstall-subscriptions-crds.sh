#!/bin/bash


set -x pipefail

# Args: subscription metadata.name, namespace
unsubscribe () {

	# Get InstallPlan
	INSTALL_PLAN=$(oc get subscription $1 -n $2 --output=jsonpath={.status.installPlanRef.name})
	
	# Get CluserServiceVersion
	CSV=$(oc get subscription $1 -n $2 --output=jsonpath={.spec.startingCSV})
	
	# Delete Subscription 
	oc delete subscription $1 -n $2

	# Delete the InstallPlan
	oc delete installplan $INSTALL_PLAN -n $2
	
	# Delete the ClusterServiceVersion
	oc delete clusterserviceversion $CSV -n $2
	
}

# Tekton Dashboard
oc delete -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-tekton-dashboard.yaml
oc delete -f https://github.com/tektoncd/dashboard/releases/download/v0.2.0/openshift-webhooks-extension.yaml

unsubscribe kabanero-operator openshift-operators

unsubscribe serverless-operator openshift-operators

unsubscribe openshift-pipelines-operator-dev-preview-community-operators-openshift-marketplace openshift-operators

unsubscribe knative-eventing-operator-alpha-community-operators-openshift-marketplace openshift-operators

unsubscribe appsody-operator-certified-beta-certified-operators-openshift-marketplace openshift-operators

unsubscribe servicemeshoperator openshift-operators

unsubscribe kiali-ossm openshift-operators

unsubscribe jaeger-product openshift-operators

unsubscribe elasticsearch-operator openshift-operators

unsubscribe eclipse-che kabanero

oc delete -f operatorgroup-kabanero.yaml

# Github Sources
oc delete -f https://github.com/knative/eventing-contrib/releases/download/v0.9.0/github.yaml
