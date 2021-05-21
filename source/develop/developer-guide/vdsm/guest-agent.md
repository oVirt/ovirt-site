---
title: Guest Agent
category: vdsm
authors:
  - danken
  - vered
---

# Guest Agent

## oVirt Guest Agent

The agent is an application which run as a background process inside the guest. It provide information and preform actions that can't easily be achieved from outside the guest's operating system.

### Information

The agent provides the following information:

*   **Machine name** - Show the virtual machine's host name.
*   **Operating system version** - Show the operating system's version. Linux: this value is the kernel version. Windows: it is the Windows version name (e.g. Windows XP or Windows 7).
*   **IP(v4) addresses** - List of all the virtual machine's IP addresses. Only IPv4 addresses is reported.
*   **Installed applications** - List in installed applications. Linux: application list is set using the configuration file. Windows: installed applications list is based on value read from registry.
*   **Available RAM** - The amount of unused physical memory. This value probably include memory like cache, or else the memory usage will always be (or near) 100% usage.
*   **Logged in users** - List of all logged-in users.
*   **Active user** - The user which currently is using the virtual machine's "physical hardware". Redundant since RHEV-M is treating the SPICE's ticket owner as the active user.

### Notifications

The agent notify on the following events:

*   **Power Up** - Send when agent start its execution.
*   **Power Down** - unused
*   **Heartbeat** - Message is sent every few seconds to notify that the agent is running. The notification includes the guest's available RAM.
*   **User Info** - Active user was changed.
*   **Session Lock** - Desktop was locked (Windows).
*   **Session Unlock** - Desktop was unlocked (Windows).
*   **Session Logoff** - A user was logged off (Windows).
*   **Session Logon** - A user was logged on (Windows).
*   **Agent Uninstalled** - Agent was removed from system. Expected to be sent from the agent's installer.

### Actions

The following actions can be requested from the agent:

*   **Lock screen** - Request locking the user's desktop.
*   **Login** - Perform a login in user's behalf.
    -   [Automatic login on RHEL](/develop/developer-guide/vdsm/guest-agent-login-rhel.html)
    -   [Automatic login on Microsoft's Windows](/develop/developer-guide/vdsm/guest-agent-login-windows.html)
*   **Logoff** - Log off the active user.
*   **Shutdown** - Shut down the virtual machine.

