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

This allows the user to configure and start Geo Replication session for Gluster Volumes. GlusterFS Geo-replication provides a continuous, asynchronous, and incremental replication service from one site to another over Local Area Networks (LANs), Wide Area Network (WANs), and across the Internet.

## Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Selvasundaram Subramaniam <sesubram@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: In Progress
*   Last updated date: Mon Oct 22 2012

## Detailed Description

GlusterFS Geo-replication uses a master–slave model, whereby replication and mirroring occurs between the following partners:

*   Master – A GlusterFS volume
*   Slave – A slave can be of the following types:
    -   A local directory which can be represented as file URL like <file:///path/to/dir>. You can use shortened form, for example: /path/to/dir.
    -   A GlusterFS Volume - Slave Volume can be either a local volume like gluster://localhost:volname (shortened form - :volname) or a volume served by different host like gluster://host:volname (shortened form - host:volname).

Configuring and Monitoring unidirectional Geo Replication (master-slave).

The following features will be supported

*   Setting up passwordless SSH
*   Configuring and Starting Geo Replication
*   Displaying Geo-replication status information

## Design

![](Geo-Replication-Start.png "fig:Geo-Replication-Start.png") ![](Geo-Replication-Start-Verifying-SSH.png "fig:Geo-Replication-Start-Verifying-SSH.png") ![](Geo-Replication-Start-Verifying-SSH-Sucess.png "fig:Geo-Replication-Start-Verifying-SSH-Sucess.png") ![](Geo-Replication-Start-Verifying-SSH-Failed.png "fig:Geo-Replication-Start-Verifying-SSH-Failed.png") ![](Geo-Replication-Start-Privatekey-Test.png "fig:Geo-Replication-Start-Privatekey-Test.png") ![](Geo-Replication-Start-SSH-Setup.png "fig:Geo-Replication-Start-SSH-Setup.png") ![](Geo-Replication-Start-SSH-Setup-Success.png "fig:Geo-Replication-Start-SSH-Setup-Success.png") ![](Geo-Replication-Start-User-Defined.png "fig:Geo-Replication-Start-User-Defined.png")

<Category:Feature>
