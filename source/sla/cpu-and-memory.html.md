---
title: cpu-and-memory
category: sla
authors: doron, lvroyce
wiki_category: SLA
wiki_title: Sla/cpu-and-memory
wiki_revision_count: 10
wiki_last_updated: 2012-09-06
---

# cpu-and-memory

ovirt flow: Use case1:

       Assign Resource proportion(e.g.a customer buy 20%CPU)
       1.find a VM
       2.limited the CPU consumption to be 30% host CPU

Use case2:

       Cluster Policy based Cgroup control
       1.Config a cluster's policy is to be: best utilization/best performance/best balance
       2.Engine config MOM to be different policy:None/medium/aggressive about all resources

Use case3:

       Resource tendency:
       1.Config a VM to be:compute node/ftp server/mail server/http server/general...
         Will have different resource tendency
       2.Engine will translate some resource(mem/cpu/io/bandwith) as rigid level of every vm
       e.g.:VM1(mem:strong/cpu:medium/bandwith:weak),VM2(mem:medium/cpu:weak/bandwith:strong)
       3.Engine config Mom of these policy of different resources
       4.Mom will tune VMs according to the policy

Use case 4:

       User discrimination
       1.Config VM to have different credit on engine
       2.Engine config MOM
       3.restrain resource according to different credit
       e.g.:Gold VM restrain 10% CPU resource, Silver VM restrain 20% CPU resource

## Relevant oVirt Projects

*   oVirt engine

<!-- -->

*   VDSM

<!-- -->

*   MoM

## CPU

       Based on libvirt cgroups
       libvirt API:int    virDomainSetSchedulerParameters    (virDomainPtr domain,
                          virTypedParameterPtr params,
                          int nparams)
       params to use:

shares:The optional shares element specifies the proportional weighted share for the domain.

period:The optional period element specifies the enforcement interval(unit: microseconds). Within period, each vcpu of the domain will not be allowed to consume more than quota worth of runtime.

quota:The optional quota element specifies the maximum allowed bandwidth(unit: microseconds). A domain with quota as any negative value indicates that the domain has infinite bandwidth, which means that it is not bandwidth controlled.

*   Max

      Quota+period:
      (1)fix period, dynamic quota:vdsm/engine not care about period, set it to longest to limit cgroup control cost, mainly pay attention to share.
      (2)dynamic quota and period:Mom would control both to determin which is better

*   prioritization:

      Share:VM with bigger share value will gain priority to run

## Memory

*   Guarenteed

<!-- -->

*   Hard Limits

<!-- -->

*   Soft Limits

<Category:SLA>
