---
title: Update
authors: fabiand
---

# Update

## Overview

oVirt Node Next updates will be delivered as squashfs images inside an wrapper-rpm.

The wrapper rpm will be used to deliver the image to the host and to perform the actual upgrade on the host.

## User stories

**NOTE: The UI has not yet been designed, this topic is under research**

### Update

*   A User logs in to Cockpit, sees in the 'System' tab that there's an exclamation mark.
*   When he clicks there, it shows 'update is available - would you like to update now?' dialog.
*   If he clicks yes, a dialog opens up with a progress bar:
    -   Downloading new image
    -   Updating
*   When it's done - either:
    -   "VMs are running on this host - please switch to to maintenance before rebooting"
    -   Press 'Reboot' to reboot the host into the updated image

### Rollback

TBD

## Technical: Delivery

This section is discussing how the delivery of the wrapper rpm works.

### Problem

The basic problem is: How do we get an wrapper rpm to an installed Node.

#### Considerations

When designing the update process, we need to consider the availability of all packages at each point in time.

The following build process - roughly to what is happening during an upstream release - needs to be considered:

1.  oVirt Release Compose (independent of Node)
    1.  oVirt packages a re built, including ovirt-release and it's subpackages (build: V.R)

2.  oVirt Node Compose (specific to node)
    1.  oVirt Node Next squashfs image is build (build: V.R.builddate)
    2.  oVirt Node Next squashfs-wrapper-rpm is build (build: V.R.builddate)

Ideally this currently split compose can be one in future.

### Design

The basic idea is: Use a placeholder inside the squashfs which will later be replaced by the wrapper rpm. Afterwards the updates will be just updating the wrapper rpms.

Packages:

*   `ovirt-release` (already existing)
    -   `ovirt-node-ng-image-placeholder-V.R` (new subpackage)
        -   This subpackage is at best in the `ovirt-release` package, because this will ensure that this package is available when the image is build.
        -   If this package was a subpackage of the `ovirt-node-ng-image` package, then we'd have the problem that we can not include the build N in an image N, because the `ovirt-node-ng-image` package is build 'after' the image N was built.
        -   Placeholder for a subsequent image update

<!-- -->

*   `ovirt-node-ng-image-V.R` (new package)
    -   Wraps the squashfs image
    -   Obsoletes: `ovirt-node-ng-image-placeholder < V.R`
    -   Post will setup the new image on the host

### Flow

We need to distinguish between two cases:

*   Initial update: Update form placeholder to wrapper
*   Subsequent updates: Update from wrapper to wrapper

Let's do a brain experiment and imagine the following release:

#### Build: Release 3.6.0

*   `N = 3.6.0-20160101.0`
*   build `ovirt-release-N`
    -   `ovirt-node-ng-image-placeholder-N`
*   build `ovirt-node-ng N` (squashfs)
    -   Consumes `ovirt-release-N` and `ovirt-node-ng-image-placeholder-N`
*   build `ovirt-node-ng-image-N` (wrapper)
    -   Consumes`ovirt-node-ng N` (squashfs)

#### Install: Release 3.6.0

*   install `ovirt-node-ng N` (squashfs)
    -   on a host by anaconda

#### Build: Release 3.6.1

*   `M = 3.6.1-20160202.0`
    -   M > N
*   build `ovirt-release-M`
    -   `ovirt-node-ng-image-placeholder-M`
*   build `ovirt-node-ng M` (squashfs)
    -   Consumes `ovirt-release-M` and `ovirt-node-ng-image-placeholder-M`
*   build `ovirt-node-ng-image-M` (wrapper)
    -   Consumes `ovirt-node-ng M` (squashfs)

#### Update: Release 3.6.1 (placeholder to wrapper update)

*   Run `yum update` on the host
*   On host:
    -   `ovirt-node-ng 3.6.0-20160101.0` (image)
    -   rpm: `ovirt-node-ng-image-placeholder-3.6.0-20160101.0`
*   In yum repository:
    -   `ovirt-node-ng-image-3.6.1-20160202.0` (wrapper)

<!-- -->

*   Yum logic:
    -   new `ovirt-node-ng-image-3.6.1-20160202.0` (wrapper) obsoletes `ovirt-node-ng-image-placeholder < 3.6.1-20160202.0`
        -   obsoletes `ovirt-node-ng-image-placeholder-3.6.0-20160101.0`
    -   remove: `ovirt-node-ng-image-placeholder-3.6.0-20160101.0`
    -   install: `ovirt-node-ng-image-3.6.1-20160202.0` (wrapper)

#### Build: Release 3.6.2

*   `P = 3.6.2-20160303.0`
    -   P > M > N
*   build `ovirt-release-P`
    -   `ovirt-node-ng-image-placeholder-P`
*   build `ovirt-node-ng P` (squashfs)
    -   Consumes `ovirt-release-P` and `ovirt-node-ng-image-placeholder-P`
*   build `ovirt-node-ng-image-P` (wrapper)
    -   Consumes `ovirt-node-ng P` (squashfs)

#### Update: Release 3.6.2 (wrapper to wrapper update)

*   Run `yum update` on the host
*   On host:
    -   `ovirt-node-ng 3.6.1-20160202.0` (image)
    -   rpm: `ovirt-node-ng-image-3.6.1-20160202.0`
*   In yum repository:
    -   `ovirt-node-ng-image-3.6.2-20160303.0` (wrapper)

<!-- -->

*   Yum logic:
    -   new `ovirt-node-ng-image-3.6.2-20160303.0` (wrapper) is newer than `ovirt-node-ng-image-3.6.1-20160202.0`
    -   remove: `ovirt-node-ng-image-3.6.1-20160202.0`
    -   install: `ovirt-node-ng-image-3.6.2-20160303.0` (wrapper)

### Resources

*   Specfile: TBD
*   Original design: <http://etherpad.ovirt.org/p/bLjanV30Dw>

## Technical: TBD - Image upgrade

This section discusses how the on disk image will be uprgaded.

## Technical: TBD - Rollback

This section will discuss how the rollback works
