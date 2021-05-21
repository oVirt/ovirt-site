---
title: Vdsm Getting Started
category: vdsm
authors:
  - danken
  - lhornyak
  - quaid
  - tscofield
---

# Vdsm Getting Started

## Caveat Emptor

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. Vdsm may eat your babies.

*   Vdsm is a very intensive piece of software and has some assumptions about coexisting with other software. We are trying to fix these issues but it's not our first priority.
*   Vdsm exclusive write access to libvirt. NO OTHER PROCESS should be using libvirt on a Vdsm host.

## Configuring Vdsm

Vdsm configuration file can be placed under */etc/vdsm/vdsm.conf*. If no such file exists Vdsm will only use its built-in defaults.

### SSL

Until you configure you Vdsm's private key and certificates, you should disable ssl. To do that, have your */etc/vdsm/vdsm.conf* have

    [vars]
    ssl = false

Note: this is enough to make VDSM run without ssl, but spice, quemu and the ovirt engine need some further configuration.

### max outgoing migrations

Maximum concurrent outgoing migrations. Should be 3 or less for 1 gig links. Prior to ovirt 3.3 it was set to 5.

      [vars]
      max_outgoing_migrations = 3

### migration max bandwidth

Maximum bandwidth for migration, in MiBps, 0 means libvirt's 'default, since 0.10.x default in libvirt is unlimited

      [vars]
      migration_max_bandwidth = 32

