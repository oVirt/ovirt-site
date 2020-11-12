---
title: Console Client Resources
authors: fkobzik, sandrobonazzola
---

# Console Clients Resources

oVirt provides several ways to connect to remote virtual machines. This page describes user requirements of them.

### SPICE Protocol

*   Native Client

This way make use of locally installed remote-viewer application.
You can install the application using your package manager (yum/dnf install virt-viewer) or download it from <http://virt-manager.org/download/> for various platforms.

*   spice-html5

For using web-browser-based console clients, the certificate authority must be imported in your browser since the communication is secured.
You can download the certificate authority by navigating `https://<your engine address>/ovirt-engine/services/pki-resource?resource=ca-certificate&format=X509-PEM-CA`.

*   SPICE Drivers

For making the best use of SPICE features install SPICE vdagent and SPICE QXL video drivers on your guests.
They are available for download on <http://www.spice-space.org/download.html> (in the "Guest" section).
If you use GNU/Linux, your distribution may contain QXL video driver package.

For Windows, install also the `usbdk` from the same source. `usbdk` is a driver that is able to install and uninstall Windows USB drivers in guest virtual machines.
Installing `usbdk` requires Administrator privileges. Note that the previously supported USB Clerk option has been deprecated and is no longer supported.

### VNC Protocol

*   Native Client

The requirements are the same as for Native Client for SPICE protocol.

*   noVNC

The requirements are the same as spice-html5.

### RDP Protocol

*   Native

Client application capable of parsing an RDP file and invoking console session (e.g. mstsc.exe on MS Windows).

*   Plugin

<b>(MS Internet Explorer only)</b> Usage of the plugin doesn't require user intervention and is invoked automatically.

