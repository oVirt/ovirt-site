---
title: VdsClient
category: vdsm
authors: amuller, dougsland, ybronhei
---

# Vds Client

**vdsClient is deprecated in 4.1 and above, please use [vdsm-client](./vdsm-client.html) instead.**

## About vdsClient

**vdsClient** is a console tool provided by VDSM. It can used to execute tests like: start virtual machines, manage storage, devices (CDROM, floppy), etc.

This document intend to be a quick reference for examples of how to use it, feel free to improve it. It's \*only\* recommended to use vdsClient for tests or development stage, **always \*use\* oVirt Engine to manage your stable environment**.

## Connecting to HOST

To connect to host, you can use **-s** as argument for secure connection (SSL) or can just pass as argument the name of host. Examples:

*   $ vdsClient -s HOST (vdsm daemon is listening with ssl enabled)
*   $ vdsClient HOST (no ssl enabled)

**tip**: If 0 is used as argument for HOST, means localhost

## Listening virtual machines

*   $ vdsClient -s HOST list
*   $ vdsClient -s HOST list table

## How to get HOST capabilities?

*   $ vdsClient -s HOST getVdsCapabilities

## How to get host statistics?

*   $ vdsClient -s HOST getVdsStats

## How to see statistics of the currently running VMs?

*   $ vdsClient -s HOST getAllVmStats

## How to see storage VG details?

*   $ vdsClient -s 0 getVGList

## How to stop a VM?

1) Get the vmId:

*   $ vdsClient -s HOST list table

2) Destroy the VM

*   $ vdsClient -s HOST destroy <vmID>

## How to resume VM?

1) Get the vmId:

*   $ vdsClient -s HOST list table

2) Resume the VM

*   $ vdsClient -s HOST continue <vmID>

## How to setup vnc to a Virtual Machine in case oVirt Engine is out?

1. Get VM id and displayPort

*   $ vdsClient -s HOST list

2. Setting vnc password to VM

*   $ vdsClient -s HOST setVmTicket <vmid> <password> 0 keep

3. Now try to use vnc client

*   $ vncviewer <oVirt Node>:<displayPort>

