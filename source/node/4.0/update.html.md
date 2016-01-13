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
    -   ovirt-node-ng-image-placeholder-V.R
        -   A new subpackage
*   ovirt-node-ng-image-V2.R2
    -   A new package
    -   Wraps the squashfs image
    -   Obsoletes: ovirt-node-ng-image-placeholder < V.R

### Resources

*   Specfile: TBD
*   Original design: <http://etherpad.ovirt.org/p/bLjanV30Dw>
