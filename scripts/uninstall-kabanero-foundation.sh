#!/bin/bash

# Modify the shell to fail immediately when a command in the script fails.
# Also echo each command as it's executed.
set -Eeox pipefail

KABANERO_OPERATOR_NAMESPACE=kabanero
TEKTON_DASHBOARD_RELEASE=v0.1.1
ISTIO_ARCH=linux
ISTIO_VERSION=1.1.7

# Clean up Kabanero instances and the Kabanero operator if the Kabanero
# CRDs still exist
if [ `oc get crds kabaneros.kabanero.io --no-headers --ignore-not-found | wc -l` -gt 0 ] ; then 

    # Delete any "Kind: Kabanero" objects in this cluster.  Print a list of
    # each Kabanero instance along with its namespace.  Then delete them one
    # by one.
    oc get kabaneros --all-namespaces -o=custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace --no-headers --ignore-not-found | while read KAB_NAME KAB_NAMESPACE; do oc delete kabanero $KAB_NAME --namespace $KAB_NAMESPACE; done

    # Wait for all of the Kabanero instances to be deleted.  We don't want to
    # delete the Kabanero operator until the operator has had a chance to
    # process its finalizer.
    echo "Waiting for Kabanero instances to be deleted...."
    LOOP_COUNT=0
    while [ `oc get kabaneros --all-namespaces | wc -l` -gt 0 ]
    do
        sleep 5
        LOOP_COUNT=`expr $LOOP_COUNT + 1`
        if [ $LOOP_COUNT -gt 10 ] ; then
            echo "Timed out waiting for Kabanero instances to be deleted"
            exit 1
        fi
    done

    # Delete the Kabanero operator.
    oc delete deployment kabanero-operator --namespace $KABANERO_OPERATOR_NAMESPACE
    oc delete clusterrolebinding kabanero-operator
    oc delete clusterrole kabanero-operator
    oc delete sa kabanero-operator --namespace $KABANERO_OPERATOR_NAMESPACE

    # Delete the Kabanero and Collection CRDs
    oc delete crd kabaneros.kabanero.io
    oc delete crd collections.kabanero.io
fi

# Delete the Tekton dashboard and webhook extension, if they were
# installed.  Use "|| true" here to force the script to continue if these
# steps fail, because the pipeline and task CRDs may no longer be installed.
curl -L https://github.com/tektoncd/dashboard/releases/download/${TEKTON_DASHBOARD_RELEASE}/openshift-tekton-dashboard.yaml \
    | sed "s/namespace: tekton-pipelines/namespace: $KABANERO_OPERATOR_NAMESPACE/" \
    | sed "s/default: tekton-pipelines/default: $KABANERO_OPERATOR_NAMESPACE/" \
    | oc delete --ignore-not-found --filename - || true
    
curl -L https://github.com/tektoncd/dashboard/releases/download/${TEKTON_DASHBOARD_RELEASE}/openshift-webhooks-extension.yaml \
    | sed "s/namespace: tekton-pipelines/namespace: $KABANERO_OPERATOR_NAMESPACE/" \
    | sed "s/value: tekton-pipelines/value: $KABANERO_OPERATOR_NAMESPACE/" \
    | oc delete --ignore-not-found --filename - || true

# Delete the Tekton config object.  This should trigger the Tekton operator
# to deregister its CRDs and remove its objects.  This is a cluster scoped
# object so there is no need to provide a namespace.
if [ `oc get crds config.operator.tekton.dev --no-headers --ignore-not-found | wc -l` -gt 0 ] ; then 
    oc delete config.operator.tekton.dev cluster --ignore-not-found

    # Wait for the Tekton CRDs to be unregistered
    echo "Waiting for Tekton CRDs to be unregistered...."
    LOOP_COUNT=0
    while [ `oc get crds tasks.tekton.dev taskruns.tekton.dev pipelines.tekton.dev pipelineruns.tekton.dev pipelineresources.tekton.dev clustertasks.tekton.dev --no-headers --ignore-not-found | wc -l` -gt 0 ]
    do
        sleep 5
        LOOP_COUNT=`expr $LOOP_COUNT + 1`
        if [ $LOOP_COUNT -gt 10 ] ; then
            echo "Timed out waiting for Tekton CRDs to be unregistered"
            exit 1
        fi
    done

    # Delete the Tekton operator
    oc delete deployment openshift-pipelines-operator  --ignore-not-found --namespace $KABANERO_OPERATOR_NAMESPACE
    oc delete clusterrolebinding openshift-pipelines-operator --ignore-not-found
    oc delete clusterrole openshift-pipelines-operator --ignore-not-found
    oc delete sa openshift-pipelines-operator --ignore-not-found --namespace $KABANERO_OPERATOR_NAMESPACE

    # Delete the Tekton install CRD
    oc delete crd config.operator.tekton.dev
fi

# Delete the knative-sources objects if the CRD is still present
if [ `oc get crds githubsources.sources.eventing.knative.dev --no-headers --ignore-not-found | wc -l` -gt 0 ] ; then
    oc delete statefulset controller-manager --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete service controller --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete clusterrolebinding eventing-sources-controller --ignore-not-found
    oc delete clusterrole eventing-sources-controller --ignore-not-found
    oc delete sa controller-manager --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found

    oc delete crd githubsources.sources.eventing.knative.dev
fi

# Delete the Knative serving marker object.  This will cause the Knative
# serving objects, and CRDs, to be deleted.
if [ `oc get crds knativeservings.serving.knative.dev --no-headers --ignore-not-found | wc -l` -gt 0 ] ; then 
    oc delete knativeservings knative-serving --namespace knative-serving --ignore-not-found

    # Wait for the knative serving CRDs to be deleted.
    echo "Waiting for Knative serving CRDs to be unregistered...."
    LOOP_COUNT=0
    while [ `oc get crds configurations.serving.knative.dev revisions.serving.knative.dev routes.serving.knative.dev services.serving.knative.dev --no-headers --ignore-not-found | wc -l` -gt 0 ]
    do
        sleep 5
        LOOP_COUNT=`expr $LOOP_COUNT + 1`
        if [ $LOOP_COUNT -gt 10 ] ; then
            echo "Timed out waiting for Knative serving CRDs to be unregistered"
            exit 1
        fi
    done

    # Delete the knative serving operator
    oc delete deployment knative-serving-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete clusterrolebinding knative-serving-operator --ignore-not-found
    oc delete clusterrole knative-serving-operator --ignore-not-found
    oc delete rolebinding knative-serving-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete role knative-serving-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete sa knative-serving-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found

    # Delete the knative serving operator CRD
    oc delete crd knativeservings.serving.knative.dev
fi

# Delete the Knative eventing marker object.  This will cause the Knative
# eventing objects, and CRDs, to be deleted.
if [ `oc get crds knativeeventings.eventing.knative.dev --no-headers --ignore-not-found | wc -l` -gt 0 ] ; then
    oc delete knativeeventings knative-eventing --namespace knative-eventing --ignore-not-found

    # Wait for the knative eventing CRDs to be deleted.
    echo "Waiting for Knative eventing CRDs to be unregistered...."
    LOOP_COUNT=0
    while [ `oc get crds brokers.eventing.knative.dev channels.eventing.knative.dev clusterchannelprovisioners.eventing.knative.dev eventtypes.eventing.knative.dev subscriptions.eventing.knative.dev triggers.eventing.knative.dev --no-headers --ignore-not-found | wc -l` -gt 0 ]
    do
        sleep 5
        LOOP_COUNT=`expr $LOOP_COUNT + 1`
        if [ $LOOP_COUNT -gt 10 ] ; then
            echo "Timed out waiting for Knative eventing CRDs to be unregistered"
            exit 1
        fi
    done

    # Delete the knative eventing operator
    oc delete deployment knative-eventing-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete clusterrolebinding knative-eventing-operator --ignore-not-found
    oc delete clusterrole knative-eventing-operator --ignore-not-found
    oc delete rolebinding knative-eventing-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete role knative-eventing-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found
    oc delete sa knative-eventing-operator --namespace $KABANERO_OPERATOR_NAMESPACE --ignore-not-found

    # Delete the knative eventing install CRD
    oc delete crd knativeeventings.eventing.knative.dev
fi

# Remove istio.
curl -L https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-$ISTIO_ARCH.tar.gz | tar -zxf -
cd istio-$ISTIO_VERSION
oc delete -f install/kubernetes/istio-demo.yaml --ignore-not-found || true
for i in install/kubernetes/helm/istio-init/files/crd*yaml; do oc delete -f $i --ignore-not-found; done
cd ..
rm -Rf istio-$ISTIO_VERSION
