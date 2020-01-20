# Collection transition to Stack Design

## Key Concepts / Background
- Simplify key concepts by eliminating Collections and Collection Hubs
  -  Object model inheritence, e.g. A Collection ISA a Stack and a CollectionHub ISA a Stackhub, causes confusion especially for community messsaging, developers and new comers to the project.
  -  Monolithic build (CollectionHub) causes painful lifecycle for making configuration or manage the curated stacks and pipelines.

- In general, to replace Collection Hubs with Stack Hubs, and providing configuration for the governed stacks via the defined Kubernetes Custom Resources:  Kabanero CR.

- Renaming the collection CR a stack CR, which has essentially the same data and format.

- Although this is not a seemingly drastic change -- the concept of CollectionHub and Collections has tentacles throughout the website, guides, documentation, videos and blogs.

## User stories

- As the Kabanero community, we would like to simplify the messaging of Kabanero by removing the concept of CollectionHub and Collections.

- As Champ (architect), I would like the definition, selection and build of Appsody stacks that are "blessed" untangled from the configuration of a specific Kabanero instance, moving from the Collection-Hub concept to a strictly Kubernetes-natural Kabanero and Stack CRD gitops user experience.

## As-is

- To introduce Kabanero topics, one must teach the student the concept of stacks, stack-hubs, pipelines, application development.  After all of that, then one must teach the student about collections and collection hubs, with a collection being a stack and a collection hub being a stack hub.  

- To customize a stack, champ uses the appsody tools to copy the stack, and then has to manually convert it into a collection and include it in a collection hub.

- To customize one character of a pipeline, I need to do a complete collection hub rebuild, which depending on how developer's are consuming collection hub releases may cause them to need to update all of their configuration -- for a change doesn't directly.

## To-be
-  Champ's (architect's) lifecycle changes to build stacks, using Appsody stackhub builds and independently building pipeline releases.
-  Champ's experience is Kubernetes and operator-centric.  The configuration for Kabanero is defined solely by Kubernetes resources: `Kind:Kabanero` and `Kind:Stack`.
-  Kabanero concepts are simplified to using stacks and their configuration.

## Main Feature design

### Custom Resource Changes

#### Kind:Kabanero

The Kabanero CRD will change to specifiy a Stack hub URL instead of a Collection Hub URL.  Previously, the Kabanero CRD did not concern itself with the relationship of pipelines with stacks.  The Kabanero CRD is enhanced to provide a default pipelines URL. 

#### Kind:Stack

The existing schema of the Collections CRD will be copied, with the `Kind:` field changing to `Stack`.  All other fields are relevant with one expection.  The status field `collections.url` field is being removed.  (Rationale below.)

### Operator Managed Stacks vs. Manually Managed Stacks

The Kabanero operator automatically manages stack configuration, pipeline configuration, etc. for those stacks that are discovered and configured in the Kabanero CR.   

At times, it is desireable to manually instantiate a Stack CR, or override specific values (e.g. like pipelines) for a specific version of a specific stack-id.  An independent Stack CR can be applied to the configured Kabanero namespace, causing the specific pipelines to be installed and the Stacks to be activated.

The stacks.URL field of the Kabanero CR is optional -- in this case, it indicates that the customer would like to manually manage all Stacks.

The collections.url field in the Stacks CRD is no longer needed, and in the manual `stack` CR pattern above makes no sense, since the operator (or Git provided source) for the `stack` CR has provided all of the instance variables, i.e. the Stack was not derived from an `index.yaml` stack-hub.


## Day 2 Operations

### Kabanero Upgrade Scenarios

Prior to doing any upgrade, the Kabanero user will need to determine if they have any manual steps to perform prior to doing the upgrade.  Manual steps may be required.

The Kabanero operator, when upgraded to 0.6.0, will discover any configured a Kabanero CR that contains "collections" configuration and convert the CR configuration to specify "stacks".  

-_Remember:_  we can take advantage of the fact that a Collection Hub ISA Stack Hub, so transitioning the configuration from Collections to Stacks will in fact be compatible.

Since the new Kabanero CR will require a default pipeline specification, and an existing Kabanero Collection Hub contains a set of pipelines named default, the default pipelines will be added to the Kabanero CR.

After processing the Kabanero CR, the operator will query for all Collection documents and transform them into Stack CRs.  The URL in the Collection Hub from which this collection was activated, will be transformed to point at the Stack Hub from which this Stack was activated.

#### Kabanero 0.5.0 to 0.6.0

Prior to upgrading, if there are any custom pipelines specified for a specific stack, we manage the CR override in the Stack CR  -- i.e. you'll do an `oc apply my-custom-stack.yaml` which provides overrides the automatic configuration.

After you've planned for any custom pipelines, the Kabanero operator upgrade will produce a valid configuration.

#### (Kabanero 0.3.0-0.4.0) to 0.6.0

In addition to the steps for upgrading from 0.5.0, you also have a manditory update related to the introduction of Tekton triggers in the 0.5.0 release of Kabanero.  

You can either add the required Tekton Trigger and Bindings configuration to your existing CollectionHub before you upgrade, or one can move directly to a StackHub with separate pipeline release.

Please note that this transition will also require that any  Github webhooks that were previously established with the Tekton dashboard will need to be reestablished.


#### (Kabanero updates from 0.1.n-0.2.n)

No support for directly upgrading from these releases.


##  Dependent Projects

### Appsody

This design will ask the Appsody open source community to extract some additional metadata during StackHub build (that was previously captured in the Kabanero Collection Hub build), which exposes the configured registry and org names in the `index.yaml.`

Although not required for this design change in Kabanero, the enterprise governance lifecycle would improve greatly for both Appsody and Kabanero from an improvement in StackHub defintion allowing by-reference stack specification when constructing builds. 

## Kabanero Collections

This repository will live on to provide service for previous levels of Kabanero for a period of time.

A new `0.5.n` release of the Collection Hub will be produced to preserve the UBI stack variants until they can find a home elsewhere, and to update them with current maintainence.  

## Kabanero Operator

Most of this specification applies to the Kabanero operator, but specifically:

- **kabanero.yaml**  
  - The default Kabanero CR will point at the Appsody Stackhub by default, configuring the default pipelines `0.6.0` release.
  Changing the default Kabanero CR to point at an Appsody stack-hub release, the containers that are installed by Kabanero by example will be the Ubuntu variants.  
  - A new example of the Kabanero CR will be added that will point at the new `0.5.n` collection hub for those consumers that wish to continue to use the UBI variants of the stacks.


## Kabanero Pipelines

Today the pipelines that are included in the Collection Hub are cut-and-pasted into the kabanero/collections repository.  With the elimination of the Collection Hub and Collections, the Kabanero CR will be configured with pipelines, and we need to release them independently.

Since the pipelines can contain samples, we should isolate them from the pipelines we want to have as best practices.

Until Kabanero eventing is rationalized and generally available, Kabanero pipeline step ensures that relevant pipelines (e.g. build) are operating against Collections are active.   This logic interacts with the Collections CRs and will need to change to interact with the Stack CRs.

## Kabanero CLI and REST APIs

The Kabanero CLI has methods for interacting with collections and collection hub.  

- **kabanero deactivate** - Remove the specified collection from the list of available application types, without deleting it from the Kabanero instance.
  -  Activation and deactivation are changed to interact with stacks.  
- **kabanero list** - List all the collections in the kabanero instance, and their status
  -  List returns the list of stacks and their status.
- **kabanero login** - Will authenticate you to a Kabanero instance
- **kabanero logout** - Disconnect from Kabanero instance
- **kabanero onboard** - Command to onboard a developer to the Kabanero infrastructure
- **kabanero sync** - sync the collections list
  -  Sync is a behavior that is intended to help with the development of Stacks, Pipelines and validating Kabanero Governance.  After manipulating the configuration manually, Champ will want to restore the the configuration to the state defined in the Kabanero CR
  -  The Kabanero operator only reacts to state changes in the Kabanero CR.  If the Kabanero operator is pointed at a dynamic URL location (e.g. _latest_), the sync CLI can be used to force the changes to be enacted.
- **kabanero version** - Show Kabanero CLI version

The Kabanero REST APIs will be changed to support the CLI interactions above.

The Kabanero CLI will not be backwards compatible.

## Kabanero Guides

The following guides are effected by the change to collections.

- https://kabanero.io/guides/use-appsody-cli.  Remove changes for Appsody CLI --  it is fine for the Appsody CLI to point at the default Appsody link.

The section called "Collections" needs to change.  The following guides need to change to reflect using these "Stacks" with Kabanero.  

- https://kabanero.io/guides/collection-nodejs
- https://kabanero.io/guides/collection-nodejs-loopback/
- https://kabanero.io/guides/collection-nodejs-express/
- https://kabanero.io/guides/guide-codewind
- https://kabanero.io/guides/microprofile-eclipse-codewind 
- https://kabanero.io/guides/collection-microprofile 
- https://kabanero.io/guides/collection-springboot2/ 

- https://kabanero.io/guides/jenkins-integration-with-kabanero/

- https://kabanero.io/guides/working-with-collections/
  -  This guide will likely need re-enginnering, since the focus is on working with collections, when we want to show the same scenario, but with the simplified focus on stack hubs.


## Kabanero Documentation

The main [architectural-overview](https://kabanero.io/docs/ref/general/overview/architecture-overview.html) needs revisions to simplify the concepts.

These artcles are also effected:
- https://kabanero.io/docs/ref/general/installation/installing-kabanero-foundation.html
- https://kabanero.io/docs/ref/general/configuration/kabanero-cr-config.html 
- https://kabanero.io/docs/ref/general/configuration/collection-install.html
- https://kabanero.io/docs/ref/general/configuration/github-authorization.html 
- https://kabanero.io/docs/ref/general/reference/kabanero-cli.html 

- https://kabanero.io/docs/ref/general/reference/kabanero-env-vars.html 
  - This page describes how collection hubs are built -- this will now defer to stack hubs are built.  We should look to point at the Appsody process where possible.

## kabanero.io

The material which describes concepts needs to be refactored to consider new Champ lifecycle experience.  Instead of building a Collection Hub, Champ:

- Currates each customized stack.
- Builds a stack-hub for usage with his team and for configuration of Kabanero instances.
- Currates specific pipelines.
- Builds a repository of pipeline artifacts: pipelines, tasks, triggers and bindings.
- Authors the desired Kabanero and Stack CRs, which leverage the stack-hub and pipelines above.
- Activates that configuration using the Kabanero operator.

## Kabanero Eventing Prototype

The Kabanero CollectionHub holds a configuration for the triggers.  The current trigger configuration is one per Kabanero instance.  The Kabanero CRD is enhanced to provide a trigger URL.

The Kabanero eventing prototype does Collection activation governance and will have similar changes as the pipeline validation.

#  - Other Considerations:  

The stewardship of the UBI variants of the Appsody stacks is not declared by this spec.  While we believe the current UBI variants are valuable, the Kabanero community will move away from stack development and stack providers and vendors will provide their stewardship, implementation design and maintainence.

In the future, Kabanero:
  - _*may*_ deliver a unique stack hub index.yaml as needed.
  - take advantage of leveraging Appsody features which makes it easier to create an `index.yaml` for single stack and versions, as well as mallowing the `index.yaml` files to be built by reference.

#  - Discussion:  

- Since we have both the Kabanero and Appsody operators in the target cluster, do we think that naming the Stack CR `kind:Stack` cause any usage concept issues between Kabanero and Appsody?  Does this drive us to want to name the Stack kind something subtly different.

- With the change from collections to stacks, many of the guides were around using the various micro-service stack "kinds".  It seems like this might be better suited at the Appsody community, provided by the stack providers.   The guides we have today really just show how to use the UBI stack versions of each of the collections.   We might be better served by having one guide which shows how Jane configures here Appsody CLI to point at the right stack-hub.