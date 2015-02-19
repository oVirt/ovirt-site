---
title: VDSM on Debian
category: vdsm
authors: stirabos
wiki_title: VDSM on Debian
wiki_revision_count: 13
wiki_last_updated: 2015-02-24
---

The aim is this page is tracking the progress to have oVirt managing a Debian based host for virtualizaion purposes. oVirt require to have an agent on each host, the agent is called VDSM so the first step is to have VDSM running on Debian.

Targeted Debian Version: Debian Jessie (8), is current testing and feature frozen, it should be releases when ready so it's about months.

# VDSM on Debian

The aim is to have VDSM 4.17 on Debian. Here we have a patch for the packaging work. <http://gerrit.ovirt.org/#/c/37737/> I'm trying to get successfully results on each unit test.

### Dependency Packages

*   python-cpopen
*   python-pthreading
*   python-ioprocess

### Open Issue

VDSM is relaying on a custom release of M2Crypto python libraries. M2Crypto is an OpenSSL wrapper. Upstream release

# Existing Efforts

*   [Ovirt build on debian/ubuntu](Ovirt build on debian/ubuntu)
*   [Porting oVirt](Porting oVirt)
*   [VDSM_on_Ubuntu](VDSM_on_Ubuntu)
