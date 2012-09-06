---
title: How to Connect to SPICE Console With Portal
category: howto
authors: alonbl, deadhorseconsulting, digisign, gianluca
wiki_title: How to Connect to SPICE Console With Portal
wiki_revision_count: 14
wiki_last_updated: 2013-10-02
---

# How to Connect to SPICE Console With Portal

This article will explain how to connect to a SPICE console from either the User or Admin Portal using the SPICE Remote-Viewer Client/ActiveX Plugin.

## Under the Hood

So what happens when you hit the "Console" button?

1.  ovirt-engine sets a new password and it's expiry time (by default 120 s) which compose together a ticket
2.  ovirt-engine looks up other connection details (more on them later) in its database
3.  ovirt-engine passes all the connection info to the portal
4.  portal sets variables on spice-xpi object
5.  spice-xpi launches spice client and passes variables to it via unix socket
6.  spice client connects directly to a host using data given to it by the portal

## Assupmtions and Prerequisities

*   An installed and running instance of ovirt-engine See: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)
*   One or two nodes within an active cluster, EL6 or Fedora nodes are both fine.
*   You are connecting from a Windows based Box/VM.
*   You are running
