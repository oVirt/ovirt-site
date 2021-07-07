---
title: Support reset brick
category: feature
authors: godas
---

# Gluster Support

## Summary

This feature provides support for reset-brick Gluster based storage clusters in oVirt. Glusterfs repo is available at <http://download.gluster.org/pub/gluster/glusterfs/>

## Owner

*   Feature owner: Gobinda Das <godas@redhat.com>
    -   GUI Component owner: Gobinda Das <godas@redhat.com>
    -   Engine Component owner: Gobinda Das <godas@redhat.com>
    -   VDSM Component owner: Gobinda Das <godas@redhat.com>
    -   QA Owner: SATHEESARAN <sasundar@redhat.com>

## Current Status

*   Requires : glusterfs >= 3.9

## Detailed Description

This feature will introduce the capability of reset existing brick from the oVirt UI. Administrator will be able to perform Gluster volume reset-brick operation.For example in case Server has gone bad and got reprovisioned, but it may got its brick and want to use same brick.

### Approach

With this feature, oVirt will start supporting reset-brick functionalty in case Server has gone bad and got reprovisioned, but it may got its brick and want to use same brick.



### User Interface

New tabs will be displayed as sub-tabs when user selects a brick from the "Gluster Volume -> Bricks" sub-tab.


*   Actions on "Bricks" tab / sub-tab:
    -   Reset Brick
    -   Input for reset-brick is host,volume and existing brick.

    Note: Reset brick will only work with the existing brick, it will not recreate or replace any brick.

Once User will click on "Reset Brick", One Confirmation window will pop up.

A sketch of "Reset Brick" confirmation window:


![](/images/wiki/ResetBrick.png)



### Audit

Operation that result in "Reset Brick" of Gluster Volumes -> Bricks, and any errors that may occur during the same will be audited. The audit log messages will be available in the "Events" tab.

### Notifications

All the Gluster related events that are audited will be available to be subscribed for email notifications. A new category "GlusterVolume" will be added to the notification subscription screen with following events:

*   Gluster Volume Reset Brick started
*   Gluster Volume Reset Brick start failed
*   Gluster Volume Reset Brick reseted
*   Gluster Volume Reset Brick reset failed



## Dependencies / Related Features and Projects

Affected oVirt projects:

*   Engine-core
*   Webadmin
*   VDSM

## Benefit to oVirt

* Brick can be reused in case server reprovisioned or goes bad.

## Documentation / External references

GlusterFS : <https://docs.gluster.org/en/latest/>


*   Bugzilla ticket: [BZ#1396993](https://bugzilla.redhat.com/show_bug.cgi?id=1396993)
