---
title: Guest Reboot
authors: mbetak
---

# Guest Reboot (preview)

## Summary

Support reboot in both engine and vdsm. Enable users to restart VM with single command.

## Detailed description

### Current Condition

The current behavior in the engine requires the user who wishes to reboot VM to wait until the VM is `Down`, then press run and wait until it is `Up` again. Adding a new button/REST action (with configurable behavior, see [later](#backend)) would solve this issue. Also, if the guest OS refuses the "soft" version of shutdown, after some period it goes back to state `Up` and this delay period is not configurable.

### Proposed changes

The reboot will essentially act as a macro of actions shutdown and run with all the consequences for run-once and stateless VM's. The shutdown part of the reboot is subject to VM's power-down policy but in case the VM's config has changed we need to destroy the VM eventually (for the new configuration to be applied on run) so the shutdown part of reboot is in this case forced. Under forced powerdown (shutdown or first phase of reboot) we understand that after the all the graceful method have been tried and the graceful period has timed out we will proceed with vm.destroy() as opposed to just returning the VM to **Up** state.

#### Frontend

*   Add new button ![](/images/wiki/Reboot.png) in the main VM toolbar between the current stop and console buttons.
*   Add 'Reboot' option to the VM context menu.
*   Add context menu option for forced reboot - equivalent of 'Power Off' for reboot.
*   Add power-down policy selection checkbox (checked if we want to force powerdown) and textbox for specifying number of seconds for graceful powerdown period to EditVM dialog.

#### REST API

*   Add VM action for reboot (subject to power-down policy)
*   Add VM action for forced-reboot (powercycle)
*   Add VM attribute for power-down policy
*   Add VM attribute for graceful power-down delay

#### Backend

At the engine level we can differentiate between VMs that the user considers "important" and should not be forcibly terminated if the guest OS doesn't gracefully power down after given timeout and VMs which the users expects to be rebooted by any means necessary. This power-down policy should be specified as `vm_static` attribute and would by applied on both the shutown and the reboot action. If the user would wish for the "harder" behavior he can edit the policy for given VM or just pick the appropriate action from the context menu. We should also provide the user with the ability to specify the graceful-delay as another `vm_static` attribute. This delay will be used by VDSM/guest-agent and specifies how long to wait for the guest-agent/acpi until we return failure or resort to the forced destroy/reset.

#### VDSM

Alter the API of `shutdown`. Add two optional boolean parameters: `force` and `reboot` where `reboot` differentiates between shutdown/reboot and `force` allows us to specify whether to forcibly destroy/reset VM after all the graceful methods of shutdown/reboot have failed (guest-agent, acpi).

#### Guest Agent

Support additional boolean parameter in the desktopShutdown call determining wether we want normal shutdown (`reboot=False`) or reboot. This is the simplest change as it boils down to passing -h or -r flag to the underlying script performing the shutdown.

## Owner

*   Name: Martin Betak (Mbetak)
*   Email: <mbetak@redhat.com>
