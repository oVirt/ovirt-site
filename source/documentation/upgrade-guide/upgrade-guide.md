# oVirt Upgrade Guide

This guide covers updating your Red Hat Virtualization environment between minor releases, and upgrading to the next major version. Always update to the latest minor version of your current Red Hat Virtualization Manager version before you upgrade to the next major version.

For interactive upgrade instructions, you can also use the RHEV Upgrade Helper available at [https://access.redhat.com/labs/rhevupgradehelper/](https://access.redhat.com/labs/rhevupgradehelper/). This application asks you to provide information about your upgrade path and your current environment, and presents the relevant steps for upgrade as well as steps to prevent known issues specific to your upgrade scenario.

**Upgrading the Red Hat Virtualization Manager involves the following key steps:**

* Subscribe to the appropriate entitlements

* Update the system

* Run engine-setup

* Remove repositories no longer required.

**Updating RHVH and RHEL hosts:**

Hosts can be upgraded directly from the Red Hat Virtualization Manager which checks for and notifies you of available host updates.

**Update cluster and data center compatibility level**

The command used to perform the upgrade itself is engine-setup, which provides an interactive interface. While the upgrade is in progress, virtualization hosts and the virtual machines running on those virtualization hosts continue to operate independently. When the upgrade is complete, you can then upgrade your hosts to the latest versions of Red Hat Enterprise Linux or Red Hat Virtualization Host.

## Chapter 1: [Updating the oVirt Environment](chap-Updating_the_oVirt_Environment)

## Chapter 2: [Updates Between Minor Releases](chap-Updates_between_Minor_Releases)

## Chapter 3: [Upgrading to oVirt 4.0](chap-Updating_the_oVirt_Environment)

## Chapter 4: [Post-Upgrade Tasks](chap-Post-Upgrade_Tasks)

## Appendix A: [Updating an Offline oVirt Engine](appe-Updating_an_Offline_oVirt_Engine)
