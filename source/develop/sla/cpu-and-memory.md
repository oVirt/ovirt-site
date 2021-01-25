---
title: cpu-and-memory
category: sla
authors: doron, lvroyce
---

# cpu-and-memory

ovirt flow: Use case1:

       Assign Resource proportion(e.g.a customer buy 20%CPU)
       1.find a VM
       2.limited the CPU consumption to be 30% host CPU

Use case2:

       Cluster Policy based Cgroup control
       1.Config a cluster's policy is to be: best utilization/best performance/best balance
       2.Engine config MOM to be different policy:None/medium/aggressive about all resources

Use case3:

       Resource tendency:
       1.Config a VM to be:compute node/ftp server/mail server/http server/general...
         Will have different resource tendency
       2.Engine will translate some resource(mem/cpu/io/bandwith) as rigid level of every vm
       e.g.:VM1(mem:strong/cpu:medium/bandwith:weak),VM2(mem:medium/cpu:weak/bandwith:strong)
       3.Engine config Mom of these policy of different resources
       4.Mom will tune VMs according to the policy

Use case 4:

       User discrimination
       1.Config VM to have different credit on engine
       2.Engine config MOM
       3.restrain resource according to different credit
       e.g.:Gold VM restrain 10% CPU resource, Silver VM restrain 20% CPU resource

## Relevant oVirt Projects

*   oVirt engine

<!-- -->

*   VDSM

<!-- -->

*   MoM

## CPU

Stats vdsm needs to be collected:

       1.host cpu usage: flags of host cpu pressure and flag of tuning, when cpu utilization rise, action will be tune or migrate.via libvirt
       2.host perspective guest usage: guest use of host resource,  flag of how much has allocated actually via libvirt
       3.guest perspective guest usage: flag of how much potential the overcommitment can be

Controlls vdsm needs to perform:

       1.via cpu cgroup
       2.via pin cpu
       3.via hibernate/stop vm
       4.via numad

Policies:

       1.QOS: 
         (1)high prior guests demand should be satisefied
         (2)VM's feature demand should be satisefied(compute node's cpu demand has higher priority)
         e.g.:Golden Vm are assigned to a larger quota as original value,
          compute node are pinned to a specific cpu.

       2.Overcommit:
       When:
         (1)host cpu pressure rise,
         (2)import guest or cpu demanding guest demands cpu resource
        it tries to get cpu from:
         (1)non important guest
         (2)non cpu demanding guest
         (3)guest already got very high host usage but with comparatively low priority

Numad Integration

------------------------------------------------------------------------

vdsm API should perform: (1)Add domain processes to Numad and the Numactl (2)Remove cpu pin from vdsm

Should MOM control numad parameters? OR use default parameter for numad?

## Memory

int virDomainSetMemoryParameters (virDomainPtr domain,

                          virTypedParameterPtr params, 
                          int nparams, 
                          unsigned int flags)

*   Guarenteed
*   Hard Limits
*   Soft Limits

