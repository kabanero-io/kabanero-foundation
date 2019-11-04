#!/bin/bash

#
# Run this script against an active kabanero installation to gather the resource requests & limits
#

set -Eeuox pipefail

CSVFILE="../prereq-details.csv"
MDFILE="../prereq-details.md"
KABANERO_NAMESPACES=( "istio-system" "kabanero" "knative-eventing" "knative-serving" "knative-sources" "openshift-operators" "openshift-pipelines" "tekton-pipelines" )


# Kabanero Foundation

# CSV
echo 'Namespace,Pod,Container,CPU Requests,CPU Limits,Memory Requests,Memory Limits' | tee ${CSVFILE}

# MD
echo '## Kabanero Foundation Components' | tee ${MDFILE}
echo '| Namespace | Pod | Container | CPU Requests | CPU Limits | Memory Requests | Memory Limits |' | tee -a ${MDFILE}
echo '| :--- | :--- | :--- | :--- | :--- | :--- | :--- |' | tee -a ${MDFILE}

for NAMESPACE in ${KABANERO_NAMESPACES[@]}
do
  # CSV
  oc get po -n ${NAMESPACE} -o=jsonpath="{range .items[*]}{.metadata.namespace}{','}{.metadata.name}{'\n'}{range .spec.containers[*]}{','}{','}{.name}{','}{.resources.requests.cpu}{','}{.resources.limits.cpu}{','}{.resources.requests.memory}{','}{.resources.limits.memory}{'\n'}{end}{end}" | tee -a ${CSVFILE}
  
  # MD
  oc get po -n ${NAMESPACE} -o=jsonpath="{range .items[*]}{'| '}{.metadata.namespace}{' | '}{.metadata.name}{' | | | | | |'}{'\n'}{range .spec.containers[*]}{'| | | '}{.name}{' | '}{.resources.requests.cpu}{' | '}{.resources.limits.cpu}{' | '}{.resources.requests.memory}{' | '}{.resources.limits.memory}{' |'}{'\n'}{end}{end}" | tee -a ${MDFILE}
done

