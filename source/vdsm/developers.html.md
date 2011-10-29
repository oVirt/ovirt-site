---
title: Vdsm Developers
category: vdsm
authors: abonas, adahms, amuller, amureini, apahim, apevec, danken, dougsland, ekohl,
  fromani, herrold, itzikb, lhornyak, mbetak, mlipchuk, moolit, moti, mpavlik, nsoffer,
  phoracek, quaid, sandrobonazzola, sgordon, smelamud, vered, vfeenstr, vitordelima,
  yanivbronhaim, ybronhei
wiki_category: Vdsm
wiki_title: Vdsm Developers
wiki_revision_count: 169
wiki_last_updated: 2015-05-21
---

# Vdsm Developers

## Getting the source

Our public git repo is located on [fedora hosted](http://git.fedorahosted.org/git/?p=vdsm.git)

you can clone it with

`git clone `[`http://git.fedorahosted.org/git/?p=vdsm.git`](http://git.fedorahosted.org/git/?p=vdsm.git)

## Building a Vdsm RPM

Vdsm uses autoconf and automake as it's build system. To configure the build env:

      ./autogen.sh --system

To create an RPM do:

      make

Vdsm automatically builds using the latest tagged version. If you want to explicitly define a version use

      make rpmversion=4.9 rpmrelease=999.funkyBranch

## Code Style

*   variables and arguments are in mixedCase
*   class names are in CamelCase

## Sending patches

Send them to `vdsm-patches@lists.fedorahosted.org`. Please subscribe before sending patches so you could keep track on your patch.

The above mailing list is only for patches. General development discussions are in `vdsm-devel@lists.fedorahosted.org`.
