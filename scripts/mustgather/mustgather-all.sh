#!/bin/bash
#
# Run this script to collect debug information

set -Euox pipefail

LOGS_DIR="${LOGS_DIR:-kabanero-debug}"

rm -Rf ${LOGS_DIR}

./appsody-mustgather.sh
./istio-mustgather.sh
./kabanero-mustgather.sh
./knative-mustgather.sh
./tekton-mustgather.sh
./che-mustgather.sh
LOGS_DIR=$LOGS_DIR ./kappnav-mustgather.sh

tar -zcf ${LOGS_DIR}.tar.gz ${LOGS_DIR}
rm -Rf ${LOGS_DIR}
