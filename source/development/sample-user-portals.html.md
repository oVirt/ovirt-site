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

Sample Portals show how to login view start/stop and connect to VMs via the Spice protocol. The basic idea is to show the oVird SDK simplicity usage and the ability to integrate them into existing projects/portals. The portals are using the user level API which allow session non admin user.

Currently we have the 3 languages: Java, Python and Ruby.

Java is using the oVirt Java SDK: <http://www.ovirt.org/Java-sdk>

Python is using the oVird Python SDK: <http://www.ovirt.org/Python-sdk>

Ruby currently don't have oVirt SDK, we are using a RESTful wrapper project called rbovirt: <https://github.com/abenari/rbovirt>

Samples Protals are hosted in gerrit:

*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=java>
*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=python>
*   <http://gerrit.ovirt.org/gitweb?p=samples-portals.git;a=tree;f=ruby>

Login/start/stop Vms is strait forward SDK calls The Portals enable user to connect to VM via Spice under Firefox or Internet Explorer. In order to start Spice we need to set a ticket for the VM (SDK call), the ticket is the spice password, We also need the host IP and port which provided via the display entity (a property of VM).
