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

Currently, we're heavily reliant on Fedora.

### From Git

#### Get the Source

Use git

`$ git clone http://gerrit.ovirt.org/p/ovirt-node.git

$ cd ovirt-node`

#### Setup a Build Environment

*   Recommend minimum F15 build host
    -   Otherwise there are problems with systemd and building
*   Create an ovirt-cache directory (defaults to ~/ovirt-cache
*   Create an RPM build environment
    -   If not running on the version of Fedora you want to build with, create a ~/.rpmmacros file with
        -   %dist .fc16
        -   %fedora 16
    -   If you're on the right version, then no need for .rpmmacros
*   set OVIRT_CACHE_DIR and OVIRT_LOCAL_REPO environment variables
    -   <code> $ export OVIRT_CACHE_DIR=~/ovirt-cache
    -   $ export OVIRT_LOCAL_REPO=<file://>${OVIRT_CACHE_DIR}/ovirt </code>

#### Install Dependencies

*   You will need (at least):
    -   at least sudo access to livecd-creator (preferably passwordless)
    -   livecd-tools
    -   appliance-tools-minimizer
    -   rpm-build
    -   createrepo

#### Build ovirt-node packages

*   go to base ovirt-node location
*   <code> $ ./autogen.sh --with-image-minimizer
*   EXTRA_RELEASE=.$USER$(date +%s)
    -   Not required if you're building an official build
    -   Also, you may need to tweak this if you have an invalid character in your user name (like - )
*   $ make publish

</code>

#### Workarounds for RPMs not included in Fedora

*   cd to your rpmbuild/RPMS directory
*   copy all separate rpms there
*   in the RPMS directory, run `$ createrepo .`

**IMPORTANT NOTE**

*   There is currently 1 known override that needs to be applied
    -   VDSM rpms are not available in Fedora yet
        -   Need to pull them down for ovirt-node to use
        -   [RPM Location](http://fsimonce.fedorapeople.org/vdsm/)
*   Download the packages from these locations and add them to the RPMS/x86_64 directory and re-run createrepo

#### Build the image

`

* $ cd recipe
* $ make ovirt-node-image.iso

`

### From -tools RPM

*   Install ovirt-node-tools RPM from Fedora or ovirt.org/releases
*   `$ cd usr/share/ovirt-node-tools`
*   Create a version.ks file (automation coming soon)
    -   Content like the following:

      PRODUCT='oVirt Node Hypervisor'
      PRODUCT_SHORT='oVirt Node Hypervisor'
      PACKAGE=ovirt-node-image
      Version=2.1
      RELEASE=0.fc16

*   Follow steps above for RPMs not included in Fedora
    -   Put all RPMs in a single location
    -   run createrepo on that location
    -   export OVIRT_LOCAL_REPO=<file://><your_location>
*   `$ sudo node-creator ovirt-node-image.ks`

<Category:Node> <Category:Documentation>
