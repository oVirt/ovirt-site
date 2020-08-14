---
title: Backend modules vdsbroker
category: architecture
authors: amuller
---

# Backend modules vdsbroker

**Introduction:**
VDS (=Host) broker is a collection of commands that are host-related.
Each host is instantiated a VdsManager, and every host-related command is eventually trickled to that hosts' VdsManager.
Before reading on, it is recommended to read the [Backend modules bll](/develop/architecture/backend-modules-bll.html) page
in order to gain an understanding of how commands work in oVirt.

**Commands:** Like bll commands, VDS commands have a strict naming convention that the VDS commands factory relies on to instantiate vds commands.
The naming convention is \*VDSCommand. VDS commands can be classified in to two main types:

1.  Executor commands - Run code that actually implements a command
2.  Pre/post commands - Run code before or after executor commands

Commands can then be further classified into two additional categories, independent from the previous classification:

1.  IRS (=SPM) commands - Storage related commands, or commands related to the host selected as the Service Pool Manager
2.  VDS commands - Non-SPM commands

