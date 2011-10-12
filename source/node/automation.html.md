---
title: Node Automation
category: node
authors: fabiand, mburns, misc, pmyers, quaid
wiki_category: Testing
wiki_title: Node Automation
wiki_revision_count: 6
wiki_last_updated: 2014-05-22
---

# Node Automation

## Automation Plan for oVirt Node

This outlines a plan for automating the building and testing of oVirt Node ISO images.

We want to build from both a development repo and the master repo on all current versions of Fedora. This includes the current production version, the development version and rawhide (F15, F16, and rawhide currently)

#### Tools currently used

1.  [AutoBuild](http://AutoBuild.org/)
2.  [Autotest](http://autotest.kernel.org/)
3.  [Cobbler](https://fedorahosted.org/cobbler/)

### Goals

#### Primary Goals

*   Generate new builds on each commit and/or on a recurring schedule
*   Perform sanity checks on these builds immediately and automatically
*   Clean, easy to read reports of success and failure

#### Secondary Goals

*   Builds available to the community
*   Single location for all builds

### Current Status

*   AutoBuilds currently happen on a recurring schedule, no git repository integration
*   Some test scripts using autotest that don’t run continuously exist, but not posted publicly anywhere
*   AutoBuilds are currently somewhat unstable with random errors

#### Current build process

We have some infrastructure built up around AutoBuild to make it easier to cover multiple different builds and to keep configuration in a central place. I will provide details on what is there and how it works, but a brief summary should suffice for this plan

*   A git repository containing (among other things):
    -   AutoBuild configuration files
    -   rpmmacros files
    -   control scripts
*   A main driver script that does the setup for the AutoBuild environment (user creation, directory, etc), and the build itself
*   Individual scripts for each build that call the main driver with the appropriate options

Currently, the individual scripts are set to run on a recurring basis using cron jobs. They each run as a separate users and only a single instance of each build can run at a time.

#### Current test process

Tests are primarily done manually. The small set of tests that are automated have proven somewhat unreliable and unstable. They are setup to use Autotest

### Current Problems that need solving

#### Building

The main problem is the instability of the builds. We have a dedicated VM for running builds, but we keep running into various problems that occur seemingly randomly, though with increasing frequency. They primarily seem to be centered around livecd-creator. Part of the problem may be because the VM is being overtaxed. Another part may be because we can end up with multiple livecd-creator operations running concurrently. A third possibility is that the underlying hosts are heavily utilized at the moment.

#### Testing

*   Quite simply: We need automation that runs consistently and automatically. It needs to be stable as well.
*   Manual testing is better than no testing, but it doesn’t happen on a consistent basis at the moment. It also doesn’t alert us to problems when they occur.

### Proposed Process

Here is the direction that I’m envisioning going for the automated process

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

We’d like to continue using Autotest for automated testing. It was designed to automate kernel testing, which is somewhat similar to what we need to do.

##### Architecture

*   Standard autotest architecture – an autotest server and multiple slave machines
*   We might have to have a subset of machines that are specific for oVirt Node testing

##### Process

*   After build is complete, the autobuild infrastructure will submit a job to autotest
*   the job will configure cobbler profiles correctly for test process
*   autotest will trigger installation and testing of the oVirt Node ISO
*   results link is returned to the build controller

##### Code

*   The code for the tests should live in the oVirt Node repository. The current test code is outside of the git repository, but we should move it inside.

### Getting There

These are some of the high level steps that need to be taken to get to our final goal

#### Planning

*   What are the right tools to use? Is AutoBuild/Autotest the right choice to make?
*   What tools will be available on ovirt.org that we can make use of?

#### Building

1.  Need cobbler profiles for building autobuild hosts from scratch (install right packages, do necessary config, etc)
2.  Need ability to dynamically spin up virtual machines or hosts to do builds
    1.  this could be as simple as having a set of hosts listed and having the ability to trigger in cobbler, but in the case of multiple vms, it might be slightly more involved. I was tentatively picturing using RHEV for this since I already have that available

3.  setup git hooks
4.  method for manual build triggers (probably need a way to dynamically configure the config file for a custom repo)
5.  method for triggering autotest runs (there is an ability to do this through autotest, but will need to be tested for use with autobuild
6.  Method for getting results back from autotest and linking into results of the autobuild or summary page
7.  Cohesive overall summary of all builds

#### Testing

1.  some sort of plugin architecture setup with autotest so that we can dynamically add our tests on the fly
2.  dynamic creation of appropriate profiles in cobbler
3.  test scripts
4.  coordination between autobuild and autotest around test versions (theoretical)
    1.  do we have different tests in master branch vs development branch?
    2.  do we have separate repos for specific fedora versions? (I think mostly no, but might be necessary if we need something specific in a new version of fedora. Maybe something like the recent SysV to systemd change or the change to dracut from mayflower).

5.  PXE boot command line issues
    1.  There is a character limit currently that we will need to solve to get exhaustive testing

6.  UI testing using kvm-autotest step-engine – some work done here, but UI was too unstable to be tested consistently using step-engine.

### Updates

There are plans to include [jenkins](http://jenkins-ci.org) in ovirt.org, so I've been spending the last few days getting familiar with it and seeing if it's an option for what we need.

*   Jenkins actually works pretty well for building. AutoBuild uses primarily shell scripts for building, so translation is fairly straightforward.
*   Jenkins add the same master/slave approach that I was looking for and all results are collated in one place. At least some of the automated testing that we'd like to do should be possible through Jenkins.
*   Given that Jenkins is going to be included anyway in ovirt.org, it probably makes a lot of sense to use it.

<Category:Testing> <Category:Automation> [Category:Node development](Category:Node development) [Category:Node release engineering](Category:Node release engineering)
