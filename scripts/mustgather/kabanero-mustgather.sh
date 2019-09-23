#!/bin/bash
#
# Run this script to collect debug information

set -Euox pipefail

COMPONENT="kabanero.io"
BIN=oc
LOGS_DIR=kabanero-debug

# Describe and Get all api resources of component across cluster

APIRESOURCES=$(${BIN} get crds -o jsonpath="{.items[*].metadata.name}" | tr ' ' '\n' | grep ${COMPONENT})

for APIRESOURCE in ${APIRESOURCES[@]}
do
	NAMESPACES=$(${BIN} get ${APIRESOURCE} --all-namespaces=true -o jsonpath="{.items[*].metadata.namespace}")
	for NAMESPACE in ${NAMESPACES[@]}
	do
		mkdir -p ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}
		${BIN} describe ${APIRESOURCE} -n ${NAMESPACE} > ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}/describe.log
		${BIN} get ${APIRESOURCE} -n ${NAMESPACE} -o=yaml > ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}/get.yaml
	done
done


# Collect knative pod logs, describe & get additional resources

NAMESPACES=(kabanero)
APIRESOURCES=(configmaps pods routes services)

for NAMESPACE in ${NAMESPACES[@]}
do
	PODS=$(${BIN} get pods -n ${NAMESPACE} -o jsonpath="{.items[*].metadata.name}")
	for POD in ${PODS[@]}
	do
		${BIN} logs --all-containers=true -n ${NAMESPACE} ${POD} > ${LOGS_DIR}/${NAMESPACE}/pods/${POD}.log
	done
	
	for APIRESOURCE in ${APIRESOURCES[@]}
	do
		mkdir -p ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}
		${BIN} describe ${APIRESOURCE} -n ${NAMESPACE} > ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}/describe.log
		${BIN} get ${APIRESOURCE} -n ${NAMESPACE} -o=yaml > ${LOGS_DIR}/${NAMESPACE}/${APIRESOURCE}/get.yaml
	done
done




