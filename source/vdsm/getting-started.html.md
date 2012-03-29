---
title: Vdsm Getting Started
category: vdsm
authors: danken, lhornyak, quaid, tscofield
wiki_category: Vdsm
wiki_title: Vdsm Getting Started
wiki_revision_count: 4
wiki_last_updated: 2013-12-13
---

# Vdsm Getting Started

## Caveat Emptor

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. Vdsm may eat your babies.

*   Vdsm is a very intensive piece of software and has some assumptions about coexisting with other software. We are trying to fix these issues but it's not our first priority.
*   Vdsm exclusive write access to libvirt. NO OTHER PROCESS should be using libvirt on a Vdsm host.

## Configuring Vdsm

Vdsm configuration file can be placed under */etc/vdsm/vdsm.conf*. If no such file exists Vdsm will only use its built-in defaults. Until you configure you Vdsm's private key and certificates, you should disable ssl. To do that, have your */etc/vdsm/vdsm.conf* have

    [vars]
    ssl = false

Note: this is enough to make VDSM run without ssl, but spice, quemu and the ovirt engine need some [further configuration](OVirt_-_disable_SSL_in_VDSM).

<Category:Vdsm> <Category:Documentation>
