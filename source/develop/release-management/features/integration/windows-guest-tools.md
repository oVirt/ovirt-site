---
title: oVirt Windows Guest Tools
category: feature
authors: lveyde, mpavlik, sandrobonazzola
feature_name: oVirt Windows Guest Tools ISO
feature_modules: engine
feature_status: Removed
---

# oVirt Windows Guest Tools ISO

{:.alert.alert-warning}
oVirt Windows Guest Tools ISO has been deprecated and removed in oVirt 4.4 in favor of virtio-win ISO shipped with RHEL 8 and derivated distributions or on [Fedora virito-win repo](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/).
The following section is kept only for reference.


## Summary

This feature will add an ISO image with required drivers and agents for Windows based VMs.

## Owner

*   Name: [Lev Veyde](https://github.com/lveyde)
*   Email: <lveyde@gmail.com>

## Current status

*   Removed in oVirt 4.4

## Detailed Description

The oVirt Guest Tool ISO provides a collection of tools usable for Windows VMs that run under KVM (oVirt).
It also includes an installer  to make the tools installation as easy as possible.

The oVirt Guest Tools Installer installs all VirtIO-Win device drivers (Balloon, Serial, Net, Block and SCSI)
along with Spice Agent and QXL drivers.

Compatibility matrix:

| OS      | VirtIO-Win drivers | oVirt Agent | Spice Agent | Installer | QXL |
| XP      |  ✓ |  ✓ | ✓ | ✓ | ✓ |
| 2K3     |  ✓ |  ✓ | ✓ | ✓ |   |
| 2K8     |  ✓ |  ✓ | ✓ | ✓ | ✓ |
| Win 7   |  ✓ |  ✓ | ✓ | ✓ | ✓ |
| 2K8R2   |  ✓ |  ✓ | ✓ | ✓ | ✓ |
| Win 8   |  ✓ |  ✓ | ✓ | ✓ |   |
| 2K12    |  ✓ |  ✓ | ✓ | ✓ |   |
| Win 8.1 |  ✓ |  ✓ | ✓ | ✓ |   |
| 2K12R2  |  ✓ |  ✓ | ✓ | ✓ |   |
| Win 10  |  ✓ |  ✓ | ✓ | ✓ | ✓ |
| 2K16    |  ✓ |  ✓ | ✓ | ✓ |   |

QXL support is also declared on [Download](/download) page and should be kept in sync with above matrix.

The installer is based on the Spice installer's source code (http://cgit.freedesktop.org/~teuf/spice-nsis/) ,
and was slightly modifed for this project's needs.

**Important Note!** [Bug 1528652](https://bugzilla.redhat.com/1528652) Currently you can't directly upgrade between the versions without either first stopping the services or performing an uninstall.

The current list of the software to be included in the ISO:

* VirtIO-Win drivers:
  * VirtIO-Serial
  * VirtIO-Balloon
  * VirtIO-Net
  * VirtIO-Block
  * VirtIO-SCSI From:

* Spice drivers and agent

  **Important Note!** It seems that Spice installer (current is [spice-guest-tools-0.132.exe](https://www.spice-space.org/download/binaries/spice-guest-tools/spice-guest-tools-0.132/spice-guest-tools-0.132.exe) ) installs not just Spice related components (QXL and Agent), but all VirtIO-Win drivers as well.

* Spice QXL for 32 and 64 bit Windows
* Qemu Guest Agent
* oVirt Guest Agent (Currently it is cross-compiled using Wine)

## Benefit to oVirt

The ISO image will become a central repository for all the software that Windows based VMs require
in order to function in most optimal way under oVirt / KVM.

## Dependencies / Related Features

The oVirt Guest Tools relies on the following dependencies:
* Spice Agents for 32 and 64 bit Windows: <https://www.spice-space.org/download/windows/vdagent/vdagent-win-0.9.0/>
* VirtIO-Win drivers: <http://secondary.fedoraproject.org/pub/alt/virtio-win/latest/>
* Spice drivers and agent From: <http://www.spice-space.org/download/binaries/spice-guest-tools/>
* Spice QXL for 32 and 64 bit Windows: <https://www.spice-space.org/download/windows/qxl/qxl-0.1-24/>
* oVirt Guest Agent: <https://gerrit.ovirt.org/gitweb?p=ovirt-guest-agent.git;a=summary>

## Documentation / External references

## Testing

## Installation

* Install oVirt Release RPM enabling oVirt repositories if you have not done so yet:

    `yum install <http://resources.ovirt.org/pub/yum-repo/ovirt-release42.rpm>`

* Install oVirt Guest Tools package

    `yum install ovirt-guest-tools-iso`

* Optional: The above will install the ISO in `/usr/share/ovirt-guest-tools-iso/`. Copy it to wherever you need it...

* The ISO images are also available for download at <http://resources.ovirt.org/pub/ovirt-4.2/iso/oVirt-toolsSetup/>
