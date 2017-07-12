---
title: Sample user portals
category: development
authors: dneary, ovedo, shaharh
---

# Sample user portals

Shahar Havivi (Shaharh) has developed a series of sample user portals, using the oVirt SDK, in Java, Python and Ruby, to give you an idea of what is possible with SDK bindings, and how to use them in various languages.

The sample portals repository is hosted in gerrit, and contains the same portal written in three different languages:

*   [Java](http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=java)
*   [Python](http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=python)
*   [Ruby](http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=ruby)

You can use this code as a guide to using the oVirt SDK, and a basis for the development of a basic User Portal.

The idea is to show how simple it is to use the oVirt SDK to support the following operations:

*   Login
*   Logout
*   Start VM
*   Stop VM
*   Connect to VM console
*   Get VM status
*   Show VM display type (SPICE/VNC)

![](/images/wiki/VMsSapmlesPortal.png)

The portals build on the user-level API.

The different versions of the portal use language bindings for the appropriate language:

*   [oVirt Java SDK](/develop/release-management/features/infra/java-sdk/)
*   [oVirt Python SDK](/develop/release-management/features/infra/python-sdk/)
*   Ruby currently does not have a separate oVirt SDK, we use [rbovirt](https://github.com/abenari/rbovirt), which contains partial REST bindings to basic operations.

## Enabling SPICE console connections

The Portals enable user to connect to VM via SPICE under Firefox or Internet Explorer. In order to start a SPICE session we need to set a ticket for the VM (SDK call), the ticket is the spice password. We also need the host IP and port which provided via the display entity (a property of VM).

## Ticket and Display details in Firefox

![](/images/wiki/SpiceJavascript.png)

For more details refer to the README file in each Sample Portal directory

