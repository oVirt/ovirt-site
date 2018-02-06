---
title: vdsm-client
category: vdsm
authors: igoihman
---

# VDSM Client

## About vdsm-client

**vdsm-client** is a command line tool provided by VDSM.

**vdsm-client** can used to execute commands: start virtual machines, manage storage, devices, etc.

It's recommended to use vdsm-client at development stage, **always use oVirt Engine to manage your stable environment**.

## Connecting to HOST

Connecting to a host is secured by default, pass --insecure to connect in an insecure way (not recommended). Examples:

`   # vdsm-client [-h] [-a ADDRESS] [-p PORT] [--insecure] [--timeout TIMEOUT]
                   [-f FILE] namespace method [name=value [name=value] ...]`

**default**: If no arguments are passed, vdsm-client will connect to localhost.

## Examples

## Listing virtual machines

`   # vdsm-client Host getVMList`

`   # vdsm-client Host getVMList fullStatus=True`

## Getting HOST capabilities

`   # vdsm-client Host getCapabilities`

## Getting host statistics

`   # vdsm-client Host getStats`

## Getting statistics of running VMs

`   # vdsm-client Host getAllVmStats`

## Getting storage VG details

`   # vdsm-client Host getLVMVolumeGroups`

## Stopping a VM

1) Get the vmId:

`   # vdsm-client Host getVMList fullStatus=True`

2) Destroy the VM

`   # vdsm-client VM destroy vmID=<vmID>`

## Resuming a VM

1) Get the vmId:

`   # vdsm-client Host getVMList fullStatus=True`

2) Resume the VM

`   # vdsm-client VM cont vmID=<vmID>`

## Setting up vnc to a Virtual Machine in case oVirt Engine is out

1. Get VM id and displayPort

`   # vdsm-client Host getVMList fullStatus=True`

2. Setting vnc password to VM

`   # vdsm-client VM setTicket vmID=<vmid> password=<password> ttl=0 existingConnAction=keep`

3. Now try to use vnc client

`   # vncviewer <oVirt Node>:<displayPort>`

## Invoking complex commands

For invoking methods with many or complex parameters, you can read the parameters from a JSON format file:

`   # vdsm-client -f lease.json Lease info`

where lease.json file content is:


```
   {
        "lease": {
	    "sd_id": "75ab40e3-06b1-4a54-a825-2df7a40b93b2",
	    "lease_id": "b3f6fa00-b315-4ad4-8108-f73da817b5c5"
	}
    }

```

It is also possible to read parameters from standard input, creating complex parameters interactively:


```
   # cat <<EOF | vdsm-client -f - Lease info
     {
         "lease": {
	     "sd_id": "75ab40e3-06b1-4a54-a825-2df7a40b93b2",
	     "lease_id": "b3f6fa00-b315-4ad4-8108-f73da817b5c5"
	     }
     }
     EOF

```

### Note

Please consult vdsm-client help and man page for further details and options.


