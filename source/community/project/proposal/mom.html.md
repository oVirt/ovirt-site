---
title: Project Proposal - MOM
category: project-proposal
authors: aglitke, ichristo
wiki_category: Project proposal
wiki_title: Project Proposal - MOM
wiki_revision_count: 7
wiki_last_updated: 2011-10-24
---

# Project Proposal - MOM

## Summary

MOM is a policy-engine that can dynamically apply a selected policy to a KVM host and its guests in response to a continuously changing environment.

## Owner and Initial Maintainers

Adam Litke <agl@us.ibm.com>

## Current Status

*   This project is in [incubation](http://www.ovirt.org/governance/adding-a-subproject/).
*   Last updated: Oct 10 2011

MOM currently exists as an independent open source project hosted on [github](http://github.com/aglitke/mom). This wiki page will gather input on whether MOM should become an oVirt sub-project and (if so) how best to integrate it into the oVirt stack.

## oVirt Infrastructure

*   Bugzilla
*   Mailing list: devel

## Detailed Description

MOM runs on KVM hosts and will be integrated with vdsm to provide dynamic node optimization to oVirt. Today, MOM has the ability to manage memory ballooning and the Kernel Same-page Merging (KSM) feature of the Linux kernel. The default policy makes decision based on memory statistics that are collected from the host and guests. The MOM architecture allows for easy extension of the program to control new tunable systems (eg. cgroups, numa, block IO throttling, network bandwith limits, guest evacuation, etc) and collect new data to support the policies that govern these new controls.

**High-level work items:**

*   Integrate MOM and vdsm: MOM functionality is available automatically to vdsm
*   MOM APIs for vdsm: vdsm can control MOM behavior as needed (change policy, etc)
*   Enable statistics collection via the oVirt agent.

MOM is a written in python and should probably be packaged independently. Once vdsm starts using MOM, its package dependencies can be updated to reflect this. As for actual integration, I see two strategies:

*   MOM runs the way it does today -- as an independent host level daemon. vdsm will control the MOM policy using MOM's existing xmlrpc interface.
*   Alter MOM so that it can be loaded as a python module. vdsm would load the module and call a method to have mom start its own threads.

## License

Licensed under the Apache License, Version 2.0 (Apache-2.0) <http://www.apache.org/licenses/LICENSE-2.0>

## Benefit to oVirt

MOM will benefit oVirt by providing transparent tuning and optimization of nodes to achieve improved performance, more efficient resource utilization, and adaptability to changing workloads.

## Scope

MOM will have the most affect on VDSM and the oVirt guest agent. MOM will be started by and work in concert with vdsm. It will gather guest statistics by using an API to the guest agent. A small change would be needed to oVirt-node to ensure that MOM is an included package. Eventually, engine-core (and its APIs) could be extended to control MOM at the cluster and data center levels.

## Test Plan

*Not yet specified.*

## User Experience

The only user-visible change that should be evident is improved performance and better resource overcommitment.

## Dependencies

*   libvirt
*   Statistics collection mechanism in oVirt guest agent

## Contingency Plan

Dynamic management is a widely recognized requirement for a complete virtualization solution. If MOM does not become the accepted solution, then oVirt will need to adopt another project or directly add missing features to existing components.

## Documentation

MOM is documented [in the source](http://github.com/aglitke/mom/) and [in a wiki](http://github.com/aglitke/mom/wiki). See also: [These slides from KVM Forum 2010](http://www.linux-kvm.org/wiki/images/e/e8/2010-forum-litke-kvmforum2010.pdf) and [this developerWorks article](http://www.ibm.com/developerworks/linux/library/l-overcommit-kvm-resources/index.html).

## Release Notes

*Not yet provided.*

## Comments and Discussion

[Category:Project proposal](Category:Project proposal) <Category:MOM>
