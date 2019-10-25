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

unsubscribe kabanero-operator kabanero

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

oc delete -f catalogsource-kabanero.yaml

# Cleanup from the openshift service mesh readme
oc delete validatingwebhookconfiguration/openshift-operators.servicemesh-resources.maistra.io
oc delete -n openshift-operators daemonset/istio-node
oc delete clusterrole/istio-admin
oc get crds -o name | grep '.*\.istio\.io' | xargs -r -n 1 oc delete
oc get crds -o name | grep '.*\.maistra\.io' | xargs -r -n 1 oc delete
