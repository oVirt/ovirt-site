---
title: oVirtAppliance
category: feature
authors: didi, doron, fabiand, mgoldboi, obasan
wiki_category: Feature
wiki_title: Feature/oVirtAppliance
wiki_revision_count: 14
wiki_last_updated: 2014-11-03
feature_name: oVirt Appliance
feature_modules: node
feature_status: In Progress
---

# oVirt Appliance

# Summary

oVirt appliance will be a raw disk or an ova file that you can import to your existing virtual machine manager and boot it with a complete pre installed oVirt setup.

The first step will be to create an image with the correct functionality, in a second step the correct delivery format will be choosen. The latter might be currently blocked by the missing functionality in the build tools.

# Owner

*   Name: [ Fabian Deutsch](User:fabiand)
*   Email: fabiand@redhat.com
*   Tracker <https://bugzilla.redhat.com/show_bug.cgi?id=1053435>
*   Gitweb: <http://gerrit.ovirt.org/gitweb?p=ovirt-appliance.git>

# Current status

In Development.

# Details

*   The appliance will be created using the [livemedia-creator](https://fedorahosted.org/lorax/) - later probably using [image-factory](http://imgfac.org/).
    -   Reasoning behind this is, that these tools are maintained and support different platforms.
*   The platform will be either Fedora or CentOS.
*   Configuration
    -   Engine installed and preconfigured
    -   Desktop environment including a webbrowser
    -   Sysprep'ed to be consumable as an appliance

<Category:Feature> <Category:SLA>
