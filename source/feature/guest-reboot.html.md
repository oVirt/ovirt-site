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

Add new button ![](reboot.png "fig:reboot.png") in the main VM toolbar between the current stop and console buttons.

*   REST
*   Backend
*   VDSM
*   Guest Agent

Support additional boolean parameter in the desktopShutdown call determining wether we want normal shutdown (`reboot=False`) or reboot (`reboot=True`).

This is the simplest change as it boils down to passing -h or -r flag to the underlying script performing the shutdown.

### Possible Issues

*   Run Once behavior

Do we want to preserve the run-once configuration after reboot (effectively becoming "run-twice") or do we treat it as equivalent to stop(); start()?

Do we provide option to the user to select the desired behavior?

*   Stateless VM

### Owner

*   Name: [Martin Betak](User:Mbetak)
*   Email: <mbetak@redhat.com>
