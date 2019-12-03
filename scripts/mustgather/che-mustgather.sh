#!/bin/bash
#
# Run this script to collect debug information for the Che install.

set -Euo pipefail

COMPONENT="org.eclipse.che"
BIN=oc
LOGS_DIR="${LOGS_DIR:-che-debug}"
KEY_PATTTERN="[-._]che[-._]|\<che\>|eclipse|theia|postgres|codewind"
KEY_LABEL="app=che"
CLUSTERRESDIR="kube-system"

# Describe and Get all Che associated resources across the cluster.
CRDS=$(${BIN} get crds -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep ${COMPONENT})

for CUSTOMRESOURCE in ${CRDS[@]}
do
	NAMESPACES=$(${BIN} get ${CUSTOMRESOURCE} --all-namespaces=true -o jsonpath='{range .items[*]}{@.metadata.namespace}{"\n"}{end}' | uniq)

	for NAMESPACE in ${NAMESPACES[@]}
	do
		# Get CR instance data.
		NSPATH=${LOGS_DIR}/namespaces/${NAMESPACE}
		CRINTSPATH=${NSPATH}/${CUSTOMRESOURCE}
		mkdir -p ${CRINTSPATH}
		${BIN} describe ${CUSTOMRESOURCE} -n ${NAMESPACE} > ${CRINTSPATH}/describe.log
		${BIN} get ${CUSTOMRESOURCE} -n ${NAMESPACE} -o=yaml > ${CRINTSPATH}/get.yaml

		# Get Pod data.
		PODSBYNAME=$(${BIN} get pods -n ${NAMESPACE} -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -E ${KEY_PATTTERN})
		PODSBYLABEL=$(${BIN} get pods -l ${KEY_LABEL} -n ${NAMESPACE} -o jsonpath="{.items[*].metadata.name}")
		PODS=$(echo ${PODSBYNAME} ${PODSBYLABEL} | tr ' ' '\n' | sort -du)
		PODSPATH=${NSPATH}/pods
		mkdir -p ${PODSPATH}
		for POD in ${PODS[@]}
		do
			${BIN} logs --all-containers=true -n ${NAMESPACE} ${POD} > ${PODSPATH}/${POD}.log
		done

		# Get other resource data.
        APIRESOURCES=(configmaps routes roles rolebindings serviceaccounts services deployments)
		for APIRESOURCE in ${APIRESOURCES[@]}
		do

			RESOURCESBYNAME=$(${BIN} get ${APIRESOURCE} -n ${NAMESPACE} -o jsonpath="{.items[*].metadata.name}" | tr ' ' '\n' | grep -E ${KEY_PATTTERN})
			RESOURCESBYLABEL=$(${BIN} get ${APIRESOURCE} -l ${KEY_LABEL} -n ${NAMESPACE} -o jsonpath="{.items[*].metadata.name}")
			RESOURCES=$(echo ${RESOURCESBYNAME} ${RESOURCESBYLABEL} | tr ' ' '\n' | sort -du)

			for RESOURCE in ${RESOURCES[@]}
			do
				RESPATH=${NSPATH}/${APIRESOURCE}/${RESOURCE}
				mkdir -p ${RESPATH}
				${BIN} describe ${APIRESOURCE} ${RESOURCE} -n ${NAMESPACE} > ${RESPATH}/describe.log
				${BIN} get ${APIRESOURCE} ${RESOURCE} -n ${NAMESPACE} -o=yaml > ${RESPATH}/get.yaml
			done
		done
		
	done
done

# Collect cluster explicit resource data.
APIRESOURCES=(clusterroles clusterrolebindings persistentvolumes storageclasses)
for APIRESOURCE in ${APIRESOURCES[@]}
do
	RESOURCESBYNAME=$(${BIN} get ${APIRESOURCE} -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -E ${KEY_PATTTERN})
	RESOURCESBYLABEL=$(${BIN} get ${APIRESOURCE} -l ${KEY_LABEL} -o jsonpath="{.items[*].metadata.name}")
	RESOURCES=$(echo ${RESOURCESBYNAME} ${RESOURCESBYLABEL} | tr ' ' '\n' | sort -du)

	for RESOURCE in ${RESOURCES[@]}
	do
	    RESPATH=${LOGS_DIR}/${CLUSTERRESDIR}/${APIRESOURCE}/${RESOURCE}
		mkdir -p ${RESPATH}
		${BIN} describe ${APIRESOURCE} ${RESOURCE} > ${RESPATH}/describe.log
		${BIN} get ${APIRESOURCE} ${RESOURCE} -o=yaml > ${RESPATH}/get.yaml
	done
done

# Collect storage related resource data.
APIRESOURCES=(persistentvolumes storageclasses)
for APIRESOURCE in ${APIRESOURCES[@]}
do
	RESOURCES=$(${BIN} get ${APIRESOURCE} -o jsonpath='{.items[?(@.spec.claimRef.name=="postgres-data")].metadata.name}')

	for RESOURCE in ${RESOURCES[@]}
	do
	    RESPATH=${LOGS_DIR}/${CLUSTERRESDIR}/${APIRESOURCE}/${RESOURCE}
		mkdir -p ${RESPATH}
		${BIN} describe ${APIRESOURCE} ${RESOURCE} > ${RESPATH}/describe.log
		${BIN} get ${APIRESOURCE} ${RESOURCE} -o=yaml > ${RESPATH}/get.yaml
	done
done