---
title: Disaster Recovery Solutions
---

# Chapter 1: Disaster Recovery Solutions

oVirt supports two types of disaster recovery solutions to ensure that environments can recover when a site outage occurs. Both solutions support two sites, and both require replicated storage.

**Active-Active Disaster Recovery**:

This solution is implemented using a stretch cluster configuration. This means that there is a single oVirt environment with a cluster that contains hosts capable of running the required virtual machines in the primary and secondary site. Virtual machines automatically migrate to hosts in the secondary site if an outage occurs. However, the environment must meet latency and networking requirements. See "Active-Active Overview" in Chapter 2 for more information.

**Active-Passive Disaster Recovery**:

Also referred to as site-to-site failover, this disaster recovery solution is implemented by configuring two separate oVirt environments: the active primary environment, and the passive secondary (backup) environment. Failover and failback between sites must be manually executed, and is managed by Ansible. See "Active-Passive Overview" in Chapter 3 for more information.

**Next:** [Chapter 2: Active-Active Disaster Recovery](active_active_overview)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/disaster_recovery_guide/disaster_recovery_solutions)
