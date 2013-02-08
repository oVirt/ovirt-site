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

$ git clone http://gerrit.ovirt.org/p/ovirt-node-iso.git

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
    -   python-devel
    -   In addition, all packages listed under [Exceptions](http://fedoraproject.org/wiki/Packaging:Guidelines#Exceptions_2) in the Fedora Packaging guidelines should also be installed.

#### Build ovirt-node packages

*   go to base ovirt-node location
*   <code> $ ./autogen.sh --with-image-minimizer
*   EXTRA_RELEASE=.$USER$(date +%s)
    -   Not required if you're building an official build
    -   Also, you may need to tweak this if you have an invalid character in your user name (like - )
*   $ make publish

</code>

#### Workarounds for RPMs not included in Fedora

*   cd to your OVIRT_CACHE/ovirt directory
*   copy all separate rpms there
*   in the RPMS directory, run `$ createrepo .`

#### Build the image

`

$ cd ../ovirt-node-iso

$ ./autogen.sh --with-recipe=/path/to/ovirt-node/recipe/directory --with-build-number=<build_number>

$ make iso publish

`

Variables

*   --with-recipe
    -   defaults to /usr/share/ovirt-node-tools
    -   not needed if ovirt-node-tools rpm is installed
    -   otherwise point to ovirt-node/recipe
*   --with-build-number
    -   Will set the XX value in the following NVR
    -   ovirt-node-iso-2.3.0-1.XX.fc16
    -   Can be overridden at in the make iso and/or make publish steps by adding BUILD_NUMBER=<buildnumber>

<Category:Node> <Category:Documentation>
