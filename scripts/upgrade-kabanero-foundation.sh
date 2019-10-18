#!/bin/bash

set -Eeox pipefail

# Branch/Release of Kabanero #
KABANERO_BRANCH="${KABANERO_BRANCH:-0.2.0}"
namespace=kabanero

# Make sure we can find the kabanero-operator deployment in the cluster
if [ `oc get deployments kabanero-operator -n ${namespace} --no-headers --ignore-not-found | wc -l` -lt 1 ] ; then
    set +x
    echo "The upgrade script could not find the kabanero-operator deployment."
    echo "Please be sure that Kabanero is installed in namespace ${namespace}."
    exit 1
fi

# Make sure the specified version exists on dockerhub
if [ ! `curl --silent --fail --list-only --show-error --location https://index.docker.io/v1/repositories/kabanero/kabanero-operator/tags/${KABANERO_BRANCH}` ] ; then
    set +x
    echo "Kabanero branch ${KABANERO_BRANCH} was not found in dockerhub."
    exit 1
fi

# Patch the kabanero-operator deployment to use the new image
oc set image -n ${namespace} deployment/kabanero-operator kabanero-operator=kabanero/kabanero-operator:${KABANERO_BRANCH}

set +x
echo "The upgrade to ${KABANERO_BRANCH} is complete.  Please modify your"
echo "Kabanero CR instances to use the new version, as well as the new"
echo "collection repository if applicable.  For example, to use"
echo "version 0.2.0:"
echo ""
echo "apiVersion: kabanero.io/v1alpha1"
echo "kind: Kabanero"
echo "metadata:"
echo "  name: kabanero"
echo "  namespace: ${namespace}"
echo "spec:"
echo "  version: \"0.2.0\""
echo "  collections: "
echo "    repositories: "
echo "    - name: central"
echo "      url: https://github.com/kabanero-io/collections/releases/download/0.2.0/kabanero-index.yaml"
echo "      activateDefaultCollections: true"
echo ""
echo "To list Kabanero CR instances in namespace ${namespace}, use:"
echo "oc get kabaneros -n ${namespace}"
