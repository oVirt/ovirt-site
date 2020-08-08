---
title: NFSv4
category: feature
authors: derez, ecohen, ekohl, sandrobonazzola, smizrahi
feature_name: NFSv4
feature_modules: engine/vdsm
feature_status: Released
---

# NFSv4

# Summary

VDSM will allow NFS domains to be accessed with the 4th version of the NFS protocol

# Current Status

To do:

*   Make needed change in Ovirt-Engine
*   Make needed change in the GUIs

Done:

*   Make needed changes in VDSM

# Description

Currently VDSM only supports NFS version 3. Once this change is introduced VDSM will enable if client and server both support
NFSv4 for domains to be accessed this way. By default VDSM will let the NFS protocol decide what is the optimal version to use.
In some cases the user might want to prevent VDSM from accessing the the server with version 4. In order to accommodate that
a new optional parameter has been introduced to the type specific arg dictionary to allow specifying a version manually.

# Dependency

None

# Related Features

# Affected Functionality

*   NFS connection creation

# User Experience

see GUI mock-up in "Advanced NFS Options" wiki page at:
[Features/AdvancedNfsOptions#User Experience](/develop/release-management/features/storage/advancednfsoptions.html#user-experience)

# Upgrade

None

# How to use

This **should not** be specified under normal use and VDSM should be allowed to decide the appropriate values.
The new connection specific argument is:

*   **version** - *Optional*, *integer* - The NFS protocol version number used to contact the server's NFS service. If the server does not support the requested version, the mount request fails. If this option is not specified, the client negotiates a suitable version with the server, trying version 4 first, version 3 second.

# User work flows

The user should be able to set a value after being aptly warned.

