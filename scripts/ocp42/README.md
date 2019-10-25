# Kabanero Foundation scripted install for Openshift 4

## Prerequisites

* Openshift 4.2+ or Code Ready Containers 4.2+
* Clone or download this repository

# Install

Install makes use of Operator Lifecycle Manager to subscribe to Kabanero operator and its prerequisite Operators.  

`install-subscriptions-crds.sh`

The Kabanero operator is installed using version 0.3.0-alpha.1.  If you would like to use a more recent version, the kabanero-operator project can be built and deployed with an internal catalog via Subscription in the following manner.
```
export IMAGE=default-route-openshift-image-registry.apps.CLUSTER.example.com/kabanero/kabanero-operator:latest
export REGISTRY_IMAGE=default-route-openshift-image-registry.apps.CLUSTER.example.com/openshift-marketplace/kabanero-operator-registry:latest
export INTERNAL_IMAGE=image-registry.openshift-image-registry.svc:5000/kabanero/kabanero-operator:latest
export INTERNAL_REGISTRY_IMAGE=image-registry.openshift-image-registry.svc:5000/openshift-marketplace/kabanero-operator-registry:latest
make build-image
make push-image
make deploy-olm
```


To create the Kabanero instance, and its prerequisite CustomResources

`create-crs.sh`


# Uninstall

To delete the Kabanero instance, and its prerequisite CustomResources

`delete-crs.sh`


To unsubscribe and remove Kabanero operator and its prerequisite operators.  

`uninstall-subscriptions-crds.sh`