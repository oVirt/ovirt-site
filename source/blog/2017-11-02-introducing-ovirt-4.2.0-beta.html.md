---
title: Introducing oVirt 4.2.0 Beta
author: jmarks
tags: ovirt, 42.0
date: 2017-11-02 11:00:00 CET
comments: true
published: true
---
On October 31st, the oVirt project released version 4.2.0 Beta, available for Red Hat Enterprise Linux 7.4, CentOS Linux 7.4, or similar.

Since the release of oVirt 4.2.0 Alpha a month ago, a substantial number of stabilization fixes have been introduced.


READMORE


### What's new in this release?

Support for **LLDP**, a protocol for network devices for advertising identity and capabilities to neighbors on a LAN. LLDP information can now be displayed in both the UI and via the API. The information gathered by the protocol can be used for better network configuration.


oVirt 4.2.0 Beta features **Gluster 3.12**.


oVirt's hyperconverged solution now enables a **single replica Gluster deployment**.


**OVN (Open Virtual Network)** is now fully supported and recommended for isolated overlay networks. OVN is automatically deployed on the the host, and made available for VM connectivity.


**Snapshots** - such as Python SDKs - can now be uploaded and downloaded.


Improvements have been introduced to **eliminate a single point of failure (SPOF) in an iSCSI single target**. Now, the hosted-engine will connect to all IPs discovered, allowing both higher performance via multiple paths as well as high availability in the event that one of the targets fails.


A new **self-hosted engine wizard UI** replaces the older version, and provides a greatly improved user experience. Among other improvements, it now enables users to review and edit their inputs before beginning the deployment process.


**Windows DoD SPICE driver**, for seamless remote access to virtual machines. The driver aims to improve the user experience and performance for Windows graphical guests.

For the entire list of 4.2.0 features, enhancements, bug fixes, and more, read the [4.2.0 beta release notes](/release/4.2.0/).
