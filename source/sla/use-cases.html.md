---
title: use-cases
category: sla
authors: doron
wiki_category: SLA
wiki_title: Sla/use-cases
wiki_revision_count: 1
wiki_last_updated: 2012-12-04
---

# use-cases

## Common scenarios for SLA in oVirt

### Private-cloud / multi-tenancy models

*   Limitations / Capping (CPU, RAM, TBD...)
    -   Allow limiting a VM's resource consumption
    -   Provide better control on VM behavior and prevent a VM from going wild.

<!-- -->

*   Quota
    -   Management level limitations

### VM High Availability

*   Host level
    -   Tagged hosts should be used when scheduling HA-VMs.

<!-- -->

*   VM level
    -   allow auto-reset when guest fails (blue screen, etc.)

<!-- -->

*   Application level
    -   monitor specific application(s) and act accordingly (reset, migrate, etc) when it stops responding

### HW utilization

*   Memory Over Commitment
    -   Allow running more VMs than available physical memory

### Power saving

*   Shutdown idle VMs
*   Gather all VMs to several hosts (load balancing, already exists) and shut down / suspend unused hosts.

### Advanced VM scheduling

*   Time based: turn on/off at a given time
*   Various algorithms implementations
*   Statistic-based scheduling

<Category:SLA>
