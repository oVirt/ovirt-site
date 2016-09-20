---
title: Debian support for hosts
category: feature
authors: sandrobonazzola
wiki_category: Feature|Debian support for hosts
wiki_title: Features/Debian support for hosts
wiki_revision_count: 6
wiki_last_updated: 2015-10-05
feature_name: Debian support for hosts
feature_modules: vdsm,ioprocess,mom,pthreading,cpopen
feature_status: On QA
---

# Debian support for hosts

## Summary

Add support for Debian (or similar) hosts

## Owner

*   Name: [Simone Tiraboschi](User:Stirabos)
*   Email: <stirabos@redhat.com>

## Detailed Description

*   Support building of host related rpms on Debian
*   Create Jenkins jobs for automated build and testing on Debian
*   Create Debian Jenkins slaves
*   Verify that all the components have no regressions only due to Debian

## Benefit to oVirt

It will be possible to add Debian hosts to an oVirt datacenter

## Dependencies / Related Features

*   All host related subprojects must support Debian
*   A tracker bug has been created for tracking issues:

## Documentation / External references

*   [oVirt build on debian/ubuntu](Ovirt_build_on_debian/ubuntu)
*   [Guest Agent on Debian](Debian/GuestAgent)
*   [How to install the guest agent in Debian](How to install the guest agent in Debian)
*   [VDSM on Debian](VDSM on Debian)

## Testing

You can use it adding

      # vdsm 4.17
      deb `[`http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/)` binary/

under /etc/apt/sources.list Than $ sudo apt-get update $ sudo apt-get install vdsm to install vdsm

The whole [Test Case](http://www.ovirt.org/Category:TestCase) collection must work when hosts are running Debian.

## Contingency Plan

The feature is self contained: if support for Debian won't be ready for 3.6.0 we won't deliver Debian packages.

## Release Notes

      == Experimental Debian Support for Hosts ==
      Experimental support for running oVirt Hosts on Debian (or similar) has been added providing custom packaging of needed dependencies.

## Comments and Discussion


[Debian support for hosts](Category:Feature) [Debian support for hosts](Category:oVirt 3.6 Proposed Feature) [Debian support for hosts](Category:oVirt 3.6 Feature) [Debian support for hosts](Category:Integration)
