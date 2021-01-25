---
title: TestingFramework
authors: dkuznets, ybronhei
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

![](/images/wiki/TestingEnv.png)

#### Creating Environment Flow

      * Create templates (kick start) for each VM
      * Build RPMs
      * Setup resources
      * Provision repositories
      * Engine deploy
      * Jenkins run noise tests based on engine's python sdk

##### First phase

In the first phase we wish to automate the bring-up of all system resources (networks/VMs).
The network is defined by a name and a prefix, for the sake of simplicity, there is only one network at the moment.
The virtual machines are defined by the following format:

    domains = {'engine': {'ip': '192.168.111.2',
                          'net': NETWORK_NAME,
                          'disks': [('vda', 'root', 'template')],
                          'script': './setup_engine.sh'},
               'storage_iscsi': {'ip': '192.168.111.3',
                                 'net': NETWORK_NAME,
                                 'disks': [('vda', 'root', 'template'),
                                           ('vdb', 'extra1', 'empty', '30G')],
                                 'script': './setup_storage_iscsi.sh'},
              ...

With these definitions, we can both create the images/network/virt domains and clean up the machine that runs them, (so we can run the set-up) again in the future. Once the setup is done, we can begin using the engine through the REST api and run tests.

##### Second phase

##### Third phase

## Benefit to oVirt

      * Upstream contribution for system testings.
      * Easy cleanup and setup for new testing environment.

## Steps To setup Testing Environment

## Documentation / External References

## Known issues for followup

