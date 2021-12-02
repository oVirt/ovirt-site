---
title: Browser Support
---

# Browser Support

## Recommended browsers

oVirt follows the [Red Hat Customer Portal Browser Support Policy](https://access.redhat.com/help/browsers/).

We recommend to use one of the recent versions of the following "evergreen" browsers:
 - Mozilla Firefox
 - Google Chrome
 - Apple Safari
 - Microsoft Edge

These are known as "evergreen" browsers because they automatically update themselves to the most recent available version.

Note: oVirt 4.3+ will not support Internet Explorer 11.

## Consoles

A console is a graphical window that allows you to view the start up screen, shut down screen, and desktop of a
Virtual Machine, and to interact with that Virtual Machine in a similar way to a physical machine. In oVirt,
the default application for opening a console to a virtual machine is Remote Viewer, which must be installed on
the client machine (for example, the end user or administrator's laptop). For Windows virtual machines, Remote
Desktop Protocol is also available.

See [Installing Console Components](/documentation/virtual_machine_management_guide/#sect-Installing_Console_Components)
for installation instructions.

#### Browser based

There is also a browser-based console available. In the Console Options dialog for the Virtual Machine, select `noVNC`.
See [VNC Console Options](/documentation/virtual_machine_management_guide/#VNC_Console_Options) for more
information.
