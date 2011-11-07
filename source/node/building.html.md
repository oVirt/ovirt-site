---
title: Node Building
category: node
authors: dcaroest, dougsland, fabiand, mburns, pmyers, quaid, rbarry
wiki_category: Node
wiki_title: Node Building
wiki_revision_count: 36
wiki_last_updated: 2015-01-28
---

# Node Building

## Build Process for oVirt Node

Note: This is a draft and still very much a work in progress.

Currently, we're heavily reliant on Fedora.

### Get the Source

Use git

`$ git clone --no-checkout git://git.fedorahosted.org/ovirt/node.git

$ cd node

$ git checkout --track origin/devel`

### Setup a Build Environment

*   Recommend minimum F15 build host
    -   Otherwise there are problems with systemd and building
*   Create an ovirt-cache directory (defaults to ~/ovirt-cache
*   Create an RPM build environment
    -   If not running on the version of Fedora you want to build with, create a ~/.rpmmacros file with
        -   %dist .fc16
        -   %fedora 16
    -   If you're on the right version, then no need for .rpmmacros
    -   Create directory structure
        -   <code>$ BASEDIR=$(rpm --eval %_topdir) #to get base rpmbuild directory
        -   mkdir -p $BASEDIR/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}</code>
*   set OVIRT_CACHE_DIR and OVIRT_LOCAL_REPO environment variables
    -   <code> $ export OVIRT_CACHE_DIR=~/ovirt-cache
    -   $ export OVIRT_LOCAL_REPO=${BASEDIR}/RPMS </code>

### Install Dependencies

*   You will need (at least):
    -   at least sudo access to livecd-creator (preferably passwordless)
    -   livecd-tools
    -   appliance-tools-minimizer
    -   rpm-build
    -   createrepo

### Build ovirt-node packages

*   go to base ovirt-node location
*   <code> $ ./autogen.sh --with-image-minimizer
*   $ make
*   rm \*tar.gz
*   make dist
*   EXTRA_RELEASE=.$USER$(date +%s)
*   rpmbuild --nodeps --define "extra_release $EXTRA_RELEASE" -ta --clean \*.tar.gz

</code>

### Workarounds for RPMs not included in Fedora

*   cd to your rpmbuild/RPMS/x86_64 directory
*   copy all separate rpms there
*   in the RPMS directory, run `$ createrepo .`

**IMPORTANT NOTE**

*   There are currently 2 known overrides that need to be applied
    -   Need to use a custom grub2 package until it gets into fedora
        -   [Bug 746394](https://bugzilla.redhat.com/show_bug.cgi?id=746394)
        -   rpms are under [here](http://goldmann.fedorapeople.org/bz/746394)
    -   VDSM rpms are not available in Fedora yet
        -   Need to pull them down for ovirt-node to use
        -   [RPM Location](http://fsimonce.fedorapeople.org/vdsm/)
*   Download the packages from these locations and add them to the RPMS/x86_64 directory and re-run createrepo

### Build the image

`

* $ cd recipe
* $ make ovirt-node-image.iso

`

[Category: Node](Category: Node)
