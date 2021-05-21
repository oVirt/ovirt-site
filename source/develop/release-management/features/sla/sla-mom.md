---
title: SLA-mom
category: feature
authors:
  - aglitke
  - doron
---

# SLA-mom

## SLA: MoM integration

### Summary

Introducing MoM, maintained by Adam Litke <alitke@redhat.com>, as a part of oVirt, via integration with VDSM.

### Owner

*   Name: Adam Litke (Aglitke)
*   Email: <alitke@redhat.com>

<!-- -->

*   Name: Doron Fediuck (Doron)
*   Email: <dfediuck@redhat.com>

### Current status

*   Last updated date: TBD

### Detailed Description

*   Original proposal: [Project Proposal - MOM](/develop/projects/mom.html)
*   Policy handling: [Sla/host-mom-policy](/develop/sla/host-mom-policy.html)

<!-- -->

*   Integration steps:

      - Complete code integration in VDSM
      - MOM packages (nightlies and releases) need to be built by Jenkins
      - VDSM RPM should require MOM rpm
      - ksmtuned should be disabled on hosts because it conflicts with mom ksm tuning

### Benefit to oVirt

This is the foundation of SLA @oVirt, allowing enforcement of various aspects such as limitations and reservations in host level.

### Dependencies / Related Features

*   [SLA-mom-ballooning-tp](/develop/release-management/features/sla/sla-mom-ballooning-tp.html)

### Documentation / External references

*   TBD



