---
title: vhostmd
authors: dyasny
---

# vhostmd

vhostmd (the Virtual Host Metrics Daemon) allows virtual machines to see limited information about the host they are running on. In the host, a daemon ( vhostmd) runs which writes metrics periodically into a disk image. This disk image is exported read-only to guests. Guests can read the disk image to see metrics. Simple synchronization stops guests from seeing out of date or corrupt metrics. The system administrator chooses which metrics the guests can see, and also which guests get to see the metrics at all.

The vhostmd package must be installed on each host where guests are required to get host metrics.

The vhostmd hook enables vhostmd functionality on oVirt guests

