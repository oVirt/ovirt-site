---
title: MoM
category: project
authors:
  - aglitke
  - doron
  - lhornyak
---

# MoM

MOM is a policy-driven tool that can be used to manage overcommitment on KVM hosts. Using either libvirt or vdsm, MOM keeps track of active virtual machines on a host. At a regular collection interval, data is gathered about the host and guests. Data can come from multiple sources (eg. the /proc interface, vdsm API calls, libvirt API calls, a client program connected to a guest, etc). Once collected, the data is organized for use by the policy evaluation engine. When started, MOM accepts a user-supplied overcommitment policy. This policy is regularly evaluated using the latest collected data. In response to certain conditions, the policy may trigger reconfiguration of the system’s overcommitment mechanisms. Currently MOM supports control of memory ballooning and KSM but the architecture is designed to accommodate new mechanisms such as cgroups.

## Name

Mom -- Memory Overcommitment Manager

## Important MoM wiki pages

*   How Mom is being used to implement SLA features in oVirt
*   Mom project [Integration](/develop/release-management/features/sla/sla-mom.html)
*   [Integrated Mom work cycle](/develop/release-management/features/sla/momintegration.html)
*   [MoM policy explained](/develop/sla/host-mom-policy.html)
*   [Ballooning feature design](/develop/sla/memory-balloon.html) and [MoM ballooning tech preview](/develop/release-management/features/sla/sla-mom-ballooning-tp.html)

## External Links

*   There is some [old documentation](https://github.com/aglitke/mom/wiki) that needs to be updated and migrated to this wiki.
*   A [presentation](https://www.linux-kvm.org/images/e/e8/2010-forum-litke-kvmforum2010.pdf) on overcommitment policy.
*   A [paper](http://www.ibm.com/developerworks/library/l-overcommit-kvm-resources/) on the same topic.

## Additional project information

Our git repository sits on oVirt's Gerrit server. Development takes place on mostly in vdsm mailing lists: vdsm-patches for submitting new patches, and vdsm-devel for general discussions on where Vdsm development should go. On the latter one, users and potential users should feel comfortable to seek help, ask questions, and get answers about Vdsm.

## IRC

There is [#ovirt](/community/about/contact.html) on oftc.

