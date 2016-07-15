---
title: SLA-mom
category: feature
authors: aglitke, doron
wiki_category: Feature
wiki_title: SLA-mom
wiki_revision_count: 2
wiki_last_updated: 2012-10-23
---

# SLA-mom

## SLA: MoM integration

### Summary

Introducing MoM, maintained by Adam Litke <agl@us.ibm.com>, as a part of oVirt, via integration with VDSM.

### Owner

*   Name: [ Adam Litke](User:Aglitke)
*   Name: [ Doron Fediuck](User:Doron)

<!-- -->

*   Email: <agl@us.ibm.com>
*   Email: <dfediuck@redhat.com>

### Current status

*   Last updated date: TBD

### Detailed Description

*   Original proposal: <http://wiki.ovirt.org/wiki/Project_Proposal_-_MOM>
*   Policy handling: <http://wiki.ovirt.org/wiki/Sla/host-mom-policy>

<!-- -->

*   Integration steps:

      - Complete code integration in VDSM
      - MOM packages (nightlies and releases) need to be built by Jenkins
      - VDSM RPM should require MOM rpm
      - ksmtuned should be disabled on hosts because it conflicts with mom ksm tuning

### Benefit to oVirt

This is the foundation of SLA @oVirt, allowing enforcement of various aspects such as limitations and reservations in host level.

### Dependencies / Related Features

*   [SLA-mom-ballooning-tp](SLA-mom-ballooning-tp)

### Documentation / External references

*   TBD

### Comments and Discussion

*   Refer to <Talk:SLA-mom>

