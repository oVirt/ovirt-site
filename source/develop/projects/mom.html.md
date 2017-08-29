---
title: MoM
category: project
authors: aglitke, doron, lhornyak
---

# Mo M

- MOM is a policy-driven tool that can be used to manage overcommitment on KVM hosts. Using either libvirt or vdsm, MOM keeps track of active virtual machines on a host. At a regular collection interval, data is gathered about the host and guests. Data can come from multiple sources (eg. the /proc interface, vdsm API calls, libvirt API calls, a client program connected to a guest, etc). Once collected, the data is organized for use by the policy evaluation engine. When started, MOM accepts a user-supplied overcommitment policy. This policy is regularly evaluated using the latest collected data. In response to certain conditions, the policy may trigger reconfiguration of the system’s overcommitment mechanisms. Currently MOM supports control of memory ballooning and KSM but the architecture is designed to accommodate new mechanisms such as cgroups.
- MOM是一种策略驱动的工具，可以用来管理KVM主机上的超量使用。使用libvirt或vdsm，MOM可以跟踪主机上的活动虚拟机。在一个常规的收集间隔中，收集关于主机和来宾的数据。数据可以来自多个来源(例如。/proc接口、vdsm API调用、libvirt API调用、与客户端连接的客户端程序等)。收集后，数据被组织为策略评估引擎使用。当开始时，MOM接受用户提供的超量使用策略。该策略经常使用最新收集的数据进行评估。在某些条件下，该策略可能触发系统的过度承诺机制的重新配置。目前，MOM支持对内存膨胀和KSM的控制，但是该体系结构的设计是为了适应新的机制，例如cgroups。

## Name

Mom -- Memory Overcommitment Manager  内存超量使用管理器

## Important MoM wiki pages

*   How Mom is being used to implement [:Category:SLA](:Category:SLA) features in oVirt
*   Mom project proposal [:Project_Proposal_-_MOM](:Project_Proposal_-_MOM) and Integration [:SLA-mom](:SLA-mom)
*   integrated Mom work cycle [:Architecture#MOM_integration](:Architecture#MOM_integration)
*   mom policy explained [:Sla/host-mom-policy](:Sla/host-mom-policy)
*   Ballooning feature design [:Features/Design/memory-balloon](:Features/Design/memory-balloon) and Mom ballooning tech preview [:SLA-mom-ballooning-tp](:SLA-mom-ballooning-tp)

## External Links

*   There is some [old documentation](https://github.com/aglitke/mom/wiki) that needs to be updated and migrated to this wiki.
*   A [presentation](http://www.linux-kvm.org/wiki/images/e/e8/2010-forum-litke-kvmforum2010.pdf) on overcommitment policy.
*   A [paper](http://www.ibm.com/developerworks/library/l-overcommit-kvm-resources/) on the same topic.

## Additional project information

Our git repository sits on oVirt's Gerrit server. Development takes place on mostly in vdsm mailing lists: vdsm-patches for submitting new patches, and vdsm-devel for general discussions on where Vdsm development should go. On the latter one, users and potential users should feel comfortable to seek help, ask questions, and get answers about Vdsm.

## IRC

There is [#ovirt](/community/about/contact/) on oftc.

## Requirements

         Under construction..... 

Caveats

         Under construction..... 
