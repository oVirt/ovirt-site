---
title: Required Networks
category: feature
authors: danken, roy
---

# Required Networks

## Summary

Required networks are a part of monitoring process the engine does, to make sure all the
host in clusters are eligible for migration (cluster is sometimes referred to as the **migration-domain**)
A cluster network which is required but missing from a host will cause the host to be in
non-operational state, thus it can not be activated till it has the network attached.
* Till now, all networks were required , now its optional.

## Owner

*   Name: Roy Golan

<!-- -->

*   Email: rgolan at redhat.com

## Current status

*   Last updated date: April 10 2012
*   implementation: done


## Benefit to oVirt

1.  coming gluster-cluster support which is a cluster that doesn't have migration prospects.
2.  pinned to host VMs that uses networks we don't want other hosts to implement needlessly.
3.  3rd parties doing network management outside of ovirt.

## REST API

when attaching a network to a cluster, add a boolean required property to it

 **POST** `api/clusters/{id}/networks`

```xml
<network id="28372223-881c-4996-81f2-936c6cc2c874">
 <name>test</name>
 <required>false</required>
</network>
```


