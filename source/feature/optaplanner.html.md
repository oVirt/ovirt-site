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

There are two major paths we can take:

1.  Standalone application -- The advantage here is that we already have code we can base our solution on. The scheduling example of Optaplanner contains cluster balancing task with GUI vizualization. We could let the user start the App, select a cluster (using REST to provide the list) to optimize and start the computation. The disadvantage is obviously that it is a separate application.
2.  UI plugin in the engine -- The advantage here is that the result will be available in a dialog window or a tab directly in the webadmin. That way the user will have comfortable access to the results from a UI he is used to. Also the authentication and access management will be provided by the webadmin. The disadvantage is that the UI plugin will have to use some kind of new protocol (REST, plain HTTP, …) to talk to the Optaplanner service. Also it will probably have to authenticate to that service.

There is also a question of how to represent the solution:

*   We could show a table (graph, image) of the desired assignments
*   or we could tell the user the order of steps he should perform (migrate A to B…) to reach the desired state

### Rules to select the optimal solution (high level overview)

All optimization tasks need to know how does a possible solution look like and how to select the best one.

There are couple of options for us to consider when writing the rules. We might also allow the user to select the desired task from a list if we decide that more than one is useful:

1.  score according to the currently selected cluster policy -- The rationale here is that when VMs are started one by one then the assignment might be suboptimal, because the scheduling algorithm had no knowledge about the VMs that are yet to start. If we base our rules on the current cluster policy we might be able to compute a solution that takes all running VMs into account at once. This approach will then use:
    -   filters as source for hard constraint score
    -   weights for the soft constraint score
    -   Another metric we should use here is the necessary number of actions to change the current situation to the computed "optimal" solution.

2.  find a place for new VM -- This should try to rebalance a cluster in such a way that a VM that is not running can be started. It is closely related to the first option except it needs to know what resources should be reserved or ideally what VM is supposed to be started.

There are two situations that should be avoided in the computed solutions:

1.  Unstable cluster -- what I mean here is that once the user performs the changes to get the cluster to the "optimal" state, the engine's internal balancing kicks in and rearranges the cluster differently. It would mean that the output of the optimization algorithm was not as smart as we wanted it to be.
2.  Impossible solution -- if the user gets a solution from the optimization algorithm and then finds out that the cluster policy prevents him from reaching it, we will have an issue that the theoretical solution is totally useless for the user and this feature won't be thus useful to him at all

# Comments and Discussion

*   Refer to [Talk:Self Hosted Engine](Talk:Self Hosted Engine)

<Category:Feature> <Category:SLA>
