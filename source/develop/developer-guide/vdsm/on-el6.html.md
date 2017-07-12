---
title: Vdsm on el6
category: vdsm
authors: danken
---

# Vdsm on EL6

As of ovirt-3.6, Vdsm is dropping support of the el6 platform. This is a good opportunity to shed legacy code.

List here things that should be dropped:

*   anything with REQUIRED_FOR: el6 (two places marked like that)
*   netlink workaround
*   spec file <https://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:cleanup_spec>
*   300 bridges upgrade
