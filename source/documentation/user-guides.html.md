---
title: User Guides
category: documentation
authors: bproffitt, dneary, quaid, sgordon
wiki_category: Documentation
wiki_title: User Guides
wiki_revision_count: 34
wiki_last_updated: 2014-11-25
---

# User Guides

This page is intended to be the root of the oVirt documentation project. This will ultimately include links to the documentation as well as instructions for those wishing to contribute.

## License

Documentation is Copyright Ⓒ 2012 oVirt Project.

Licensed under the Apache License, Version 2.0 (the "License"). A copy of the License is included in this documentation; in addition, you may obtain a copy of the License at:

<http://www.apache.org/licenses/LICENSE-2.0>

## Guides

[Installation Guide](:File:OVirt-3.0-Installation_Guide-en-US.pdf)

## Source Control

The documentation subproject has a git repository. Like the other oVirt git repositories it is managed using Gerrit. Follow the [ instructions for registering with and using Gerrit](Working with oVirt Gerrit), then use the git clone command to get a local copy of the repository:

      $ git clone gerrit.ovirt.org:ovirt-docs

The git repository is intended to be used for the creation and maintenance of formal documentation for the project. At this time all formal documentation for the project is written in DocBookXML and turned into PDF, HTML, HTML-SINGLE, and EPUB output using [publican](https://fedorahosted.org/publican/).

## Brand

The [publican-ovirt](http://koji.fedoraproject.org/koji/packageinfo?packageID=6970) brand is used to build the oVirt documentation. It is recommended that before building oVirt documentation you download and install this brand to ensure consistent theming. Users of Fedora 15, Fedora 16, and Fedora 17, may obtain the brand by running:

         # yum install publican-ovirt

Alternatively the RPMs are available for download in [koji](http://koji.fedoraproject.org/koji/packageinfo?packageID=6970). These are also expected to work on RHEL and derivative operating systems.

Users of other operating systems for which publican is available may obtain the source to the brand from the [publican git repository](http://git.fedorahosted.org/git/?p=publican.git;a=tree;f=publican-ovirt;h=3d2102770380957804b86a543d4d021e816c20f7;hb=HEAD). Once a local copy of the brand source has been created, follow the instructions in the [Publican User Guide](http://jfearn.fedorapeople.org/en-US/Publican/2.6/html/Users_Guide/chap-Users_Guide-Branding.html#sect-Users_Guide-Installing_a_brand) to build and install the brand.

## Reference Material

Reference material includes any appropriately licensed information considered a useful reference for more formal documentation activity.

### Overview

*   [oVirt architecture deep dive](oVirt architecture deep dive)

### Engine

*   [Build & Install RPM](Build & Install RPM)
*   [Building oVirt engine](Building oVirt engine)
*   [Installing PostgreSQL DB](Installing PostgreSQL DB)
*   [Working with gerrit.ovirt.org](Working with gerrit.ovirt.org)

### Node

*   [Node Building](Node Building)

### VDSM

*   [Vdsm Getting Started](Vdsm Getting Started)
*   [Vdsm](Vdsm)
*   [Vdsm_Developers](Vdsm_Developers)
*   [Vdsm_Log_Files](Vdsm_Log_Files)
*   [Vdsm_Storage_Terminology](Vdsm_Storage_Terminology)

### Reports and Data Warehouse

*   [How to setup a oVirt DWH development environment](How to setup a oVirt DWH development environment)
*   [How to setup a oVirt Reports development environment](How to setup a oVirt Reports development environment)
*   [Ovirt DWH](Ovirt DWH)

<Category:Documentation>
