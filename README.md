# Kabanero Foundation

A Kabanero instance is a deployment of a set of Kabanero collections in a specific Kubernetes cluster.  The Kabanero operator is leveraged to install and operate the various curated infrastructure and artifacts as defined by each of the collections. 


## Kabanero Foundation in a Kubernetes Cluster Prerequisites 

### Temporary move to OpenShift Container Platform (OCP)

The Kabanero Open Project intends to build on open source distributions of Kubernetes; however, the current distribution of (OKD) "The Origin Community Distribution of Kubernetes" is lagging the commercial distributions.   We are trying to build leading-edge capabilities and look to leverage new features across the integrated open frameworks.  Therefore, at least for the short term, we have chosen to focus on building version 4 capabilities of the commercial distributions.  When the OKD Community more generally releases version 4 and are available, our community will return focus on OKD.

### Software Installation

#### Release 0.3 pre-requisties

 - [OCP] (https://www.openshift.com/products/container-platform)  V4.2.0+

#### Release 0.1 and 0.2 pre-requisities

- [OKD](https://www.okd.io/) v3.11.0+

### Install

While logged in as a `cluster-admin` execute the install script from the kabanero-operator release

`curl -s -L https://github.com/kabanero-io/kabanero-operator/releases/download/0.3.3/install.sh | bash`

### Upgrade [ Release 0.3.1+ to 0.3.3 ]

While logged in as a `cluster-admin` execute the install script from the kabanero-operator release.  
The installation script will update the CatalogSource and previously installed operators.  

`curl -s -L https://github.com/kabanero-io/kabanero-operator/releases/download/0.3.3/install.sh | bash`

### Uninstall

While logged in as a `cluster-admin` execute the uninstall script from the kabanero-operator release

`curl -s -L https://github.com/kabanero-io/kabanero-operator/releases/download/0.3.3/uninstall.sh | bash`

### Cluster Hardware Capacity

The full suite of Kabanero foundation components include: 
  - Istio (ServiceMesh)
  - Knative 
    - Eventing
    - Serving
  - Tekton 
    - Dashboard
    - Pipelines
  - kAppNav
    - Operator
  - Appsody
    - Operator
  - Che
    - Operator
  - Kabanero
    - Operator
    - Dashboard
    - System-Management CLI

The default configuration for the Kabanero foundation components require a scheduling capacity of approximately:
  - 6 CPU cores
  - 16GB of memory


The following [table](prereq-details.md) illustrates the default container resource requests and limits in a 3 node cluster.

# appsody Application Requirements

## appsody Hardware Capacity

The default Kabanero collections are built from UBI sourced containers.

appsody currently includes 5 different stacks (compressed container size):
  - java-microprofile (308 MB)
  - java-spring-boot2 (269 MB)
  - nodejs (279 MB)
  - nodejs-express (275 MB)
  - nodejs-loopback (288 MB)
  
 Estimated required capactiy for running 10 appsody applications (Assuming roughly 16MB per application):
  - java-microprofile: **3240 MB**
  - java-spring-boot2: **2850 MB**
  - nodejs: **2950 MB**
  - nodejs-express: **2910 MB**
  - nodejs-loopback:  **2940 MB**
 
 # Kabanero Requirements

  - The Kabanero Operator requires `cluster-admin` privileges.
 
