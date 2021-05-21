---
title: Spice
authors:
  - jaypers
  - mkrcmari
  - nkesick
---

# Spice

## Introduction

The Spice project aims to provide a complete open source solution for interaction with virtualized desktop devices.The Spice project deals with both the virtualized devices and the front-end. Interaction between front-end and back-end is done using VD-Interfaces. The VD-Interfaces (VDI) enable both ends of the solution to be easily utilized by a third-party component. (from <http://spice-space.org/>). Spice is an essential part of Ovirt. Check home page of Spice project for more details <http://spice-space.org/>.

Components:

*   Spice client is the interface for the end user.
*   QXL driver is a video driver for the QEMU QXL video accelerator. It's used for improving remote display performance and enhancing the graphic capabilities of the guest graphic system. However, standard VGA is supported when no driver exists.
*   Spice vdagent is an optional component for enhancing user experience and performing guest-oriented management tasks. For example, the agent injects mouse position and state to the guest when using client mouse mode. In addition, it is used for configuration of the guest display settings and provides Clipboard sharing - allows copy paste between clients and the virtual machine.
*   Spice XPI is SPICE extension for mozilla allows the client to be used from a web browser (on linux clients).

## Testing Spice with oVirt

What do you need?

*   A Linux client machine with spice client and spice xpi installed (packages spice-client and spice-xpi in Fedora/RHEL). It's not possible to connect to a guest from Windows client through Ovirt yet.
    -   Fedora 17/RHEL6.3 Beta users can try a new spice-gtk based client remote-viewer - Install virt-viewer package and change priorities of spice clients with using update-alternatives tool ("update-alternatives --config spice-xpi-client" -> Choose remote-viewer). Please Note that SELinux policy bug (preventing remote-viewer connection) was observed, you may switch to SELinux permissive mode.
    -   In Ubuntu there is no spice-xpi package. One method that works for Ubuntu 13.04 is to Install the spice-client package which gives you /usr/bin/spicec. Extract the libnsISpicec.so file from the latest Fedora (FC19) RPM. Copy it into /usr/lib/mozilla/plugins/ and restart Firefox.

<!-- -->

*   Ovirt instance with some Windows/Linux guests installed with QXL graphic driver and spice vdagent installed (See below how to set up those components).

### Windows guest

Install Spice guest tools (qxl graphic driver and spice-vdagent):

*   Download binary from <http://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe> and execute on Windows guest (reboot of guest is required).

OR

Install qxl graphic driver and spice vdagent separately:

*   Download qxl driver (zip file) from <http://www.spice-space.org/download/windows/qxl/qxl-0.1-19/> (broken) , unpack and install suitable version of qxl driver on Windows guest (i.e. with using Device Manager).
*   Download spice vdagent (zip file) from <http://www.spice-space.org/download/windows/vdagent/vdagent-win-0.7.2> (broken) , unpack and install suitable version of service following way:

1.  Start cmd under Administrator (It's important to run it as Administrator).
2.  Move to location where you unpacked binaries (vdservice.exe and vdagent.exe).
3.  Run: "vdservice install"
4.  Run: "net start vdservice" (note you need to have virtio-serial driver installed).

Note: virtio-serial driver needs to be installed as well.

### Fedora/RHEL guest

Make sure that xorg-x11-drv-qxl and spice-vdagent packages are installed (qxl driver is in used and spice-vdagentd service running). Note that F15/F16 will be displayed in fallback mode.

### Ubuntu 14.04/16.04 guest

Make sure that xserver-xorg-video-qxl and spice-vdagent packages are installed (qxl driver is in used and spice-vdagentd service running).
