# Chapter 1: Updating the oVirt Environment

This guide covers updating your oVirt environment between minor releases, and upgrading to the next major version. Always update to the latest minor version of your current oVirt Engine version before you upgrade to the next major version.

For interactive upgrade instructions, you can also use the RHEV Upgrade Helper available at [https://access.redhat.com/labs/rhevupgradehelper/](https://access.redhat.com/labs/rhevupgradehelper/). This application asks you to provide information about your upgrade path and your current environment, and presents the relevant steps for upgrade as well as steps to prevent known issues specific to your upgrade scenario.

**Upgrading the oVirt Engine involves the following key steps:**

* Update the system

* Run `engine-setup`

* Remove repositories no longer required.

**Updating RHVH and RHEL hosts:**

Hosts can be upgraded directly from the oVirt Engine, which checks for and notifies you of available host updates.

**Update cluster and data center compatibility level**

The command used to perform the upgrade itself is engine-setup, which provides an interactive interface. While the upgrade is in progress, virtualization hosts and the virtual machines running on those virtualization hosts continue to operate independently. When the upgrade is complete, you can then upgrade your hosts to the latest versions of Enterprise Linux or oVirt Node.

**Next:** [Chapter 2: Updates Between Minor Releases](chap-Updates_between_Minor_Releases)
