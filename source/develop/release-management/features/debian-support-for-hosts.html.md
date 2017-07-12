---
title: Debian support for hosts
category: feature
authors: sandrobonazzola
feature_name: Debian support for hosts
feature_modules: vdsm,ioprocess,mom,pthreading,cpopen
feature_status: On QA
---

# Debian support for hosts

## Summary

Add support for Debian (or similar) hosts

## Owner

*   Name: Simone Tiraboschi (Stirabos)
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

*   [oVirt build on debian/ubuntu](/develop/developer-guide/ubuntu/)
*   [Guest Agent on Debian](/develop/release-management/features/virt/guestagent/)
*   [How to install the guest agent in Debian](/documentation/how-to/guest-agent/install-the-guest-agent-in-debian/)
*   [VDSM on Debian](/develop/developer-guide/vdsm/on-debian/)

## Testing

You can use it adding

      # vdsm 4.17
      deb `[`http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/`](http://resources.ovirt.org/pub/ovirt-3.6-pre/debian/)` binary/

under /etc/apt/sources.list Than $ sudo apt-get update $ sudo apt-get install vdsm to install vdsm

The whole [Test Case](/Category:TestCase) collection must work when hosts are running Debian.

## Contingency Plan

The feature is self contained: if support for Debian won't be ready for 3.6.0 we won't deliver Debian packages.

## Release Notes

      == Experimental Debian Support for Hosts ==
      Experimental support for running oVirt Hosts on Debian (or similar) has been added providing custom packaging of needed dependencies.



[Debian support for hosts](/develop/release-management/features/) [Debian support for hosts](/develop/release-management/releases/3.6/proposed-feature/) [Debian support for hosts](Category:oVirt 3.6 Feature) [Debian support for hosts](Category:Integration)
