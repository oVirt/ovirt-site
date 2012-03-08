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

Our public git repo is located on [oVirt.org](http://gerrit.ovirt.org/gitweb?p=vdsm.git)

you can clone it with

`git clone `[`http://gerrit.ovirt.org/p/vdsm.git`](http://gerrit.ovirt.org/p/vdsm.git)

## Building a Vdsm RPM

Vdsm uses autoconf and automake as it's build system. To configure the build env:

      ./autogen.sh --system

To create an RPM do:

      make rpm

Vdsm automatically builds using the latest tagged version. If you want to explicitly define a version use

      make rpmversion=4.9 rpmrelease=999.funkyBranch

## Code Style

*   variables and arguments are in mixedCase
*   class names are in CamelCase
*   all indentation is made of space characters
*   a space character follows any comma
*   spaces surround operators, but
*   no spaces between

      def f(arg=its_default_value)

*   lines longer than 80 chars are frowned upon
*   whitespace between functions and within stanza help to breath while reading code
*   a space char follows a comment's hash char
*   let logging method do the formatting for you:

      logging.debug('hello %s', 'world')

rather than

      logging.debug('hello %s' % 'world')

## Sending patches

Send them to [our gerrit server](http://gerrit.ovirt.org) ([see how](Working with oVirt Gerrit)).

General development discussions are in `vdsm-devel@lists.fedorahosted.org`.

<Category:Vdsm> <Category:Documentation> [Category:Development environment](Category:Development environment)
