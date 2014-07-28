---
title: TestingFramework
authors: dkuznets, ybronhei
wiki_title: Features/TestingFramework
wiki_revision_count: 3
wiki_last_updated: 2014-08-07
---

# Testing Framework

## Summary

We aim to build upstream system testing framework for oVirt and its related components (VDSM, vdsm-tool, Host-Deploy, Hosted-Engine, Registration tool and so on).

When integrating oVirt components for new build we need to run full set of system flows which can assure us that all related logical flows won't get effected or changed due to regression or new behavior. This related to storage, network and virt flows all over the project.

## Owners

*   Yaniv Bronheim <ybronhei@redhat.com>
*   Dima Kuznetsov <dkuznets@redhat.com>
*   Saggi Mizrahi <smizrahi@redhat.com>

## Current Status

*   Design infrastructure.

## Detailed Description - Prerequisites

One RHEL7 hypervisor will provide the full environment infrastructure for testing. The host will run at least 5 separate virtual machines. 1 serves for engine setup, 2 serves as hyperivors (VDSM installation) and 2 serves as storage providers (nfs and iscsi). All Vms will work with same internal NAT for communication.
Before each run the setup will be initialized from scratch.

![](testingEnv.png "testingEnv.png")

#### Creating Environment Flow

      * Create templates (kick start) for each VM
      * Build RPMs
      * Setup resources
      * Provision repositories
      * Engine deploy
      * Jenkins run noise tests based on engine's python sdk

##### First phase

##### Second phase

##### Third phase

## Benefit to oVirt

      * Upstream contribution for system testings.
      * Easy cleanup and setup for new testing environment.

## Steps To setup Testing Environment

## Documentation / External References

## Known issues for followup

## Comments and Discussion
