---
title: Microthreading
authors: vitordelima
---

# Microthreading

### Summary

This feature will allow a core in ppc64 hosts to be shared simultaneously by multiple VMs.

### Owner

*   Name: Vitor de Lima (Vitordelima)

### Current status

In planning.

### Detailed Description

This feature will allow the admin to configure microthreading in ppc64 hosts (with POWER8 processors). By default, each VM running in a ppc64 host has an entire core dedicated to it during its execution, including all of its threads (8 threads per core in POWER8). Microthreading allows a core to be share simultaneously by multiple VMs, each one of them taking one or two threads of each core. This is done by partitioning the core into smaller subcores which are assigned to the VMs.

### Benefit to oVirt

Allows the admin of an oVirt based datacenter to split each core of the ppc64 host into subcores, allowing a better usage of the CPU resources in certain workloads.

### Detailed Design

The admin will be able to change how each core is split into subcores in the Hosts dialog window, after all the VMs of that host are either stopped or migrated to another host.

### Documentation

PowerKVM manual <http://www.redbooks.ibm.com/abstracts/sg248231.html?open>
