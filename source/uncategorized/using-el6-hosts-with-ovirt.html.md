---
title: Using EL6 hosts with Ovirt
authors: deadhorseconsulting, sandrobonazzola
wiki_title: Using EL6 hosts with Ovirt
wiki_revision_count: 16
wiki_last_updated: 2014-09-26
---

# Using EL6 hosts with Ovirt

How to use EL6 based hosts with Ovirt-Engine 3.1+

## Assupmtions and Prerequisities

*   An installed and running instance of ovirt-engine See: [Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)
*   A system or VM loaded with some flavor of EL6 EG: RHEL, CentOS, SL, OEL (Best practice is to use the one you intend to use for the node)
    -   At minimum the following from the Development package group should be installed:
        -   Development tools
        -   Additional Development
        -   Server Platform Development
*   An active webserver to host a package repository and the kickstart (EG: An EL6 or Fedora box with httpd loaded and running)

## Building the Needed Packages

*   Some packages need to be built which will work with and are needed for VDSM
*   Some of these packages are not yet in EL6 or out of date for what upstream VDSM requires
*   Tend to stick with newer versions to match upstream VDSM

### Building logrotate

*   Start by pulling the latest logrotate source rpm from the Fedora 17 stable or updates repositories (use the newest)
*   Optionally if you don't mind living on the edge a bit you can pull the newest logrotate source RPM from the Rawhide repositories
*   PackageName: logrotate-<version>.fc<releasever>.src.rpm
*   The following packages are BuildRequires for logrotate
    -   libselinux-devel
    -   popt-devel
    -   libacl-devel
*   To build logrotate:

       rpmbuild --rebuild logrotate-`<version>`.fc`<releasever>`.src.rpm

*   Resulting RPMS:
    -   logrotate-<version>.el6.x86_64.rpm
    -   logrotate-debuginfo-<version>.el6.x86_64.rpm

### Building sanlock

*   Start by pulling the latest sanlock source rpm from the Fedora 17 stable or updates repositories (use the newest)
*   Optionally if you don't mind living on the edge a bit you can pull the newest sanlock source RPM from the Rawhide repositories
*   PackageName: sanlock-<version>.fc<releasever>.src.rpm
*   The following packages are BuildRequires for sanlock
    -   libblkid-devel
    -   libaio-devel
    -   python python-devel
*   To build logrotate:

       rpmbuild --rebuild sanlock-`<version>`.fc`<releasever>`.src.rpm

*   Resulting RPMS:
    -   sanlock-<version>.el6.x86_64.rpm
    -   sanlock-debuginfo-<version>.el6.x86_64.rpm
    -   sanlock-devel-<version>.el6.x86_64.rpm
    -   sanlock-lib-<version>.el6.x86_64.rpm
    -   sanlock-python-<version>.el6.x86_64.rpm

### Building Glusterfs

### Building VDSM
