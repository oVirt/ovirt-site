---
title: Gluster Geo Replication
category: feature
authors: kmayilsa, sahina, sandrobonazzola, shtripat
wiki_category: Feature|Gluster Geo Replication
wiki_title: Features/Gluster Geo Replication
wiki_revision_count: 121
wiki_last_updated: 2014-12-22
---

# Gluster Geo Replication

## Summary

This feature allows the user to configure, start, stop and monitor Geo-Replication sessions for Gluster Volumes. GlusterFS Geo-replication provides a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

## Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Selvasundaram Subramaniam <sesubram@redhat.com>
    -   VDSM Component owner: Balamurugan Arumugam <barumuga@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: In Progress
*   Last updated date: Mon Nov 2 2012

## Detailed Description

GlusterFS Geo-replication uses a master–slave model, whereby replication and mirroring occurs between the following partners:

*   Master – A GlusterFS volume
*   Slave – A slave can be of the following types:
    -   A directory in a remote host.
    -   A GlusterFS Volume in a remote host/cluster.

With this feature the user will be able to

*   Setup Passwordless SSH between one of the servers in the cluster and remote host
*   Start a new Geo-Replication session
*   Change the configuration before starting the session or later
*   Stop any running Geo-Replication session
*   Monitor the statuses of Geo-Replication session in a cluster
*   Remove any inactive session

## Design

### Start a new Geo-Replication Session

![](Geo-Replication-Start.png "Geo-Replication-Start.png")

### Setting up Passwordless SSH

![](Geo-Replication-Start-SSH-Setup.png "Geo-Replication-Start-SSH-Setup.png")

<Category:Feature>
