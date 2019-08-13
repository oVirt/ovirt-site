---
title: Configuring Storage
---

# Chapter 9: Configuring Storage

## Introduction to Storage

A storage domain is a collection of images that have a common storage interface. A storage domain contains complete images of templates and virtual machines (including snapshots), ISO files, and metadata about themselves. A storage domain can be made of either block devices (SAN - iSCSI or FCP) or a file system (NAS - NFS, GlusterFS, or other POSIX compliant file systems).

There are two types of storage domain:

* **Data Domain:** A data domain holds the virtual hard disks and OVF files of all the virtual machines and templates in a data center, and cannot be shared across data centers. Data domains of multiple types (iSCSI, NFS, FC, POSIX, and Gluster) can be added to the same data center, provided they are all shared, rather than local, domains.

    **Important:** You must have one host with the status of **Up** and have attached a data domain to a data center before you can attach an ISO domain and an export domain.

* **ISO Domain:** ISO domains store ISO files (or logical CDs) used to install and boot operating systems and applications for the virtual machines, and can be shared across different data centers. An ISO domain removes the data center's need for physical media. ISO domains can only be NFS-based. Only one ISO domain can be added to a data center.

    **Important:** ISO domains have been deprecated. ISO images should be uploaded directly to data domains from the Administration Portal.

    **Important:** If your host is booting from SAN storage and loses connectivity to the storage, the storage file systems become read-only and remain in this state after connectivity is restored.

    To prevent this situation, Red Hat recommends adding a drop-in multipath configuration file for the boot LUN to ensure that it is queued when there is a connection:

          # cat /etc/multipath/conf.d/host.conf
          multipaths {
              multipath {
                  wwid boot_LUN_wwid
                  no_path_retry queue
              }

See the next section to attach existing FCP storage as a data domain. More storage options are available in the [Administration Guide](/documentation/admin-guide/administration-guide/).

## Adding FCP Storage

The oVirt platform supports SAN storage by creating a storage domain from a volume group made of pre-existing LUNs. Neither volume groups nor LUNs can be attached to more than one storage domain at a time.

oVirt system administrators need a working knowledge of Storage Area Networks (SAN) concepts. SAN usually uses Fibre Channel Protocol (FCP) for traffic between hosts and shared external storage. For this reason, SAN may occasionally be referred to as FCP storage.

The following procedure shows you how to attach existing FCP storage to your oVirt environment as a data domain. For more information on other supported storage types, see "Storage" in the [Administration Guide](/documentation/admin-guide/administration-guide/).

**Adding FCP Storage**

1. Click the **Storage** &rarr; **Domains** to list all storage domains.

2. Click **New Domain**.

3. Enter the **Name** of the storage domain.

4. Use the **Data Center** drop-down menu to select an FCP data center.

    If you do not yet have an appropriate FCP data center, select `(none)`.

5. Select the **Domain Function** and the **Storage Type** from the drop-down menus. The storage domain types that are not compatible with the chosen data center are not available.

6. Select an active host in the **Use Host** field. If this is not the first data domain in a data center, you must select the data center's SPM host.

    **Important:** All communication to the storage domain is through the selected host and not directly from the oVirt Engine. At least one active host must exist in the system and be attached to the chosen data center. All hosts must have access to the storage device before the storage domain can be configured.

7. The **New Domain** window automatically displays known targets with unused LUNs when **Data / Fibre Channel** is selected as the storage type. Select the **LUN ID** check box to select all of the available LUNs.

8. Optionally, you can configure the advanced parameters.

    i. Click **Advanced Parameters**.

    ii. Enter a percentage value into the **Warning Low Space Indicator** field. If the free space available on the storage domain is below this percentage, warning messages are displayed to the user and logged.

    iii. Enter a GB value into the **Critical Space Action Blocker** field. If the free space available on the storage domain is below this value, error messages are displayed to the user and logged, and any new action that consumes space, even temporarily, will be blocked.

    iv. Select the **Wipe After Delete** check box to enable the wipe after delete option. This option can be edited after the domain is created, but doing so will not change the wipe after delete property of disks that already exist.

    v. Select the **Discard After Delete** check box to enable the discard after delete option. This option can be edited after the domain is created. This option is only available to block storage domains.

9. Click **OK** to create the storage domain and close the window.

The new FCP data domain displays in **Storage** &rarr; **Domains**. It will remain with a `Locked` status while it is being prepared for use. When ready, it is automatically attached to the data center.

**Prev:** [Chapter 8: Adding a Host to the oVirt Engine](chap-Adding_a_Host_to_the_oVirt_Engine) <br>
**Next:** [Appendix A: Changing the Permissions for the Local ISO Domain](appe-Changing_the_Permissions_for_the_Local_ISO_Domain)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/chap-configuring_storage)
