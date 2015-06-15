---
title: Console Client Resources
authors: fkobzik
wiki_title: Console Client Resources
wiki_revision_count: 6
wiki_last_updated: 2014-01-17
---

# Console Clients Resources

oVirt provides several ways to connect to remote virtual machines. This page describes user requirements of them.

### SPICE Protocol

*   Browser Plugin

Browser plugin is supported on Firefox/Linux. On Fedora-like systems, you can install the plugin using yum package manager: 'yum install spice-xpi'.

*   Native Client

This way make use of locally installed virt-viewer application. You can install the application using your package manager or download it from <http://virt-manager.org/download/> for various platforms.

*   spice-html5

For using web-browser-based console clients, the certificate authority must be imported in your browser since the communication is secured. You can download the certificate authority by navigating '<https://><your engine address>/ca.crt'.

*   SPICE Drivers

For making the best use of SPICE features install SPICE vdagent and SPICE QXL video drivers on your guests. They are available for download on <http://www.spice-space.org/download.html> (in the "Guest" section). If you use GNU/Linux, your distribution may contain QXL video driver package.

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
