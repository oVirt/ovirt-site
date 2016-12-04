# Updating the Local Repository for an Offline Red Hat Virtualization Manager Installation

If your Red Hat Virtualization Manager is hosted on a system that receives packages via FTP from a local repository, you must regularly synchronize the repository to download package updates from the Content Delivery Network, then update or upgrade your Manager system. Updated packages address security issues, fix bugs, and add enhancements.

1. On the system hosting the repository, synchronize the repository to download the most recent version of each available package:

        # reposync -l --newest-only /var/ftp/pub/rhevrepo

    This command may download a large number of packages, and take a long time to complete.

2. Ensure that the repository is available on the Manager system, and then update or upgrade the Manager system. See [Upgrading between Minor Releases](Upgrading_between_Minor_Releases) for information on updating the Manager between minor versions. See [Update Overview](Update_Overview) for information on upgrading between major versions.
