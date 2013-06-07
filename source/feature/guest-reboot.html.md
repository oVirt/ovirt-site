---
title: Guest Reboot
authors: mbetak
wiki_title: Features/Guest Reboot
wiki_revision_count: 19
wiki_last_updated: 2013-06-24
---

# Guest Reboot (preview)

### Summary

Support reboot in both engine and vdsm. Enable users to restart VM with single command.

### Detailed description

#### Current Condition

The current behavior in the engine requires the user who wishes to reboot VM to wait until the VM is `Down`, then press run and wait until it is `Up` again. Adding a new button/REST action (with configurable behavior, see [later](#Backend)) would solve this issue. Also, if the guest OS refuses the "soft" version of shutdown, after some period it goes back to state `Up` and this delay period is not configurable.

#### Proposed changes

##### Frontend

*   Add new button ![](reboot.png "fig:reboot.png") in the main VM toolbar between the current stop and console buttons.
*   Add 'Reboot' option to the VM context menu.
*   Add context menu option for forced reboot - equivalent of 'Power Off' for reboot.
*   Add power-down policy selection checkbox (see later) and textbox for specifying delay for graceful period shutdown/reboot to EditVM dialog.

##### REST API

*   Add VM action for reboot (subject to power-down policy)
*   Add VM action for forced-reboot (precise name open to discussion)
*   Add VM attribute for power-down policy
*   Add VM attribute for graceful power-down delay

##### Backend

At the engine level we can differentiate between VMs that the user considers "important" and should not be forcibly terminated if the guest OS doesn't gracefully power down after given timeout and VMs which the users expects to be rebooted by any means necessary. This power-down policy should be specified as `vm_static` attribute and would by applied on both the shutown and the reboot action. If the user would wish for the "harder" behavior he can edit the policy for given VM or just pick the appropriate action from the context menu. We should also provide the user with the ability to specify the graceful-delay as another `vm_static` attribute. This delay will be used by VDSM/guest-agent and specifies how long to wait for the guest-agent/acpi until we return failure or resort to the forced destroy/reset.

##### VDSM

Alter the API of `shutdown`. Add two optional boolean parameters: `force` and `reboot` where `reboot` differentiates between shutdown/reboot and `force` allows us to specify whether to forcibly destroy/reset VM after all the graceful methods of shutdown/reboot have failed (guest-agent, acpi).

##### Guest Agent

Support additional boolean parameter in the desktopShutdown call determining wether we want normal shutdown (`reboot=False`) or reboot. This is the simplest change as it boils down to passing -h or -r flag to the underlying script performing the shutdown.

### Possible Issues

*   Run Once behavior

Do we want to preserve the run-once configuration after reboot (effectively becoming "run-twice") or do we treat it as equivalent to stop(); start()?

Do we provide option to the user to select the desired behavior?

*   Stateless VM

### Owner

*   Name: [Martin Betak](User:Mbetak)
*   Email: <mbetak@redhat.com>
