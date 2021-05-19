---
title: AdvancedNfsOptions
category: feature
authors: derez, ecohen, ekohl, lhornyak, smizrahi
---

# Advanced Nfs Options

# Summary

Allows advanced users to override some of VDSM default nfs options

# Current Status

To do:

*   [Make needed change in Ovirt-Engine](#changes-in-ovirt-engine)
*   Make needed change in the GUIs

Done:

*   Make needed changes in VDSM <http://gerrit.ovirt.org/#change,1038>

# Description

Currently VDSM has a default value for NFS timeouts, these are made to strike a good balance considering most common networking infrastructures and demands. Some client might be more tolerable to intermittant network interruptions or, on the other hand, less accepting of io stopping timeouts. For these kind of advanced users VDSM now accepts 2 new optional arguments in the NFS type specific arguemnts.

# Dependency

None

# Related Features

# Affected Functionality

*   NFS connection creation

# User Experience

![](/images/wiki/Nfsoptionsnewdomaindialog.png)

![](/images/wiki/Nfsoptionsnewdomaindialogadvanced.png)

# Upgrade

None

# How to use

The new connection specific arguments are:

These **should not** be specified under normal use and VDSM should be allowed to decide the appropriate values.

*   **retrans** - *Optional*, *integer* - The number of times the NFS client retries a request before it attempts further recovery action.
*   **timeout** - *Optional*, *integer* - The time in deciseconds (tenths of a second) the NFS client waits for a response before it retries an NFS request.

# User work flows

The user should be able to set these values after being aptly warned.

# Changes in ovirt engine

This part is for the backend.

*   add new String property mountOptions to storage_domains_static entity, default value should be set to null, delegate methods to the storage_domains entity
*   database changes
    -   add new column mount_options to default value should be set to null
    -   update add new parameter to Insertstorage_domains, Updatestorage_domains
*   add validation logic of the values to StorageDomainManagementCommandBase (?: which optione are accepted and what not)
*   add new parameters wherever it is passed over by vdsbroker to vdsm

