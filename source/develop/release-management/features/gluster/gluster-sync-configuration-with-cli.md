---
title: Gluster Sync Configuration With CLI
category: feature
authors: kmayilsa, shireesh
---

# Gluster Sync Configuration With CLI

## Summary

Providing support for automatically sync the changes made through Gluster CLI in oVirt.

## Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   Engine Component owner: Shireesh Anjal <sanjal@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Completed
*   Last updated date: Tue Jan 29 2013

## Detailed Description

### Automatic

Introduce background job(s) in oVirt engine that will periodically fetch latest cluster configuration from GlusterFS and sync the same with the engine DB. Following changes done from gluster CLI should get reflected in the GUI:

*   volume created
*   volume deleted
*   volume started/stopped
*   brick(s) added
*   brick(s) removed
*   brick(s) replaced
*   new option set
*   value of existing option changed
*   option reset
*   Server removed (peer detach)
*   brick process went down / came up

#### Key considerations

*   The background job(s) that perform(s) the syncing should be scheduled only if the Application is running in a mode that supports Gluster (vdc option ApplicationMode)
*   Most of the data, except brick status is fetched using 'gluster volume info' command, which doesn't add much overhead on the gluster processes, and hence can be executed more frequently. Brick status however, is fetched using 'gluster volume status' which adds a significant

overhead, and hence must be executed less frequently. For this reason, there should be two separate jobs executed at two different frequencies, for fetching the 'lightweight' and 'heavyweight' data respectively.

*   The refresh rates for these two jobs should be configurable as VDC options, with names GlusterRefreshRateLight and GlusterRefreshRateHeavy, with default values of 5 seconds and 5 minutes respectively.
*   Server removed from gluster CLI should be removed in engine DB only if it belongs to a 'gluster-only' cluster.
*   Whenever a change is detected in the configuration and synced in the engine DB, an audit log should be generated with severity of "alert", containing details of the change.

### Through Notifications

Handling of servers added (peer probed) from gluster CLI needs to be done in a different way, as addition of any server in engine requires user's approval after verifying the SSH fingerprint. To achieve this, - Whenever a cluster is selected in the 'clusters' tab, asynchronously send a request to the server to identify if any servers have been added to it from gluster CLI - If yes, provide two links on the cluster general tab - one for adding the missing servers, another for selectively removing the unwanted ones.

#### Import

*   When User clicks on 'import' link, display a screen containing all newly added servers, along with their SSH fingerprints
*   User should be able to edit the server names (not hostname/ip) and provide root password for all these servers
*   After user accepts the servers, providing root passwords for all of them, add all of them to the cluster

#### Detach

*   When user clicks on the 'detach' link, display a screen containing all the additional servers
*   User should be able to select one or more of these servers, and click on the 'Ok' button
*   This should trigger a 'gluster peer detach' command to remove the selected servers from the gluster cluster

## Design

### GlusterManager

This class will have methods that run periodically to sync information with GlusterFS.

refreshLightWeightData() : Runs more frequently and syncs information that can be fetched without much of an overhead on GlusterFS. This refresh rate is controlled by configuration "GlusterRefreshRateLight" , with default value of 5 seconds

getGlusterRefreshRateHeavy(): Runs less frequently and syncs information that adds a significant overhead on GlusterFS. This refresh rate is controlled by configuration "GlusterRefreshRateHeavy" , with default value of 5 minutes

### Import

![](/images/wiki/Gluster-Sync-import.png)

### Detach

![](/images/wiki/Gluster-Sync-detach.png)

