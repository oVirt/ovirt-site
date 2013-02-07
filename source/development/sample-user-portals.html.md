---
title: Sample user portals
category: development
authors: dneary, ovedo, shaharh
wiki_category: Development
wiki_title: Sample user portals
wiki_revision_count: 9
wiki_last_updated: 2013-02-07
---

# Sample user portals

Samples Portals repository is hosted in gerrit:

*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=java>
*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=python>
*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=ruby>

and contain examples on using the oVirt SDK in order to develop a basic User Portal. The basic idea is to show how simple it is to use the oVirt SDK to support the following operations:

*   Login
*   Logout
*   Start VM
*   Stop VM
*   Connect to VM console
*   Get VM status
*   Show VM display type (SPICE/VNC)

The portals are using the user-level API.

Currently we created examples in three different languages, Java, Python and Ruby.

*   The Java portal is using the oVirt Java SDK:

<http://www.ovirt.org/Java-sdk>

*   The Python portal is using the oVirt Python SDK:

<http://www.ovirt.org/Python-sdk>

*   Ruby currently don't have oVirt SDK, so in the Ruby portal we are using rbovirt, which contains partial REST bundings to basic operations. You can find it in:

<https://github.com/abenari/rbovirt>

The Portals enable user to connect to VM via SPICE under Firefox or Internet Explorer. In order to start a SPICE session we need to set a ticket for the VM (SDK call), the ticket is the spice password, We also need the host IP and port which provided via the display entity (a property of VM).
