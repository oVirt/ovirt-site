---
title: High Performance VM 
category: feature
authors: SharonG
feature_name: High Performance VM
feature_modules: engine
feature_status: Planning
---

# High Performance VM

## Summary

Support a new type of VM in oVirt destined for running a VM with highest possible performance and performance metrics as close to bare metal as possible. 

For setting a VM as High Performance, a new VM profile type named "High Performance" will be added in addition to existing "Server", "Desktop" types.  By choosing This new High Performance VM type,  the VM will be pre-configured with a set of suggested and recommended configuration settings for reaching the best efficiency.

## Owner
*   Name: Sharon Gratch (sgratch)
*   Email: <sgratch@redhat.com>

## Benefit to oVirt

Before this feature was implemented, configure a VM to run with high performance workloads was not an easy straightforward mission to do and required the user to manually set the VM as such by going over all settings and check what is relevant and how to configure it. 

Furthermore, few required features essential for improving VM performance were not supported at all by oVirt (for example, using huge pages or I/O Thread pinning). In addition, new features as Headless VMs and running Real Time guest OS can now be leveraged to suggest one solution of the best recommended configuration according to VM usage requirements.

This feature introduce a simple to manage solution for running a new/existed VM as High Performance via Engine or REST api, while the user can still keep an option to manually change or ignore the suggested configuration for his own tuning and requirements. 

## Usage

 -  Setting a VM to run as a High Performance VM can be done to a new or existed VM via UI by selecting the "High Performance" type in the "Optimized for" pull down menu field displayed in VM new/edit dialog. 
This new VM type is added in addition to already existed VM types: "Server", "Desktop". 
 
 - In case of changing the VM type for a running VM, part of the required configuration changes will require a VM restart after saving. In case of changing the VM type for a new/existed VM, part of the required/suggested configuration may require manually changes of the VM's cluster configuration prior to setting the VM as High-performance, and part of the required/suggested configuration may require changing of the specific pinned host configuration prior to setting the VM as High-performance.

 -  A High Performance Template or Pool can be created in the same way as a VM. In case the user wants to create or edit a VM to become High Performance, he can also choose a Template or a Pool which are configured as High Performance type and "inherit" this property for that specific VM.

 -  Note that if an Instance Type is chosen for a VM, it has no influence on the VM high performance type and configuration. Nevertheless, configuration changed by the Instance Type may override the VM High Performance configuration.

 - Once the "High Performance" VM type was chosen in the VM/Template/Pool dialog,  a set of automatic configuration changes, and suggested manual configuration changes are proposed to the user in order to suggest the user with the optimal configuration setting:
	 - A list of validations and suggested manual configuration changes are displayed in a pop-up window on save ,and the user can choose if to accept and perform before saving or ignore them.
	 
	 - A list of configuration changes will be applied automatically (and the user can cancel before saving via webAdmin UI). We should consider displaying that list of changes in a pop-up or tool-tip or any other suggested solution.

 - This new VM type is supported only for non Windows OS and therefore in case of choosing a Windows based OS in the VM/Template/Pool dialog, the High Performance VM type can not be chosen.

 -  Once the user accept the configuration and click the OK button within the pop-up dialog, the configuration is changed accordingly and the VM becomes a High Performance VM.

 - a new icon is displayed for this new High Performance VM type, left to the VM name, and the VM type will also be displayed in the "General" sub-tab (it is required since no icons are displayed for Pools and Templates).
      
 - This feature doesn't work on all cluster levels (since huge pages are not supported prior to oVirt 4.2).
 
 - Note that all of the scenarios described above can be done in UI only via oVirt WebAdmin and not via the UserPortal.

## Detailed Description

As described above, the configuration settings is divided into configuration changes done automatically (and the user can change before saving) and suggested configuration changes/warnings which are proposed to the user to perform before saving.

### List of automatic configuration settings for High Performance VM

#### **Enable Headless Mode and enable Serial console**
Displayed in console side-tab of the VM dialog.

For Headless VM handling please see https://github.com/sgratch/ovirt-site/blob/master/source/develop/release-management/features/virt/headless-vm.html.mdand

#### **Disable all USB devices**
Displayed in console side-tab of the VM dialog

#### **Disable the Sound Card device**
Displayed in console side-tab of the VM dialog

#### **Enable Pass-Through Host CPU**
Displayed in Host side-tab of the VM dialog.

This option can only be enabled when VM live migration is disabled.

#### **Disable VM migration**
Displayed in Host side-tab of the VM dialog.

The VM cannot be migrated, either automatically or manually for oVirt 4.2. 
Support migration is planned in oVirt 4.3 . See https://bugzilla.redhat.com/show_bug.cgi?id=1457250.
 
#### **Setting the invtsc CPU flag** 
If CPU supports it, adding the invtsc flag to the VM xml:
  <feature policy='require' name='invtsc'/>

#### **Enable IO Threads, Num Of IO Threads = 1**
Displayed in 'Resource Allocation' side-tab of the VM dialog.

#### **Disable the Memory Balloon Device**
Displayed in 'Resource Allocation' side-tab of the VM dialog.

This option can also be set manually by the user for the cluster of that VM  (add/edit Cluster dialog->Optimization side-tab). 

#### **Enable High availability (for the pinned host)**
Displayed in 'High Availability' side-tab of the VM dialog.

Currently High availability is not supported when migration is disabled.
We plan to support it with an option for re-running the VM on the same host in oVirt 4.2 and expand it to all cluster hosts as part of the solution for supporting migration in oVirt 4.3.

#### **Disable the Watchdog device**
Displayed in 'High Availability' side-tab of the VM dialog.

### List of manual configuration settings/warnings for High Performance VM

#### **Set the CPU Pinning topology**
Displayed in 'Resource Allocation' side-tab of the VM dialog.

In case the CPU Pinning topology is not set upon VM saving,  a recommendation/warning will be displayed in a pop-up and the user will be asked to pin the VM to a host (by selecting the "Start running on: Specific Host" in "Host" side-tab) and verify if VM configuration fits the host configuration (number of cores per socket,  threads per core and number of sockets should match).

Ideally the CPU pinning should be done automatically and not manually by the user, But in first phase we will not support it.  The automatic pinning can be done by pinning to the CPU that is responsible for the IO in the host (and don't present this CPU to the guest) or alternatively pinned to CPU#0 as this is typically the one.  

In addition we will suggest to set the emulatorpin in libvirt xml.

#### **Set the I/O Thread pinning topology**
This is currently not implemented. 
Should be added to the 'Resource Allocation' side-tab of the VM dialog. It will be implemented by setting  the iothreadpin in libvirt xml accordingly

This feature should be implemented the same as the CPU pinning is implemented.

In case the I/O Thread pinning topology is not set upon VM saving,  a recommendation/warning will be displayed in a pop-up and the user will be asked to pin the I/O thread to a host and verify it fits the host configuration.
Consider verifying if the  I/O is bound to specific CPU on host level and chose that CPU for pinning the I/O Thread.

#### **Enable virtual NUMA and set NUMA pinning topology**
Displayed in 'Host' side-tab of the VM dialog.

In case the virtual NUMA and the NUMA pinning topology are not set upon VM saving,  a recommendation/warning will be displayed in a pop-up and the user will be asked to pin the VM to a host that supports NUMA topology and verify the VM NUMA topology fits the host's NUMA topology.

Ideally the NUMA pinning should be done automatically according to the exposed host's NUMA topology and not manually by the user, but in first phase we will not support it.

#### **disable kernel same page merging (KSM)**
This is currently implemented in engine only for cluster level (new/edit cluster dialog->'Optimization side-tab). 

KSM can be manually deactivated in host level by stopping the ksmtuned and the ksm service on the hypervisor.
Disabling the KSM for the specific VM should be implemented by adding a check-box to the 'Resource Allocation' side-tab of the VM dialog and implemented by setting the "nosharepages" domain property in libvirt xml.

In case that KSM is not disabled upon VM saving,  a recommendation/warning will be displayed in a pop-up and the user will be asked to disable it either in cluster level, host level or for the specific VM.

#### **Enable  memory backing with huge pages**
This is currently not implemented. 
This feature includes host side changes in addition to engine and UI changes. The UI changes should be added to the 'Resource Allocation' side-tab of the VM dialog. 
It will be added as a check box with two options: 2M or 1G (as configured at Hypervisor Boot Time) and the number of pages to use for each.

In case that huge pages configuration is not set upon VM saving,  a recommendation/warning will be displayed in a pop-up and the user will be asked to set it and verify it fits the host configuration. 

For more information please see https://trello.com/c/ABUiJgWR/62-hugepages

### WebAdmin UI

![](../../../../images/wiki/Screenshot from 2017-06-15 10-46-39.png)

 *   A new "High Performance" type is added to the "Optimized for" pull down menu field displayed in VM/Template/Poll for new and edit dialogs.

 * New icons are added to display this new VM type + modes (Stateless/Stateful, with/without new configuration, Vm in a Pool/regular VM).

 * The VM/Template/Pool "optimized for" type (values: "Server", "Desktop" or "High Performance") will be displayed in the "General" sub-tab.

### REST API

 - a new 'High Performance' VM type should be added to VM/pool/Template creation/editing APIs.
 - All relevant configuration changes mentioned above should be exposed in APIs, including the new features like huge pages configuration, I/O thread pinning and KSM setting in VM level).
    
## Status

*   Target Release: Ovirt 4.2
*   Status: Planning

## Limitations

## Dependencies / Related Features
Headless VM
Huge pages 
Real Time VM support