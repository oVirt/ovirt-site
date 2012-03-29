---
title: AllInOne
category: feature
authors: acathrow, alourie, dneary, jbrooks, netbulae, oschreib, sandrobonazzola
wiki_category: Feature|All In One
wiki_title: Feature/AllInOne
wiki_revision_count: 25
wiki_last_updated: 2015-01-16
---

# All in One

### Summary

"All in One" means configuring VDSM on the same host where oVirt-engine is installed, so that VMs can be hosted on the same machine.

### Owner

*   Name: [ Alex Lourie ](User:Alourie)
*   Email: alourie@redhat.com

### Current status

*   Currently in code review.
*   Binaries available for testing at /net/file/home/tlv/alourie/ovirt-engine-test/Ticket647_allinone/

### Detailed Description

The goal of this plugin is to allow configuring VDSM on the same machine with the oVirt-engine for demonstration/development purposes.

The plugin works by providing parameters, group and sequences and adding them into the Controller object (the main object of the setup flow), which will invoke appropriate logic during the setup operation.

### Installation flow

*   Install ovirt-engine-setup-plugin-allinone rpm.
*   Start regular engine-setup procedure.
*   When asked "Configure VDSM on this host?", answer yes.
*   Provide answers to the presented questions.
*   After all answers are provided, the setup will install oVirt-engine and configure VDSM, including local cluster, local datacenter and local host.

### Comments and Discussion

*   Refer to [Talk: allinone](Talk: allinone)

<Category:Feature> <Category:Template>
