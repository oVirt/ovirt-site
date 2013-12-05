---
title: HostPowerManagementPolicy
category: feature
authors: msivak
wiki_category: Feature
wiki_title: Features/HostPowerManagementPolicy
wiki_revision_count: 5
wiki_last_updated: 2013-12-19
---

# Host Power Management Policy

Bug-Url: <https://bugzilla.redhat.com/show_bug.cgi?id=1035238>

Goals:

*   shutdown a host when Powersaving is selected and engine clears the host (migrates all VMs elsewhere)
*   wake up a host when the available resources get below configured level

Design:

*   shutdown methods: standard engine's fencing methods - IPMI, SSH, Drac
*   wake methods: standard methods - IPMI, SSH, ... - with fallback to WOL when needed and supported
*   use Start/StopVdsCommand internally

Shutdown rules:

*   decided as part of load balancing thread
*   host has been empty for some time (configurable timeout)
*   there is enough available hosts in the cluster even without this host
*   make sure spm is not killed

Wake Up rule:

*   decided as part of load balancing thread
*   not enough free hosts in the cluster

UI:

*   Cluster policy needs to allow the user to set:
    -   the minimum amount of free hosts
    -   whether host shutdown is allowed
    -   how long does a host need to be empty to be considered for shutdown
*   Each host needs a boolean that will override the shutdown (persistent host)

Known issues:

*   when user tries to start a Vm that is pinned to a powered down host, we will fail the start

Possible future enhancements:

*   Reserve defined in terms of power, memory, ...
    -   useful for reserving space for fast start of some important VM
    -   bogomips used as the CPU power unit (/proc/cpuinfo)
*   Wake On Lan fencing method:
    -   each host has to report MAC and WOL capability for each NIC
    -   locality information to know who can send the proper WOL packet (each host will report it's ARP database of visible MAC addresses for each NIC)
