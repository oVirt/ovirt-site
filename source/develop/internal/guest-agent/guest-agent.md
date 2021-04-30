---
title: oVirt guest agent
category: ovirt-guest-agent
authors: adahms, bazulay, bproffitt, geoffoc, rmiddle, vfeenstr
---

<!-- TODO: Content review -->

# oVirt-guest-agent

The agent is an application which run as a background process inside the guest, it communicates with Vdsm over a vioserial device.
It provides:

## Information

The agent provides the following information:

* **Machine name** -- Show the virtual machine's host name.
* **Operating system version** -- Show the operating system's version. Linux: this value is the kernel version. Windows: it is the Windows version name (e.g. Windows XP or Windows 7).
* **Installed applications** -- List in installed applications. Linux: application list is set using the configuration file. Windows: installed applications list is based on value read from registry.
* **Available RAM** -- The amount of unused physical memory. This value probably includes memory like cache, or else the memory usage will always be (or near) 100% usage.
* **Logged in users** -- List of all logged-in users.
* **Active user** -- The user that is currently using the virtual machine's "physical hardware". Redundant because RHEV-M is treating the SPICE's ticket owner as the active user.
* **Disks usage** -- VM disks utilization.
* **Network interfaces** -- Internal guest network mapping (MAC, name, ipv4, ipv6).
* **FQDN** -- Reports the configured (F)ully (Q)ualified (D)omain (N)ame of the guest os

## Notifications

The agent notify on the following events:

* **Power up** -- Sent when the agent is started.
* **Power down** -- Unused.
* **Heartbeat** -- The message sent every few second to notify that the agent is running. The notification includes the guest's available RAM.
* **User info** -- Active user has changed.
* **Session lock** -- Desktop was locked (Windows).
* **Session unlock** -- Desktop was unlocked (Windows).
* **Session logoff** -- A user was logged off (Windows).
* **Session logon** -- A user was logged on (Windows).
* **Agent uninstalled** -- Agent was removed from the system. This is not sent by the agent itself but by the agent's (un-)installer.

## Actions

The following actions can be requested from the agent:

* **Lock screen** -- Request locking the user's desktop.
* **Login** -- Perform a login on the user's behalf.
* [Automatic login on RHEL](guest-agent-automatic-login-rhel6.html)
* [Automatic login on Microsoft's Windows](guest-agent-automatic-login-windows.html)
* **Logoff** -- Log off the active user.
* **Shutdown** -- Shut down the virtual machine.

