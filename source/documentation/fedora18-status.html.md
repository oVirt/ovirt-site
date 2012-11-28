---
title: Fedora18 status
authors: obasan
wiki_title: Documentation/Fedora18 status
wiki_revision_count: 10
wiki_last_updated: 2012-11-28
---

# Fedora18 status

oVirt on Fedora18 status.

Engine

------------------------------------------------------------------------

Status:

*   Works but require manual tweaking
*   shut down firewalld prior to installation
*   During setup, chose "no" when being asked whether to configure iptables.
*   Relevant BZ:

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=880768`](https://bugzilla.redhat.com/show_bug.cgi?id=880768)

VDSM

------------------------------------------------------------------------

Status:

*   Works but requires manual tweaking.
*   Relevant BZ:

`  `[`https://bugzilla.redhat.com/show_bug.cgi?id=869963`](https://bugzilla.redhat.com/show_bug.cgi?id=869963)

*   Walkarounds for the issues can be found here:

`  `[`http://wiki.ovirt.org/wiki/How_to_install_ovirt_on_fedora18`](http://wiki.ovirt.org/wiki/How_to_install_ovirt_on_fedora18)

DWH

------------------------------------------------------------------------

Status:

*   RPM installation succeeded.
*   Setup fails
*   Relevant BZ:

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=880996`](https://bugzilla.redhat.com/show_bug.cgi?id=880996)

Reports

------------------------------------------------------------------------

Status:

*   Not tested

Guest agent

------------------------------------------------------------------------

Status:

*   Not tested

Cli

------------------------------------------------------------------------

Status:

*   Doesn't work
*   Relevant BZ:

` `[`https://bugzilla.redhat.com/show_bug.cgi?id=881011`](https://bugzilla.redhat.com/show_bug.cgi?id=881011)

SDK

------------------------------------------------------------------------

Status:

*   Working OK
