---
title: blkio-support
category: feature
authors: gchaplik
wiki_category: Feature
wiki_title: Features/blkio-support
wiki_revision_count: 9
wiki_last_updated: 2014-05-11
---

# blkio-support

## Support blkio SLA features

### Overview

In a highly consolidated and shared environment found in the virtual datacenter, storage bandwidth often comes up as a significant root cause of performance problems. In order to help users mitigate these bottlenecks, they have requested the ability to have finer grained controls over an individual VM’s ability to consume storage bandwidth. This will allow them to set maximum thresholds on individual VMs and Disk files so as to prevent misbehaving VMs from impacting the performance of other VMs sharing the same hosts, storage pools, or even same storage array. There are two key metrics that libvirt can enable users to set limits on: Throughput (in Bytes/Second) and IO Operations (Input/Output Operations/Second). There is a typical dynamic is storage I/O that is often seen in which a smaller number of large files being read or written often consume fewer IOps, but operate at a higher throughput. Conversely, when a large number of small files are being read or written, there are typically a higher number of IOps but noticeably slower total throughput. It is strongly suggested that users thoroughly understand their workload characteristics in order to properly set limits on I/O at various levels, as a misconfiguration could cause potential downtime and outages to running workloads.

### Owner

Name: [ Gilad Chaplik](User:gchaplik) Email: <gchaplik@redhat.com>

### Current status

Status: design

Last updated: ,

### Detailed Description

<Category:Feature> <Category:SLA>
