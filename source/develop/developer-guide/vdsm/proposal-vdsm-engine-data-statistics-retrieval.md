---
title: Proposal VDSM - Engine Data Statistics Retrieval
category: vdsm
authors:
  - danken
  - vfeenstr
---

# Proposal VDSM - Engine Data Statistics Retrieval

== VDSM <=> Engine data retrieval optimization ==

## Motivation:

Currently the oVirt Engine is polling a lot of data from VDSM every 15 seconds. This should be optimized and the amount of data requested should be more specific.

For each VM the data currently contains much more information than actually needed which blows up the size of the XML content quite big. We could optimize this by splitting the reply on the getVmStats based on the needs of the engine into different requests. For this reason Omer Frenkel and me have split up the data into parts based on their usage.

## Changes

#### New Verbs

##### getAllVmRuntimeStats

Get runtime information of all VMs
Returns for each VM a map with UUID and a value of:

*   **@cpuSys** Ratio of CPU time spent by qemu on other than guest time
*   **@cpuUser** Ratio of CPU time spent by the guest VM
*   **@memUsage** The percent of memory in use by the guest
*   **@elapsedTime** The number of seconds that the VM has been running
*   **@status** The current status of the given VM
*   **@statsAge** The age of these statistics in seconds
*   **@hashes** Hashes of several statistics and information around VMs

Hashes consists of:

*   **@info** Hash for VmConfInfo data
*   **@config** Hash of the VM configuration XML
*   **@status** Hash of the VmStatusInfo data
*   **@guestDetails** Hash of the VmGuestDetails data

##### getVmStatus

Get status information about a list of VMs
Parameters:

*   **@vmIDs** a list of UUIDs for VMs to query

Returns for each VM in vmIDs a map with UUID and a value of:

*   **timeOffset** The time difference from host to the VM in seconds
*   **monitorResponse** Indicates if the qemu monitor is responsive
*   **clientIp** The IP address of the client connected to the display
*   **username** the username associated with the current session
*   **session** The current state of user interaction with the VM
*   **guestIPs** A space separated string of assigned IPv4 addresses
*   **pauseCode** Indicates the reason a VM has been paused

##### getVmConfInfo

Get configuration information about a list of VMs
Parameters:

*   **@vmIDs** a list of UUIDs for VMs to query

Returns for each VM in vmIDs a map with UUID and a value of:

*   **acpiEnable** Indicates if ACPI is enabled inside the VM
*   **displayPort** The port in use for unencrypted display data
*   **displaySecurePort** The port in use for encrypted display data
*   **displayType** The type of display in use
*   **displayIp** The IP address to use for accessing the VM display
*   **pid** The process ID of the underlying qemu process
*   **vmType** The type of VM
*   **kvmEnable** Indicates if KVM hardware acceleration is enabled
*   **cdrom** ***optional*** The path to an ISO image used in the VM's CD-ROM device
*   **boot** ***optional*** An alias for the type of device used to boot the VM

##### getAllVmDeviceStats

VM device statistics containing information for getting statistics and SLA information
Returns for each VM a map with UUID and a value of:

*   **memoryStats** Memory statistics as reported by the guest agent
*   **balloonInfo** Guest memory balloon information
*   **disksUsage** Info about mounted filesystems as reported by the agent
*   **network** Network bandwidth/utilization statistics
*   **disks** Disk bandwidth/utilization statistics

##### getVmGuestDetails

Get details from the guest OS from a list of VMs
Parameters:

*   **@vmIDs** a list of UUIDs for VMs to query

Returns for each VM in vmIDs a map with UUID and a value of:

*   **appsList** A list of installed applications with their versions
*   **netIfaces** Network device address info as reported by the agent

#### Usage

Currently the engine is requesting currently every 3 seconds the vm list from each vdsm host and every 15 seconds all the data mentioned above for all VMs.

The change would be as follows:

The engine requests every 3 seconds getAllVmRuntimeStats from vdsm which will give the engine the most used data. If the engine has a mismatch of the hashes returned by getAllVmRuntimeStats it should request the data changed.

if hashes.info changed => request getVmConfInfo with all vmIDs on that host where the hash changed if hashes.status changed => request getVmStatus with all vmIDs on that host where the hash changed if hashes.guestDetails changed => request getVmGuestDetails with all vmIDs on that host where the hash changed

Request getAllVmDeviceStats periodically e.g. every 5 minutes, which should be sufficient for the DWH, in case it is not it could be even configurable.
