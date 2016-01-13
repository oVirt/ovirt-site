---
title: Update
authors: fabiand
wiki_title: Node/4.0/Update
wiki_revision_count: 8
wiki_last_updated: 2016-01-13
---

# Update

## Delivery (DRAFT)

oVirt Node Next updates will be delivered as squashfs images inside an rpm.

### Problem

The following build process needs to be considered:

1.  oVirt packages a re built, including ovirt-release and it's subpackages (build: V.R)
2.  oVirt Node Next squashfs image is build (build: V.R.builddate)
3.  oVirt Node Next squashfs-wrapper-rpm is build (build: V.R.builddate)

The build order is important, because it defines the available builds (version and release).

### Design

The upgrade is designed a couple of rpm packages and well defined requirements.

Packages:

*   ovirt-release (already existing)
    -   ovirt-node-ng-image-placeholder-V.R (new subpackage)
        -   Placeholder for a subsequent image update

<!-- -->

*   ovirt-node-ng-image-V.R (new package)
    -   Wraps the squashfs image
    -   Obsoletes: ovirt-node-ng-image-placeholder < V.R
    -   Post will setup the new image on the host

### Flow

Let's do a brain experiment and imagine the following release:

#### Build: Release 3.6.0

*   N = 3.6.0-20160101.0
*   build ovirt-release-N
    -   ovirt-node-ng-image-placeholder-N
*   build ovirt-node-ng N (squashfs)
    -   Consumes ovirt-release-N and ovirt-node-ng-image-placeholder-N
*   build ovirt-node-ng-image-N (wrapper)
    -   Consumes ovirt-node-ng N (squashfs)

#### Install: Release 3.6.0

*   install ovirt-node-ng N (squashfs)
    -   on a host by anaconda

#### Build: Release 3.6.1

*   M = 3.6.1-20160202.0
    -   M > N
*   build ovirt-release-M
    -   ovirt-node-ng-image-placeholder-M
*   build ovirt-node-ng M (squashfs)
    -   Consumes ovirt-release-M and ovirt-node-ng-image-placeholder-M
*   build ovirt-node-ng-image-M (wrapper)
    -   Consumes ovirt-node-ng M (squashfs)

#### Update: Release 3.6.1 (placeholder to image update)

*   Run `yum update` on the host
*   On host:
    -   ovirt-node-ng 3.6.0-20160101.0 (image)
    -   rpm: ovirt-node-ng-image-placeholder-3.6.0-20160101.0
*   In yum repository:
    -   ovirt-node-ng-image-3.6.1-20160202.0 (wrapper)

<!-- -->

*   Yum logic:
    -   new ovirt-node-ng-image-3.6.1-20160202.0 (wrapper) obsoletes ovirt-node-ng-image-placeholder < 3.6.1-20160202.0
        -   obsoletes ovirt-node-ng-image-placeholder-3.6.0-20160101.0
    -   remove: ovirt-node-ng-image-placeholder-3.6.0-20160101.0
    -   install: ovirt-node-ng-image-3.6.1-20160202.0 (wrapper)

#### Build: Release 3.6.2

*   P = 3.6.2-20160303.0
    -   P > M > N
*   build ovirt-release-P
    -   ovirt-node-ng-image-placeholder-P
*   build ovirt-node-ng P (squashfs)
    -   Consumes ovirt-release-P and ovirt-node-ng-image-placeholder-P
*   build ovirt-node-ng-image-P (wrapper)
    -   Consumes ovirt-node-ng P (squashfs)

#### Update: Release 3.6.2 (image to image update)

*   Run `yum update` on the host
*   On host:
    -   ovirt-node-ng 3.6.1-20160202.0 (image)
    -   rpm: ovirt-node-ng-image-3.6.1-20160202.0
*   In yum repository:
    -   ovirt-node-ng-image-3.6.2-20160303.0 (wrapper)

<!-- -->

*   Yum logic:
    -   new ovirt-node-ng-image-3.6.2-20160303.0 (wrapper) is newer than ovirt-node-ng-image-3.6.1-20160202.0
    -   remove: ovirt-node-ng-image-3.6.1-20160202.0
    -   install: ovirt-node-ng-image-3.6.2-20160303.0 (wrapper)

### Resources

*   Specfile: TBD
*   Original design: <http://etherpad.ovirt.org/p/bLjanV30Dw>
