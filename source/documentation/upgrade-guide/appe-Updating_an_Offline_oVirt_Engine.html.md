---
title: Updating an Offline oVirt Engine
---

# Appendix A: Updating an Offline oVirt Engine

## Updating the Local Repository for an Offline oVirt Engine Installation

If your oVirt Engine is hosted on a system that receives packages via FTP from a local repository, you must regularly synchronize the repository to download package updates, then update or upgrade your Engine system. Updated packages address security issues, fix bugs, and add enhancements.

1. On the system hosting the repository, synchronize the repository to download the most recent version of each available package:

        # reposync -l --newest-only /var/ftp/pub/rhevrepo

    This command may download a large number of packages, and take a long time to complete.

2. Ensure that the repository is available on the Engine system, and then update or upgrade the Engine system. See [Chapter 3: Upgrading to oVirt 4.0](../chap-Upgrading_to_oVirt_4.0) for information on updating the Engine between minor versions. See [Chapter 1: Updating the oVirt Environment](../chap-Updating_the_oVirt_Environment) for information on upgrading between major versions.

**Prev:** [Chapter 4: Post-Upgrade Tasks](../chap-Post-Upgrade_Tasks)
