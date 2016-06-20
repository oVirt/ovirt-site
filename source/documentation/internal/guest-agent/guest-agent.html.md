---
title: oVirt guest agent
category: ovirt-guest-agent
authors: adahms, bazulay, bproffitt, geoffoc, rmiddle, vfeenstr
wiki_category: Ovirt guest agent
wiki_title: Category:Ovirt guest agent
wiki_revision_count: 10
wiki_last_updated: 2014-07-21
---

<!-- TODO: Content review -->

# oVirt-guest-agent

The agent is an application which run as a background process inside the guest, it communicates with Vdsm over a vioserial device.
It provides:

### Information

The agent provides the following information:

      * `**`Machine` `name`**` - Show the virtual machine's host name.
      * `**`Operating` `system` `version`**` - Show the operating system's version. Linux: this value is the kernel version. Windows: it is the Windows version name (e.g. Windows XP or Windows 7).
      * `**`Installed` `applications`**` - List in installed applications. Linux: application list is set using the configuration file. Windows: installed applications list is based on value read from registry.
      * `**`Available` `RAM`**` - The amount of unused physical memory. This value probably include memory like cache, or else the memory usage will always be (or near) 100% usage.
      * `**`Logged` `in` `users`**` - List of all logged-in users.
      * `**`Active` `user`**` - The user which currently is using the virtual machine's "physical hardware". Redundant since RHEV-M is treating the SPICE's ticket owner as the active user.
      * `**`Disks` `Usage`**` - VM Disks utilization.
      * `**`network-interfaces`**` - Internal guest network mapping (MAC, name, ipv4, ipv6).
      * `**`FQDN`**` - Reports the configured (F)ully (Q)ualified (D)omain (N)ame of the guest os

### Notifications

The agent notify on the following events:

      * `**`Power` `Up`**` - Send when agent start its execution.
      * `**`Power` `Down`**` - unused
      * `**`Heartbeat`**` - Message is send every few second to notify that the agent is running. The notification includes the guest's available RAM.
      * `**`User` `Info`**` - Active user was changed.
      * `**`Session` `Lock`**` - Desktop was locked (Windows).
      * `**`Session` `Unlock`**` - Desktop was unlocked (Windows).
      * `**`Session` `Logoff`**` - A user was logged off (Windows).
      * `**`Session` `Logon`**` - A user was logged on (Windows).
      * `**`Agent` `Uninstalled`**` - Agent was removed from system. Expected to be send from the agent's installer.

### Actions

The following actions can be requested from the agent:

      * `**`Lock` `screen`**` - Request locking the user's desktop.
      * `**`Login`**` - Perform a login in user's behalf.
` * `[`Automatic` `login` `on` `RHEL`](Ovirt_guest_agent_automatic_login_RHEL6)
` * `[`Automatic` `login` `on` `Microsoft's` `Windows`](Ovirt_guest_agent_automatic_login_windows)
      * `**`Logoff`**` - Log off the active user.
      * `**`Shutdown`**` - Shut down the virtual machine.

<Category:Ovirt_guest_agent>
