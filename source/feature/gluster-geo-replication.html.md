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

*   View all active/inactive geo replication sessions in the cluster
*   Start a new Geo-Replication session
*   Setup Passwordless SSH between one of the servers in the cluster and remote host
*   Change the configuration before starting the session or later (ssh command, gsync command)
*   Stop any running Geo-Replication session
*   Monitor the statuses of Geo-Replication session in a cluster
*   Remove any inactive session

## Design

### View All Geo Replication Sessions

A new main tab will be added to the oVirt webadmin UI which will list all the geo replications in the cluster. This tab will not be available in the System level and this will be shown if a Gluster enabled cluster is selected in the System Tree.

### Start a new Geo-Replication Session

A new action named **Start** will be shown in the **Geo Replication** tab. On clicking of the action will open the following dialog.

![](Geo-Replication-Start.png "Geo-Replication-Start.png")

*   **Start Geo Replication from Host** field will list all the servers in the cluster which are in **UP** state. When the user selects one of the host, SSH Fingerprint of the host will be fetched and shown.
*   **Remote Host** could be either a standalone machine or part of another cluster.
*   **Remote Volume/Path** will accept either a volume name in the remote cluster or a directory in the remote host. If it doesn't starts with **/**, it will be considered as a volume in the remote cluster.
*   After providing all the details and when the clicks **Ok**,
    -   Passwordless SSH communication between the origination host and **Remote Host** will be verified.
    -   If that succeeded, the geo replication session for the selected volume started
    -   Else the [Passwordless SSH Setup](:File:Geo-Replication-Start-SSH-Setup[.png) dialog will be shown.
*   If the user wants to override the default configuration, he/she can deselect **Use Default** checkbox and provide different configuration. In this case no Passwordless SSH verification will be made.

### Setting up Passwordless SSH

If the Passwordless SSH communication failed between the hosts at the time of starting the geo replication session, the following dialog will be shown.

![](Geo-Replication-Start-SSH-Setup.png "Geo-Replication-Start-SSH-Setup.png")

The user will be given two choices

*   **Use a different privake key** by providing the location of the key file. Passwordless SSH communication will be verified using this private key file.

(or)

*   Provide the password of the user of remote host which is entered in the [Geo-Replication-Start](:File:Geo-Replication-Start.png) dialog to setup Passwordless SSH.

<Category:Feature>
