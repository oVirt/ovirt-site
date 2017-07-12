---
title: Node Automation
category: node
authors: fabiand, mburns, misc, pmyers, quaid
---

# Node Automation

## Automation Plan for oVirt Node

This outlines a plan for automating the building and testing of oVirt Node ISO images.

We want to build from both a development repo and the master repo on all current versions of Fedora. This includes the current production version, the development version and rawhide (F15, F16, and rawhide currently)

#### Tools currently used

1.  [Jenkins](https://jenkins.ovirt.org) for build and test automation
2.  [Igor](https://github.com/fabiand/igor/) to run testsuites
3.  [Cobbler](https://www.cobblerd.org/) to provision VMs for testing

### Goals

#### Primary Goals

*   Generate new builds on each commit and/or on a recurring schedule
*   Perform sanity checks on these builds immediately and automatically
*   Clean, easy to read reports of success and failure

#### Secondary Goals

*   Builds available to the community
*   Single location for all builds

### Current Status

*   A build is triggered for each commit pushed to the ovirt-node [gerrit](http://gerrit.ovirt.org) project

#### Current build process

We have some [Jenkins jobs](http://jenkins.ovirt.org/view/ovirt_node/) which cover different builds and to keep configuration in a central place. The resulting packages and ISOs are publicly available and informations about the build status is send to the node-patches@ovirt.org mailinglist.

#### Current test process

Tests are currently automatically scheduled for each merged commit the results are posted to node-patches@ovirt.org.

### Current Problems that need solving

#### Building

TBD

#### Testing

The tests are currently run on RedHat internal infrastructure because there was no hardware available within the oVirt project which is capable of running these tests. This could change in the near future.

### Process Defintion

Here is a description of how the automation should work:

#### Building

##### Architecture

*   A single machine (virtual or not) that acts as a central repository and controller for the system
*   Controller has access to a set of machines
*   Controller spins up/provisions VMs as needed for builds
*   One build per VM

##### Process

*   Build can be triggered 3 ways
    -   git hook on commit/push triggers a build
    -   scheduled job gets triggered at a predetermined time
    -   User requests manual build
*   When triggered, the Controller will spin up a VM and provision it correctly
*   Controller will queue jobs if it doesn’t have VMs available
*   Controller will watch for builds that exceed some time limit and kill them
*   When build is complete, the build VM will sync the results directory back to the controller and shut down
*   Controller will sync build results to the cobbler server

#### Testing

We’d like to continue using Igor for automated testing. It was designed to automate oVirt Node and integrate well with Jenkins.

##### Architecture

*   An igord server and a libvirt host for spawning VMs
*   We might have to have a subset of machines that are specific for oVirt Node testing

##### Process

*   After build is complete, the jenkins infrastructure will submit a job to igor
*   Igor will configure cobbler profiles correctly for test process
*   Igor will trigger installation and testing of the oVirt Node ISO
*   Igor returns the results to the build controller (Jenkins)
*   Jenkins publishes the results on the ML

##### Code

*   The code for the tests should live in the oVirt Node repository. The current test code is outside of the git repository, but we should move it inside.

