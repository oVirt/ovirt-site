---
title: Live migration for High Performance VMs
category: feature
authors: SharonG
feature_name: Live migration for High Performance VMs
feature_modules: engine
feature_status: Planning
---

# Live migration for High Performance VMs

## Summary
In oVirt 4.2 we added a new “High Performance” VM profile type. 
By choosing This High Performance (HP) VM type, the VM is pre-configured with a set of suggested and recommended configuration settings for reaching the best efficiency.
This required configuration settings includes pinning the VM to a host based on the host specific configuration. Due to that pinning settings, the migration option for the HP VM type was automatically forced to be disabled.

This feature provides the ability to enable the live migration for those HP VMs (and in general to all VM types with pinning settings).

## Owner
*   Name: Sharon Gratch (sgratch)
*   Email: <sgratch@redhat.com>

## Usage
 -  Setting a new or an existing VM to run as a HP VM, by selecting the "High Performance" type in the "Optimized for" pull down menu field displayed in VM new/edit dialog, will now automatically set the migration option to be enabled.
 
 - A HP Template or Pool will be created in the same way as a VM and the migration option will be auto enabled for those also. In case the user wants to create a HP migratable VM, he can also choose a Template or a Pool which are configured as HP type and "inherit" this property for that specific VM.

First phase solution:

 -  Only manual live migration will be supported and therefore the migration mode options that will be allowed are: “allow manual migration only” (default), “do not allow migration”.

 -  When the user will chose to migrate the HP VM, he will need to manually activate the migration and then via the “Migrate virtual machine(s)” popup dialog to choose the destination host to migrate to, or let the engine to auto select it for him.
 
    ![](../../../../images/wiki/Screenshot-2018-06-20-15-05-32.png)

 - The list of destination hosts to choose from in the “Migrate virtual machine(s)” dialog will be partially filtered by the scheduler policies to fit the HP VM required settings, so that it will include only hosts the have the configuration required for running this specific HP VM.

 -  There are few required host configuration settings that will not be checked by the scheduler in this first phase, so the user will need to make sure that the chosen  destination host has the same hardware and supports the exact same configuration as the source host and that the host is available to run this HP VM (considering its current existing load). 

 - In case the user will manually choose an inappropriate host or in case the automatically host selection will choose inappropriate one, the migration will fail.

Second phase solution:
      
 - Automatic live migration and fully automatic destination host selection will be supported for HP VMs as well as for all other VM types (Server, Desktop) with pinning settings.
 
 - The destination host will be chosen to fit the migrated VM and in case no such host existed in the cluster, the most suitable, less loaded and less pinned one will be chosen. Both source and destination hosts should not be necessarily identical.
 
 - In case the chosen destination host won’t fit all migrated VM requirements, the specific problematic configuration settings may be temporarily disabled so that this VM will be able to migrate to this host. For example: in case the destination host doesn’t support NUMA, then NUMA pinning setting will be removed for the VM. Once a more appropriate host (or the original one) will be available, the VM will be automatically or manually migrated back and the removed problematic configuration will be re-enabled. In our example: once a host that supports NUMA among all other requirements is available, the VM will be migrated to this host and the previous NUMA topology setting will be re-enabled.

## Detailed Description

### Migration constraints to handle
For supporting HP VMS migration, the following limitations should be removed from UI and backend:

   - A VM set with “Pass-Through Host CPU” enabled is not migratable.
   - A VM set with virtual NUMA nodes topology is not migratable (include handling “SupportNUMAMigration” flag in vdc_options).
   - A VM set with CPU pinning is not migratable (include handling “CpuPinMigrationEnabled” flag in vdc_options). 
   -  A VM set with hugepages is not migratable.
   - A VM set with IO+emulator threads pinning is not migratable.
   - A VM set with High-Availability enabled must be automatically migratable ( manual migration is not allowed because HA mode requires the ability to automatically migrate the VM). This should be handled mainly for first phase solution.
 
For Frontend code, those limitations will be removed only for HP VMs/Templates/Pools in first phase so that for Server/Desktop VM types it will still be a constraint for preventing migration.
We will totally remove those limitation in UI only in second phase solution.

For backend code, those limitations will be removed for all VM types.
    
### Scheduler requirements
The basic requirements from the scheduler manager for enabling HP VMs migration is to schedule a destination host that will support the HP VM’s requirements. That means that both source and destination hosts should have: suitable number of CPUs (sockets, cores, threads), suitable CPU pinning capacity, suitable declaration of hugepages and memory, suitable NUMA nodes topology and suitable host CPU model and hardware. 

The current existed scheduler policies relevant for this feature are the following:
CpuLevelFilterPolicyUnit, MemoryPolicyUnit, CPUPolicyUnit, CpuPinningPolicyUnit, PinToHostPolicyUnit, HugePagesFilterPolicyUnit.

Those should cover the basic requirements and maybe few changes will be added to support that. 

#### First phase solution:
Since the first phase solution will include manual migration only and the user is required to manually check that the chosen destination host fits and that destination host configuration is almost identical to the source host configuration, then those mentioned existed scheduler filters should be enough.

In case of a scheduler failure, since no destination host was found, the migration will fail.

#### Second phase solution
For supporting automatic migration all the checks will be done by the scheduler, including verifying that the destination host current existing load and pinning status fits the migrated HP VM’s.  We may add filter policies for checking that the source and destination hosts have a suitable (not necessarily identical) hardware and configuration supported. In case more than one host fits, we need to set the weights so that the most appropriate one,less loaded and less pinned host is chosen.

In case of failure, consider removing the pinning setting that caused the failure for allowing the VM to run on the destination host without it (and notify the user). 
The pinning may automatically re-enabled for that VM once it is migrated back to the original host or other host that supports it. This requires adding new filters to the scheduler and changing the live migration process.

### Live Migration process
No changes are required for first phase solution

### Affinity Groups/labels
Since HP VMs are limited by the hosts to run on and by the number of VMs to run together on the same host (due to enabling Pass-Through Host CPU, cpu pinning, numa pinning, io thread pinning, huge pages..etc) then it is required to apply affinity rules on those VMs. 

This can be done by adding flags to the affinity groups to mark some groups as internally managed or by giving users tools to do this manually over REST API /Ansible. 

### Assigned/pinned hosts
The HP VM is configured to run on a set of assigned/pinned hosts (by selecting the "Start running on: Specific Host" in "Host" side-tab). Each one of this hosts was verified by the user so that the VM configuration fits the host configuration.

In oVirt 4.2 only one host can be assigned in case of NUMA nodes pinning enabled (please see https://bugzilla.redhat.com/show_bug.cgi?id=1571371). This should be fixed by removing this constraint (frontend + backend), fix the scheduler manager and consider improving the "NUMA topology" dialog for dealing with few pinned hosts in case the NUMA settings of them is not identical.

From migration aspect, this is not a real problem since the scheduler manager filters hosts based on all  hosts in the cluster while ignoring the assigned hosts listed in "Start running on: Specific Host" field.

But from High Availability aspect, this is a problem since if the VM is pinned to only one host then the VM can be highly available only on that host. If the host is in maintenance/shutted down, the VM can’t run. 

### WebAdmin/UserPortal UI
- Change the migration mode default to be enabled
- Remove all migration constraints as described above.

### REST API
No changes are required for first phase solution
    
## Status

*   Target Release: Ovirt 4.3
*   Status: Planning

## Limitations

## Dependencies / Related Features
High Performance VM  (https://www.ovirt.org/develop/release-management/features/virt/high-performance-vm/)
