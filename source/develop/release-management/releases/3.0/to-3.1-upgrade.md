---
title: oVirt 3.0 to 3.1 upgrade
authors: fabiand, oschreib
---

# oVirt 3.0 to 3.1 upgrade

## General Information

oVirt 3.0 was released as Fedora 16 package, and 3.1 is targeted to Fedora 17. Due to the nature of this upgrade, we DO NOT recommend it, users are advised to do a 3.1 clean installation, and to import all VM's and template into the new installation.

## Upgrade Instructions

*   Remove all ovirt packages

<!-- -->

     yum remove ovirt\* 

**DO NOT run the engine-cleanup utility**

*   Upgrade the system the oVirt Engine was installed on to Fedora 17:
    -   <http://fedoraproject.org/wiki/PreUpgrade>

<!-- -->

*   Install oVirt Engine rpms

<!-- -->

     yum install ovirt-engine 

*   Restore previous keystore and preserve .sh scripts

<!-- -->

    cd /etc/pki
    mv ovirt-engine ovirt-engine.old
    mv ovirt-engine-backups/ovirt-engine-DATE_OF_BACKUP/ovirt-engine .
    find ovirt-engine -user jboss-as -exec chown ovirt:ovirt {} \;
    cp -f ovirt-engine.old/*.sh ovirt-engine/
    service nfs-server disable; service nfs-server enable
    service rpb-bind disable; service rpc-bind enable

*   Execute oVirt Engine Setup utility

<!-- -->

     engine-setup 

## Updating oVirt Node

*   Download the latest stable [oVirt Node release](https://resources.ovirt.org/releases/3.1/tools/)
*   Use one of the supported (PXE, USB, ...) medias to boot the to be updated machine running Node
*   The update is non destructive, that means all your configurations will be kept

<!-- -->

*   Select "Start Ovirt Node" in the boot menu
*   In the TUI you should be prompted to "Upgrade <current version> to <new version>"
    -   Press ENTER to continue
*   Select the keyboard layout
*   Enter - at least - the current admin password. This is a security check to ensure that not someone else overrides your installation.
    -   You can also enter a new admin password in the additional fields
*   (oVirt Node is beeing updated)
*   Press ENTER to reboot
*   The updated oVirt Node is started by default
    -   A backup entry was added to the bootmenu, select this backup if the new version can not be booted or leads to problems
