---
title: Updating an Offline oVirt Engine
---

# Appendix A: Updating an Offline oVirt Engine

## Updating the Local Repository for an Offline oVirt Engine Installation

If your oVirt Engine is hosted on a system that receives packages via FTP from a local repository, you must regularly synchronize the repository to download package updates, then update or upgrade your Engine system. Updated packages address security issues, fix bugs, and add enhancements.

1. On the system hosting the repository, synchronize the repository to download the most recent version of each available package:

        # reposync -l --newest-only /var/ftp/pub/rhevrepo

   This command may download a large number of packages, and take a long time to complete.

2. Ensure that the repository is available on the Engine system, and then update or upgrade the Engine system. See [Chapter 9: Updates Between Minor Releases](../chap-Updates_between_Minor_Releases/) for information on updating the Engine between minor versions.

**Prev:** [Chapter 9: Updates Between Minor Releases](../chap-Updates_between_Minor_Releases/)<br>
**Next:** [Appendix B: Upgrading to oVirt Engine 4.2 with ovirt-fast-forward-upgrade](../appe-Upgrading_to_oVirt_Engine_4.2_with_ovirt-fast-forward-upgrade.html.md)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/appe-updating_an_offline_red_hat_enterprise_virtualization_manager)
