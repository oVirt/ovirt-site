---
title: Fedora 24 Support
category: feature
authors: sandrobonazzola
feature_name: Fedora 24 Support
feature_modules: all
feature_status: Delivered in oVirt 4.0
---

# Fedora 24 Support

## Summary

Add support for Fedora 24

## Owner

*   Name: Sandro Bonazzola
*   Email: <sbonazzo@redhat.com>

## Detailed Description

*   Support building on Fedora 24
*   Create Jenkins jobs for automated build and testing on Fedora 24
*   Create Fedora 24 Jenkins slaves

oVirt is supporting Fedora as tech preview due to limited time resources.
Contribution toward having a better Fedora support are welcome.

## Benefit to oVirt

*   oVirt will be able to run on Fedora 24

## Dependencies / Related Features

*   All subprojects should support Fedora 24

## Documentation / External references

*   <https://fedoraproject.org/wiki/Releases/24/Schedule>
*   <https://fedoraproject.org/wiki/Releases/24/ChangeSet>

## Testing

The whole test case collection should work on Fedora 24.

The Open Virtualization Manager (ovirt-engine) is ready to be tested.

Known Fedora 24 related bugs are tracked on [Fedora 24 Tracker bug](https://bugzilla.redhat.com/show_bug.cgi?id=1355626)

## Contingency Plan

The feature is self contained: if support for Fedora 24 won't be stable enough for 4.1.0 we won't deliver Fedora 24 RPMs.

## Release Notes

    == Fedora 24 Support ==
    Support for running oVirt on Fedora 24 (or similar) has been added.
    oVirt is supporting Fedora as tech preview due to limited time resources.
    Contribution toward having a better Fedora support are welcome.
