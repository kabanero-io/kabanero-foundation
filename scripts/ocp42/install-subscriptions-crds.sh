#!/bin/bash


set -Eeox pipefail

SLEEP_LONG="${SLEEP_LONG:-5}"
SLEEP_SHORT="${SLEEP_SHORT:-2}"

# Args: subscription.yaml, subscription metadata.name, namespace
subscribe () {
	# Apply Subscription with Manual approval
	oc apply -f $1

	# Wait for the InstallPlan to be generated and available on status
	unset INSTALL_PLAN
	until oc get subscription $2 -n $3 --output=jsonpath={.status.installPlanRef.name}
	do
		sleep $SLEEP_SHORT
	done

	# Get the InstallPlan
	until [ -n "$INSTALL_PLAN" ]
	do
		sleep $SLEEP_SHORT
		INSTALL_PLAN=$(oc get subscription $2 -n $3 --output=jsonpath={.status.installPlanRef.name})
	done
	
	# Get CluserServiceVersion
	CSV=$(oc get subscription $2 -n $3 --output=jsonpath={.spec.startingCSV})

	# Approve the InstallPlan
	oc patch installplan $INSTALL_PLAN -n $3 --patch '{"spec":{"approved":true}}' --type=merge
	
	unset PHASE
	until [ "$PHASE" == "Complete" ]
	do
		PHASE=$(oc get installplan $INSTALL_PLAN -n $3 --output=jsonpath={.status.phase})
		sleep $SLEEP_SHORT
	done
	
	unset PHASE
	until [ "$PHASE" == "Succeeded" ]
	do
		PHASE=$(oc get clusterserviceversion $CSV -n $3 --output=jsonpath={.status.phase})
		sleep $SLEEP_SHORT
	done
}

oc apply -f catalogsource-kabanero.yaml

subscribe subscription-elasticsearch.yaml elasticsearch-operator openshift-operators

subscribe subscription-jaeger.yaml jaeger-product openshift-operators

subscribe subscription-kiali.yaml kiali-ossm openshift-operators

subscribe subscription-servicemesh.yaml servicemeshoperator openshift-operators

subscribe subscription-appsody.yaml appsody-operator-certified-beta-certified-operators-openshift-marketplace openshift-operators

subscribe subscription-eventing.yaml knative-eventing-operator-alpha-community-operators-openshift-marketplace openshift-operators

subscribe subscription-pipelines.yaml openshift-pipelines-operator-dev-preview-community-operators-openshift-marketplace openshift-operators

subscribe subscription-serving.yaml serverless-operator openshift-operators

oc apply -f operatorgroup-kabanero.yaml

subscribe subscription-kabanero.yaml kabanero-operator kabanero

subscribe subscription-che.yaml eclipse-che kabanero


