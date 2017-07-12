---
title: HostPowerManagementPolicy
category: feature
authors: msivak
---

# Host Power Management Policy

Bug-Url: <https://bugzilla.redhat.com/show_bug.cgi?id=1035238>

## Owner

*   Martin Sivak <msivak@redhat.com>

## Status

*   Basic implementation in gerrit verified to work with the nice scenarios:
    -   <http://gerrit.ovirt.org/22376>
    -   <http://gerrit.ovirt.org/22488>
    -   <http://gerrit.ovirt.org/22520>

## Goals

*   shutdown hosts when Powersaving is selected and engine clears the host (migrates all VMs elsewhere)
*   wake up a host when the available resources get below configured level

## Design

*   shutdown methods:
    -   graceful shutdown - SSH, IPMI (if it supports that)
    -   standard engine's fencing methods - IPMI, Drac, ...
*   wake methods:
    -   standard fencing methods - IPMI, SSH, ... - with fallback to WOL when needed and supported
*   use Start/StopVdsCommand internally

### Shutdown rules

*   decided as part of load balancing thread
*   there is enough available hosts in the cluster even without this host
*   make sure spm is not killed

### Wake Up rule

*   decided as part of load balancing thread
*   not enough free hosts in the cluster

### Shutdown procedure

*   qualifying Hosts (powerManagementControlledByPolicy==true) in the Up state (one at a time) will be moved to maintenance and powerManagementControlledByPolicy kept as true by the load balancer
*   qualifying Hosts in the Maintenance state that also have powerManagementControlledByPolicy flag set will be shut down

### Wake up procedure

*   when the load balancer decides to wake up a host or the user clicks the Activate button
*   engine will start the host and set powerManagementControlledByPolicy to true flag when the startup is finished

## DB changes

*   new boolean flag for Host - powerManagementControlledByPolicy - meaning the host can be controlled by the automatic policy, will be cleared by user triggered PM actions and set every time the host goes Up
*   new boolean flag for Host - disableAutomaticPowerManagement - that will make this host invisible to the power management policy

## new Power saving policy attributes

*   Cluster policy needs to allow the user to set:
    -   the minimum amount of free hosts
    -   whether host shutdown is allowed
    -   (how long does a host need to be empty to be considered for shutdown)

## UI

*   Each host needs a boolean that will override the shutdown (persistent host)

## Known issues

*   when user tries to start a Vm that is pinned to a powered down host, we will fail the start
*   if there is no spare available we might need to fail RunVm and inform the user to try again once we start more hosts
*   if we initiate host shutdown and it takes long time, we might try to start it up again - we need a way of distinguishing initiated shutdown and real down state
*   if we are powering up a host and it fails, it is possible we will select the same host for the next attempt
*   power operations might need to be executed in a separate thread to not block the balancer operations

## Possible future enhancements

*   Reserve defined in terms of power, memory, ...
    -   useful for reserving space for fast start of some important VM
    -   bogomips used as the CPU power unit (/proc/cpuinfo)
*   Wake On Lan fencing method:
    -   each host has to report MAC and WOL capability for each NIC
    -   locality information to know who can send the proper WOL packet (each host will report it's ARP database of visible MAC addresses for each NIC)

