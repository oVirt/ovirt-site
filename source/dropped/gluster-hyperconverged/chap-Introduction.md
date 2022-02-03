---
title: Introduction
---

# Chapter: Introduction

> Hyperconvergence is a type of infrastructure system with a software-centric architecture that tightly integrates compute, storage, networking and virtualization resources and other technologies from scratch in a commodity hardware box supported by a single vendor[1].

[1] http://searchvirtualstorage.techtarget.com/definition/hyper-convergence

oVirt has been integrated with GlusterFS, an open source scale-out distributed filesystem, to provide a hyperconverged solution where both compute and storage are provided from the same hosts. Gluster volumes residing on the hosts are used as storage domains in oVirt to store the virtual machine images. oVirt is run as Self Hosted Engine within a virtual machine on these hosts

![Overview](/images/gluster-hyperconverged/hc-arch.png)

**oVirt Hyperconverged solution can be run with either 1 (since oVirt 4.2) or 3 nodes.**

There's a minimum 3 node requirement to run a hyperconverged solution with HA for virtual machines. This is to ensure availability of the shared storage. With a 2 node deployment, GlusterFS cannot identify quorum loss and this could lead to data inconsistencies.

Either a replica 3 or a replica 3 with arbiter can be used as the gluster volume type for the deployment.
A replica 3 stores/replicates copy of the data on 3 bricks, where each of the 3 node has a brick. With replica 3 arbiter, copy of the data is stored on 2 of the bricks and metadata is stored on the third brick ensuring consistency of data in case of split-brain. Lesser storage space is required in case of the arbiter volume, but this volume type is not as highly available as the replica 3 type.

With oVirt 4.2, there's also an option to deploy the hyperconverged solution on a single node. This, of course, does not have any high availability guarantees but useful for users who do not need that. You can read more at [Single node hyperconverged](/documentation/gluster-hyperconverged/chap-Single_node_hyperconverged.html)

For hardware requirements, see Host Requirements in the [Installation Guide](/documentation/installing_ovirt_as_a_self-hosted_engine_using_the_command_line/#host-requirements).

**Next:** [Chapter: Deploying oVirt and Gluster Hyperconverged](chap-Deploying_Hyperconverged.html)
