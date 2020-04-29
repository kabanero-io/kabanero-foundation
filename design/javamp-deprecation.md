# Java Microprofile Application Stack Deprecation

## Key Concepts / Background
- Kabanero hasn't had any guidelines for deprecating an application stack, so this design will describe a best practice for deprecation.

- The Java Microprofile community has refactored the Java cloud native  application stack to provide many improvements -- delivered as a new stack: the Open Liberty application stack.  The Open Liberty application stack has already been featured in Kabanero.  New Java cloud native applications should now leverage the Java Open Liberty application stack.

- The Java Microprofile application stack maintained in Kabanero is derived from the similar stack at Appsody.  Kabanero will inherit the stack metadata which marks the stack deprecated, as well as the container changes which will print deprecated messages as part of the application start up.  This is a best practice.  The deprecation marker and start up messages indicates to any user of the stack that they should start making plans to change technologies.

- The Java Microprofile application stack will continue to be maintained for period of time as determined by the stack provider.  A minimum of 3 milestones is considered a best practice, although some stack providers may choose a different transitional period.

- The default Kabanero stack-hub index will be updated to remove the Java Microprofile application stack.  Users wishing to continue to leverage the Java Microprofile application stack can add the stack index to their own customized stack-hub for usage with Kabanero.

## User stories

- The Kabanero community would like to have a process for deprecating  application stacks.

- The Java Microprofile application stack provider would like to deprecate the Java Microprofile application stack.

- As a Java-Microprofile application stack consumer, I would like to have a transition period where I can refactor my application to leverage the Open Liberty applciation stack.

## As-is

- The Kabanero stack-hub index release includes the Java MicroProfile application stack, which for this milestone will be deprecated.

- There are two Java cloud native application stacks delivered in Kabanero without clear enough guidance on which to leveage.

## To-be

- As the Kabanero Java MicroProfile stack provider, I would like to deprecate the existing Java MicroProfile application stack in preference to the Java Open Liberty Application Stack.

- The Kabanero stack-hub index release will exclude the now deprecated Java MicroProfile application stack.

- As a Java MicroProfile application stack consumer, I would like to be able continue to leverage the application stack for a period of time until I can transition my Java application to leverage the Open Liberty Stack.

- As the Kabanero community, I would like to remove guides exhibiting and documentation which indicates that the Java Microprofile should be used to build Java cloud native applications.

## Main Feature design

### Removal of Java MicroProfile application stack from the default stack hub release

The Kabanero stack-hub release will remove the Java MicroProfile application stack from the index.

### Custom Resource Changes

None.

### Kabanero Operator

None.

## Day 2 Operations

None.

### Kabanero Upgrade Scenarios

#### Kabanero 0.8 to 0.9

There are no configuration upgrade transformations due to this design known at this time.

#### (Kabanero 0.6 to 0.9

There are no configuration upgrade transformations due to this design known at this time.

#### (Kabanero updates from 0.1-0.5)

No support for directly upgrading from these releases.

##  Dependent Projects

### Appsody

This feature is dependent on deprecation changes made to to the Java MicroProfile stack which Kabanero inherits from the Appsody community. 

## Kabanero Stacks

### Java MicroProfile

The Java Micro Profile application stack metadata is updated to indicate that it is deprecated, and on application startup, the container issues messages that indicate the container is deprecated and should use the Java Open Liberty application stack going forward.

## Kabanero Pipelines

None.

## Kabanero CLI and REST APIs

None.

## Kabanero Guides

The Java Microprofile application stack guide(s) should be removed.  There are already Java Open Liberty application stack guides, so no new guide material should be necessary.

## Kabanero Documentation

Any documentation referring to the Java Microprofile application stack should be refactored to leverage the Java Open Liberty application stack for cloud native development.

## kabanero.io

Add content to `What's-new` blog and ensure that any Java Microprofile application stack material is refactored to leverage the Java Open Liberty application stack for cloud native development.

## Kabanero Eventing Prototype

None.

#  - Other Considerations:  

Products based on Kabanero, which need to continue to deliver the Kabanero Java MicroProfile application stack can find the stack definition in the kabanero-collection hub, and the Kabanero community will continue to publish updates to the Java MicroProfile application stack container to Docker hub for a period of time.

It is decided that for the time being, we would not enhance the Kabanero operator, REST API and CLI to indicate that a stack is marked deprecated.  The Appsody CLI indicates to the developer that the stack is deprecated, and presumably the enterprise would have a plan for removing the stack.

#  - Discussion:  



