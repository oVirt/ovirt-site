---
title: Fence kdump
category: feature
authors: mperina
wiki_category: Feature
wiki_title: Fence kdump
wiki_revision_count: 93
wiki_last_updated: 2015-01-26
---

# Fence kdump

*It's only proposal, not yet finalized*

## About kdump

## About fence kdump

Fence kdump is a method how to prevent fencing a host during its kdump process. The tool is packaged in fence-agents-kdump package and it contains two commands:

*   `fence_kdump_send`
    -   It is executed in kdump kernel and it sends message using UDP protocol to specified host each time interval to notify that host is still in kdump process
*   `fence_kdump`
    -   It is executed on a host that tries to detect if some other host is in kdump process by receiving messages from specified host

The tool has following limitations that should be considered when using it in oVirt:

1.  `fence_kdump_send` can send packet only to IPs specified as its command line argument (it cannot send packets to level2 broadcast address)
2.  `fence_kdump` return success exit code only for one host at the time, messages from other hosts are ignored
3.  Package fence-agents-kdump doesn't contain any scripts to integrate them into kdump kernel

## Prerequisities

## Fencing flow with fence kdump

## Host configuration
