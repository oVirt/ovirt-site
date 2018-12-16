---
title: System Accounts
---

# Appendix F: System Accounts

## oVirt Engine User Accounts

A number of system user accounts are created to support oVirt when the **ovirt-engine** package is installed. Each system user has a default user identifier (UID). The system user accounts created are:

* The **vdsm** user (UID `36`). Required for support tools that mount and access NFS storage domains.

* The **ovirt** user (UID `108`). Owner of the **ovirt-engine** JBoss Enterprise Application/Wildfly Platform instance.

* The **ovirt-vmconsole** user (UID `498`). Required for the guest serial console.

## oVirt Engine Groups

A number of system user groups are created to support oVirt when the `rhevm` package is installed. Each system user group has a default group identifier (GID). The system user groups created are:

* The **kvm** group (GID `36`). Group members include:

* The **vdsm** user.

* The **ovirt** group (GID `108`). Group members include:

* The **ovirt** user.

* The **ovirt-vmconsole** group (GID `498`). Group members include:

* The **ovirt-vmconsole** user.

## Virtualization Host User Accounts

A number of system user accounts are created on the virtualization host when the `vdsm` and `qemu-kvm-rhev` packages are installed. Each system user has a default user identifier (UID). The system user accounts created are:

* The **vdsm** user (UID `36`).

* The **qemu** user (UID `107`).

* The **sanlock** user (UID `179`).

* The **ovirt-vmconsole** user (UID `498`).

    **Important:** The user identifiers (UIDs) and group identifiers (GIDs) allocated may vary between systems. The **vdsm** user is fixed to a UID of `36` and the **kvm** group is fixed to a GID of `36`.

    If UID `36` or GID `36` is already used by another account on the system a conflict will arise during installation of the `vdsm` and `qemu-kvm-rhev` packages.

## Virtualization Host Groups

A number of system user groups are created on the virtualization host when the **vdsm** and **qemu-kvm-rhev** packages are installed. Each system user group has a default group identifier (GID). The system user groups created are:

* The **kvm** group (GID `36`). Group members include:

* The **qemu** user.

* The **sanlock** user.

* The **qemu** group (GID `107`). Group members include:

* The **vdsm** user.

* The **sanlock** user.

* The **ovirt-vmconsole** group (GID `498`). Group members include:

* The **ovirt-vmconsole** user.

    **Important:** The user identifiers (UIDs) and group identifiers (GIDs) allocated may vary between systems. The **vdsm** user is fixed to a UID of `36` and the **kvm** group is fixed to a GID of `36`.

    If UID `36` or GID `36` is already used by another account on the system a conflict will arise during installation of the `vdsm` and `qemu-kvm-rhev` packages.

**Prev:** [Appendix E: Branding](appe-Branding)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/appe-system_accounts)
