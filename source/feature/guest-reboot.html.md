---
title: Guest Reboot
authors: mbetak
wiki_title: Features/Guest Reboot
wiki_revision_count: 19
wiki_last_updated: 2013-06-24
---

# Guest Reboot (preview)

### Summary

Support reboot in both engine and vdsm. Enable users to restart guest with single command.

### Detailed description

#### Current Condition

The current behavior in the engine requires the user who wishes to reboot VM to wait until the VM is `Down`, then press run and wait until it is `Up` again.

Adding a new button/REST action (with configurable behavior, see later) would solve this issue.

#### Proposed changes

*   Frontend
*   REST
*   Backend
*   VDSM
*   Guest Agent

### Possible Issues

### Owner

*   Name: [Martin Betak](User:Mbetak)
*   Email: <mbetak@redhat.com>
