---
title: VDSM VM Query API
category: api
authors: vfeenstr
feature_name: VDSM VM Data Query API
feature_modules: vdsm, engine-backend
feature_status: Proposed
---

# VDSM VM Data Query API

## Summary

This feature proposes a new API verb for VDSM for querying the data fields of VMs via the RPC interface. The feature allows to get differences since the last request, asking for specific fields and/or excluding fields from the data retrieved.

## Owner

*   Name: Vinzenz Feenstra (Evilissimo)
*   Email: <evilissimo@redhat.com>

## Current status

*   Last updated on -- by (WIKI)

## Detailed Description

**new verb:** *Host.queryVms(vmIds=[], fields=[], exclude=[], changedSince=' ')*
**vmIds:** queries the vms specified or all when the list is empty
**fields:** queries only for the fields specified or all when empty
**exclude:** excludes the fields specified or none if empty
**changedSince:** queries only for the fields which changed since the given stamp. (fields and exclude parameters are respected, so only fields matching will be checked and returned)
 The call returns a structure like this:

       {'dataList': [{
         vmId: "`<uuid>`",
      `    `fields queried for`... `
        }],
        'queryStamp': 'a string value indicating the lastest changes and passed to changedSince in a follow up request'}

*Boilerplate status/message omitted in the result for simplification reasons*

### Queryable fields

*   **acpiEnable**: Indicates if ACPI is enabled inside the VM
*   **appsList**: A list of installed applications with their versions
*   **balloonInfo** Guest memory balloon information
*   **boot** An alias for the type of device used toboot the VM
*   **cdrom** The path to an ISO image used in the VM's CD-ROM device
*   **clientIp** The IP address of the client connected to the display
*   **copyPasteEnable** Specify if copy and paste is enabled. Currently relevant for @qxl devices only.
*   **cpuShares**: The host scheduling priority (relative to other VMs). In case both cpuShares and nice are present, cpuShares will be used.
*   **cpuSys**: Ratio of CPU time spent by qemu on other than guest time
*   **cpuType**: The type of CPU being emulated special values 'hostPassthrough' and 'hostModel' are reserved for host-passthrough and host-mode cpu mode
*   **cpuUser**: Ratio of CPU time spent by the guest VM
*   **custom**: A dictionary of custom, free-form properties
*   **devices**: An array of VM devices present
*   **disks**: Disk bandwidth/utilization statistics
*   **disksUsage**: Info about mounted filesystems as reported by the agent
*   **display**: The type of display
*   **displayInfo**: Display and graphics device informations.
*   **displayIp**: The IP address to use for accessing the VM display
*   **displayPort**: The port in use for unencrypted display data
*   **displaySecurePort**: The port in use for encrypted display data
*   **displayType**: The type of display in use
*   **elapsedTime**: The number of seconds that the VM has been running
*   **emulatedMachine**: The machine specification being emulated
*   **exitCode**: The exit code f the VM process has ended
*   **exitMessage**: Explains the reason that the VM process has exited
*   **guestCPUCount**: The number of CPU cores are visible as online on the guest OS. This value is -1 if not supported to report
*   **guestFQDN**: Fully qualified domain name of the guest OS. (Reported by the guest agent)
*   **guestIPs**: A space separated string of assigned IPv4 addresses
*   **keyboardLayout**: The keyboard layout string (eg. 'en-us')
*   **kvmEnable**: Indicates if KVM hardware acceleration is enabled
*   **maxVCpus**: Maximum number of CPU available for the guest. It is the upper boundry for hot plug CPU action
*   **memGuaranteedSize**: The amount of memory guaranteed to the VM in MB
*   **memSize**: The amount of memory assigned to the VM in MB
*   **memUsage**: The percent of memory in use by the guest
*   **memoryStats**: Memory statistics as reported by the guest agent
*   **migrationProgress**: Indicates the percentage progress of a Migration, when there is one active.
*   **monitorResponse**: Indicates if the qemu monitor is responsive
*   **netIfaces**: Network device address info as reported by the agent
*   **network**: Network bandwidth/utilization statistics
*   **nicModel**: A comma-separated list of NIC models in use by the VM
*   **nice**: The host scheduling priority
*   **pauseCode**: Indicates the reason a VM has been paused
*   **pid**: The process ID of the underlying qemu process
*   **serial**: Serial number for the VM.
*   **session**: The current state of user interaction with the VM
*   **smp**: The number of CPUs presented to the VM
*   **smpCoresPerSocket**: Indicates the number of CPU cores per socket
*   **smpThreadsPerCore**: Indicates the number of CPU threads per core
*   **statsAge**: The age of these statistics in seconds
*   **status**: The current VM status
*   **timeOffset**: The time difference from host to the VM in seconds
*   **transparentHugePages**: Indicates if the Transparent Huge Pages feature is enabled for this virtual machine
*   **username**: The username associated with the current session
*   **vNodeRuntimeInfo**: Information about the vm numa node runtime pinning to host numa node.
*   **vmId** #required The VM UUID
*   **vmJobs**: Info about active vm jobs
*   **vmName**: The VM name
*   **vmType**: The type of VM
*   **watchdogEvent**: Information about the most recent watchdog event

## Benefit to oVirt

The proposed API verb can reduce the required volume of data sent over the management network to in a range of 75-90% **without using compression**. Please see the [Measurements Page](/develop/release-management/features/vdsm/measurements.html) for the actual results of the tests performed using this API in comparison to the current way.

This proposal introduces a more flexible way of changing the API by adding new fields or deprecating them by exclusion from the callers side. Additionally fields are only sent when they have been really changed since the last request.

Another big benefit to oVirt is that we can improve the responsiveness but still reduce the overall traffic and load for marshalling the data between engine and vdsm.

## Dependencies / Related Features

TODO

## Documentation / External references

TODO

## Testing

TODO



