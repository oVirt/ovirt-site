# Red Hat Virtualization 4.0 Upgrade Considerations

The following is a list of key considerations that must be made when planning your upgrade.

Upgrading to version 4.0 can only be performed from version 3.6

: To upgrade a version of Red Hat Enterprise Virtualization earlier than 3.6 to Red Hat Virtualization 4.0, you must sequentially upgrade to any newer versions of Red Hat Enterprise Virtualization before upgrading to the latest version. For example, if you are using Red Hat Enterprise Virtualization 3.5, you must upgrade to the latest minor version of Red Hat Enterprise Virtualization 3.6 before you can upgrade to Red Hat Virtualization 4.0. See the [*Upgrade Guide*](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Virtualization/3.6/html/Upgrade_Guide/index.html) for Red Hat Enterprise Virtualization 3.6 for instructions to upgrade to the latest 3.6 minor version.

: The data center and cluster compatibility version must be at version 3.6 before performing the upgrade.

Red Hat Virtualization Manager 4.0 is supported to run on Red Hat Enterprise Linux 7.2

: Upgrading to version 4.0 involves also upgrading the base operating system of the machine that hosts the Manager.
