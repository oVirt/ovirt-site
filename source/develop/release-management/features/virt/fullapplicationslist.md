---
title: FullApplicationsList
category: feature
authors:
  - ekohl
  - gal
---

# Full Applications List

## Abstract

A requested feature to view all the installed packages on a VM in a way that scale well.

## The current workflow

The guest agent queries the operating system in order to build a list of the installed applications (rpmdb on Linux and the registry on Windows). On Linux the agent have a configuration settings that determine which applications will be reported.

The whole list is reported every 120 seconds. The value is defined in the configuration.

The VDSM store the applications list in memory.

The backend queries VDSM every 2 seconds to receive a subset of the Vms status. The backend queries VDSM every 10 seconds to receive a full Vms status. This report includes the applications list.

## The problems

The agent query the operating system every time it need to information.

A RHEL installation with ~900 packages installed will require about 45 Kb (name, version and some protocol overhead) per VM. This mean that on a host, running ~1000 Vms, will have a network throughput of ~4.5 Mb per second. Reporting the same data over and over again. It also mean that vdsm will use a memory size of ~100Mb for holding the list.

## The solution

The applications list will be reported on the following scenarios:

1.  Remove: On agent startup.
2.  On a 'refresh' request from vdsm.
3.  A modification event (rpmdb packages file change on Linux and registry change on Windows). When this event is set the agent will wait a period of one minute. If during that minute no more events will occur the agent will create a new applications list and will report it to vdsm.

The agent's Windows version will continue to report the same applications list.

The vdsm will use the existing “hash” field to the short Vm stats information. The hash is updated to indicate that an update list is available.

The vdsm will store the application list in a file. The file will be read if the list is requested. This will eliminate the memory cost of store the full list for all Vms.

The backend will need to examine the value of the “hash” field. If the value was changed it should perform another request in order to receive the full applications list. This is the same behavior as the new implementation which pull the Ethernet's information.

[Category:Featurea](/develop/release-management/features/)
