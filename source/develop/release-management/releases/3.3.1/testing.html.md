---
title: oVirt 3.3.1 testing
authors: jbrooks, phurrelmann, sandrobonazzola, sven
wiki_title: Testing/Ovirt 3.3.1 testing
wiki_revision_count: 11
wiki_last_updated: 2013-11-17
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Ovirt 3.3.1 testing

## What to do as a participant

*   Look at [OVirt_3.3_TestDay](OVirt_3.3_TestDay) for understanding what should be tested
*   Update the Participants section.
*   Running into any issues - report it on IRC, user mailing list or bugzilla.

## Participants

Test Days are open to anyone.

If you have your own setup we will provide all the software packages and the required information.

If you're willing to participate please add yourself to the below table:

| Name | part tested | Storage | Networking | Distribution | Bugs |
| --- | --- | --- | --- | --- | --- |
| [SandroBonazzola](/User:SandroBonazzola "User:SandroBonazzola") | engine-setup , clean install, upgrade from 3.3.0 | NFS | basic | Fedora-19 | |
| [Sven](/User:Sven "User:Sven") | engine-setup | local Storage | v-lan, qos | CentOS 6.4 | [BZ 1023739](http://bugzilla.redhat.com/1023739) [BZ 1029584](http://bugzilla.redhat.com/1029584) [BZ 1029885](http://bugzilla.redhat.com/1029885) |
| [Jbrooks](/User:Jbrooks "User:Jbrooks") | AIO | local Storage | basic | Fedora 19 | |
| [Patrick](/User:Phurrelmann "User:Phurrelmann") | engine-setup, import old vms from 3.1 install | iSCSI | basic | CentOS 6.4 | [BZ 1029792](http://bugzilla.redhat.com/1029792) |
