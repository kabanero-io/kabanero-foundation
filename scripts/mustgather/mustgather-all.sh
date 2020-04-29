#!/bin/bash
#
# Run this script to collect debug information

set -Euo pipefail

export LOGS_DIR="${LOGS_DIR:-kabanero-debug}"

rm -Rf ${LOGS_DIR}

echo "Collecting Appsody information."
./appsody-mustgather.sh

echo "Collecting Service Mesh information."
./servicemesh-mustgather.sh

echo "Collecting Kabanero information."
./kabanero-mustgather.sh

echo "Collecting Knative information."
./knative-mustgather.sh

echo "Collecting Tekton information."
./tekton-mustgather.sh

echo "Collecting CodeReady Workspaces information."
./codeready-workspaces-mustgather.sh

echo "Collecting kAppNav information."
./kappnav-mustgather.sh

echo "Creating ${LOGS_DIR}.tar.gz file."
tar -zcf ${LOGS_DIR}.tar.gz ${LOGS_DIR}
rm -Rf ${LOGS_DIR}
echo "Done."
