---
title: Feature-Level-Support
authors: ovedo
---

# Feature Level Support

## Summary

The Feature level support functionality is all about having hosts with different capabilities in the same cluster, under the same cluster level, allowing the administrator to set the requirements he has from the hosts in the cluster.

### Owner

*   Name: Oved Ourfali (Oved Ourfali)
*   Email: <ovedo@redhat.com>

### Current status

*   status: Design
*   Last updated: February 12, 2014

## Motivation / What's the issue?

Today, enforcement of the hosts in the cluster is set using a cluster level setting. Each host that is added to the cluster is checked for its supported cluster levels, and as a result it is being accepted to the cluster (Operational state), or not (Non-Operational state). However, the release cycle of oVirt can be quite different from the OS release cycle (Fedora, RHEL, CentOS, Ubuntu, and etc....), so a specific cluster level can be supported both in FedoraX and FedoraY (X < Y), but it will use the lowest common feature set of FedoraX. If we need to use a feature that's available in FedoraY, we need a new cluster level that uses this feature, specifying that FedoraY supports this cluster level, whereas FedoraX doesn't. This feature comes to solve this issue.

## Benefits to oVirt

Allowing administrators to better utilize and customize their oVirt infrastructure to fir their needs, using cutting-edge features in their hypervisors.

## Solution / How do we tackle the issue?

The feature level support functionality comes to solve this by adding another level of granularity. Instead of looking only at the cluster level, we will also look at the feature set supported on the hosts, allowing the administrator to select features that he would like to use in this cluster.

For example, let's look at RHEL and on cluster level 3.5 (new cluster level). This cluster level is supported both by RHEL6 and RHEL7 hosts. RHEL7 supports hot-plug RAM, whereas RHEL6 doesn't. I'm an administrator, and I'd like to create a new cluster, of cluster level 3.5, adding RHEL6 hosts. So far so good... Hot-plug RAM is disabled by default on my cluster, so I have no issue..

Now, I've bought some new servers, and decided to install RHEL7 hosts on them. I'd like to put these hosts on the same cluster, as they also support cluster level 3.5.

But hey... I have a new cool feature called hot-plug RAM, which is highly relevant for me, so I'd like to leverage that in my cluster. So I go to the cluster properties, selecting to enable the Hot-Plug RAM feature. I get a warning "note that hot-plug RAM isn't supported on some hosts in the cluster. Enabling that will make these hosts non-operational"... My options are:

1.  Create a new 3.5 cluster, adding these hosts to this cluster
2.  Upgrade my other hosts to RHEL7

So, instead of having to wait for cluster level 3.6 to be introduced, and only then to leverage the new RHEL features, I can do that now using one of the alternatives above.

This feature allows oVirt as a project to support new features, without the need to create a new cluster level for each and every new feature that's added to the engine / hosts. So one would ask - what's cluster level good for?

It gathers a set of tested functionality, i.e. all these features were tested together and they work in cluster level X. Want to use a new exciting feature Z? Go ahead and enable that... it might have been tested heavily, or might not, but you can enable it and start using it. When we introduce cluster level X+0.1 it will be on all the time, and tested with other features that are available in this cluster level.

Confused? If so I hope that the next section will help put some order in the details.

## Detailed description

## Implementation Details

### DB Changes

### New Objects

### VDSM API

### REST API

### UI
