---
title: Optaplanner
category: feature
authors: adahms, msivak
wiki_category: Feature
wiki_title: Features/Optaplanner
wiki_revision_count: 57
wiki_last_updated: 2015-05-28
---

# Optaplanner integration with scheduling

### Summary

### Owner

*   Feature Owner: Martin Sivák: [msivak](User:msivak)

<!-- -->

*   Email: <msivak@redhat.com>

### Current status

*   Initial design discussion
*   Last updated: -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Use cases

*   VM start failed because of insufficient resources and the user want to know if there is a way to fit the VM
*   The user wants to rebalance the cluster to "optimal" state

### Benefit to oVirt

# **Requirements**

# Detailed Description

This feature will allow the user to get a solution to his scheduling needs. Computing the solution might take a long time so an Optaplanner based service will run outside of the engine and will apply a set of rules to the current cluster's situation to get an optimized VM to Host assignments.

### Getting the cluster situation to Optaplanner

This will be based on REST API after some missing entities are implemented. Optimization will be done on per Cluster basis.

The following information is needed:

*   List of hosts in the cluster with information about provided resources
*   List of all VMs running in the cluster with information about required resources (probably without statistics data for now)
*   The currently selected cluster policy is needed together with the custom parameters
*   The configuration of the cluster policy - list of filters, weights and coefficients

The ideal situation would be if it was possible to get the described data in an atomic snapshot way. Which means that all the data will be valid at one single exactly defined moment in time.

The Optaplanner service will use Java SDK to get the data.

### Representing the solution in Optplanner

Optaplanner requires at least two java classes to be implemented:

*   Solution description -- a set of all VMs with assigned Hosts.
*   Mutable entity for the optimization algorithm to update -- the VM itself, the mutable field is the Host assignment

The VM and Host classes can be represented in couple of ways:

*   SDK's Host and VM classes
*   Engine internal Vds and Vm classes

The selected representation will depend on the way our Optaplanner service will define the rules for the optimization algorithm (see the next sections).

### Reporting the result of optimization

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature> <Category:SLA>
