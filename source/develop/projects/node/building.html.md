---
title: Node Building
category: node
authors: dcaroest, dougsland, fabiand, mburns, pmyers, quaid, rbarry
---

# Node Building

## Build Process for oVirt Node

Currently, we're heavily reliant on Fedora. The build process consists of two phases:

1.  Building the *ovirt-node* packages
2.  Building the ISO image using Fedora packages and the previously build *ovirt-node* packages

### From Git

#### Get the Source

The code resides in [oVirt's gerrit](http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=summary) and can be pulled using git:

    # The ovirt-node package, which contains Node specififc code, TUI and tools
    $ git clone http://gerrit.ovirt.org/p/ovirt-node.git

    # This package is used to build the ISO
    $ git clone http://gerrit.ovirt.org/p/ovirt-node-iso.git

    # Let's operate from this base
    $ export OVIRT_NODE_BASE=$PWD

#### Setup a Build Environment

*   Recommend minimum F18 build host
    -   Otherwise there are problems with systemd, selinux, ...
*   Create an ovirt-cache directory (defaults to ~/ovirt-cache
*   Create an RPM build environment
    -   If you're on the right version, then no need for .rpmmacros
    -   If not running on the version of Fedora you want to build with, create a ~/.rpmmacros file with
        -   %dist .fc18
        -   %fedora 18
*   set `OVIRT_CACHE_DIR` and `OVIRT_LOCAL_REPO` environment variables
    -   ` $ export OVIRT_CACHE_DIR=~/ovirt-cache`
    -   ` $ export OVIRT_LOCAL_REPO=file://${OVIRT_CACHE_DIR}/ovirt `

#### Install Dependencies

You will need (at least):

*   -   sudo access to livecd-creator (preferably passwordless)
    -   In addition, all packages listed under [Exceptions](http://fedoraproject.org/wiki/Packaging:Guidelines#Exceptions_2) in the Fedora Packaging guidelines should also be installed.

This boils (on a fresh and minimal Fedora 18) down to:

    $ visudo
    $ yum install livecd-tools appliance-tools-minimizer fedora-packager python-devel rpm-build createrepo \
      selinux-policy-doc checkpolicy selinux-policy-devel hardlink autoconf ltrace automake python-mock pykickstart python-lockfile

#### Build ovirt-node packages

Now that the source and build environment is setup you can build the *ovirt-node* packages:

    # Go to base ovirt-node location
    $ cd $OVIRT_NODE_BASE
    $ cd ovirt-node

    # Optional: Do any changes you want and commit them (important)
    $ edit some/file.py
    $ commit -as

    # EXTRA_RELEASE is picked up by ovirt-node's build system
    # Needs to be adjusted for an official build
    # Also, you may need to tweak this if you have an invalid character in your user name (like - )
    $ export EXTRA_RELEASE=.$USER$(date +%s)

    $ ./autogen.sh --with-image-minimizer

    # Copies the packages to $OVIRT_CACHE_DIR (FIXME or $OVIRT_LOCAL_REPO?)
    $ make publish

#### Workarounds for RPMs not included in Fedora

Sometimes some packages are missing in Fedora's official repos (e.g. because they are not yet released or generally not available in Fedora). If this is the case the following workaround can be used to include the packages in oVirt Node:

    # Go into the local package cache
    $ cd $OVIRT_CACHE_DIR/ovirt

    # Copy all custom packages into the cache
    $ cp -v /path/with/custom/rpms/*.rpm .

    # Recreate the repodata
    $ createrepo .

#### Build the image

Now that the *ovirt-node* package and (optional) other 3rd party packages are in place, we can build the ISO:

    $ cd $OVIRT_NODE_BASE
    $ cd ovirt-node-iso

    # /path/to/ovirt-node/recipe/directory is typically $OVIRT_NODE_BASE/ovirt-node/recipe
    $ ./autogen.sh --with-recipe=/path/to/ovirt-node/recipe/directory --with-build-number=<build_number>

    # Build and compress the iso
    $ make iso publish

Variables:

*   --with-recipe
    -   defaults to /usr/share/ovirt-node-tools
    -   not needed if ovirt-node-tools rpm is installed
    -   otherwise point to ovirt-node/recipe
*   --with-build-number
    -   Will set the XX value in the following NVR
    -   ovirt-node-iso-2.3.0-1.XX.fc16
    -   Can be overridden at in the make iso and/or make publish steps by adding BUILD_NUMBER=<buildnumber>

## Jenkins / Nightly Builds

The oVirt project is using [Jenkins](http://www.jenkins-ci.org) for CI.

There are [several jobs related to Node](http://jenkins.ovirt.org/view/Master%20branch%20per%20project/view/ovirt-node/) which also build per-commit and nightly builds.

## Adding a plugin to a build

Plugins are a way to extend oVirt Node ISOs. To add a plugin to an existing image proceed like this:

1.  Prepare or get the plugin rpm
2.  Download the prepared repo files
    1.  fedora: <http://resources.ovirt.org/releases/node-base/edit-node.repo>
    2.  el6: <http://resources.ovirt.org/releases/node-base/edit-node-el6.repo>

3.  Edit the ISO using \`edit-node\`:
    1.  \`ovirt-node/tools/edit-node --repo edit-node.repo --install <package-name> <iso-name>\`

**Note**: \`edit-node\` must be run on the same OS which is used within the image. So an Fedora image must be edited on a Fedora host.

<!-- -->

    $ ovirt-node/tools/edit-node \
        --repo edit-node.repo \
        --install ovirt-node-plugin-vdsm \
        ovirt-node-iso-3.0.2-1.0.0.fc19.iso

## Where to go from now

Now that you've got an oVirt Node ISO you can use

*   [Deploy it with PXE](/develop/projects/node/pxe/) to get it onto real hardware or into a VM for testing purposes
*   [Node plugins](/develop/release-management/features/node/plugins/) to add 3rd party plugins
*   [Use igor](/develop/projects/node/automation/) to setup automated tests for oVirt Node in your environment
*   [Contribute](/develop/projects/node/contributing-to-the-node-project/) to make Node even more solid

