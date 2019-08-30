#!/bin/bash

all_nss="istio-system istio-operator kabanero knative-eventing knative-serving"
all_comps="tekton kabanero knative istio"

usage () {
	echo "usage: $0 [options]"
	echo "  options:"
	echo "    -r                        Delete all resources found by 'oc get all' in specified namespaces"
	echo "    -d                        Delete a bunch of other resources that _aren't found by 'oc get all'"
	echo "    -c                        Delete CRDs based on grep; __CAUTION: THIS COULD MESS UP YOUR CLUSTER because the grep matches too much in some cases)__"
	echo "    -n                        Delete namespaces"
	echo "    -o \"OPT1 OPT2 ...\"        Specify either list of namespaces or components to grep for (grep only for CRDs)"
}

delete_all_res() {
    nss=$1
    if [ -z $nss ]; then
         nss="${all_nss}"
    fi
    
    for ns in $nss
    do
        echo -e "\n\n---------- Deleting 'all' in ${ns} ----------\n\n"
        oc delete all --all -n $ns
    done
}

delete_crds() {
    dels=$1
    if [ -z $dels ]; then
         dels="${all_comps}"
    fi
    
    for item in $dels
    do
        echo -e "\n\n---------- Deleteing CRDs for ${item} ----------\n\n"
        crds=$(oc get crds | grep -i $item | awk '{print $1}')
        oc delete crds $crds
    done
}

delete_dangling() {
    nss=$1
    if [ -z $nss ]; then
         nss="${all_nss}"
    fi
    
    oc delete apiservice v1beta1.custom.metrics.k8s.io
    
    for ns in $nss
	do
	    echo -e "\n\n---------- Deleteing dangling resources for ${ns} ----------\n\n"
	    dangling_resources=$(oc api-resources --verbs=list --namespaced -o name | xargs -n 1 oc get -o name -n $ns)
	    for dr in ${dangling_resources}
	    do
	        oc delete $dr -n $ns
	    done
	done

}

delete_namespaces() {
    nss=$1
    if [ -z $nss ]; then
         nss="${all_nss}"
    fi
    
    for ns in $nss
    do
        echo -e "\n\n---------- Deleting namespace ${ns} ----------\n\n"
        oc delete ns $ns
    done
}

while getopts ":rcdno:" opt; do
    case ${opt} in
        r )
            del_res=1
            ;;
        d )
            del_dangling=1
            ;;
        c )
            del_crd=1
            ;;
        n )
            del_ns=1
            ;;
        o) 
            options=$OPTARG
            ;;
        \? )
            usage
            ;;
        h )
            usage
            ;;
    esac
done

if [ ! -z $del_res ]; then
    delete_all_res $options
fi

if [ ! -z $del_crd ]; then
    delete_crds $options
fi

if [ ! -z $del_dangling ]; then
    delete_dangling $options
fi

if [ ! -z $del_ns ]; then
    delete_namespaces $options
fi
