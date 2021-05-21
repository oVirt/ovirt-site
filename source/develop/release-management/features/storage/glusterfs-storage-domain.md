---
title: GlusterFS Storage Domain
category: feature
authors:
  - derez
  - dpkshetty
  - moti
  - sahina
  - sandrobonazzola
  - shtripat
  - snmishra
  - thildred
  - dchaplyg
---

# GlusterFS Storage Domain

# Summary

This feature introduces a new storage domain of type GLUSTERFS_DOMAIN, which uses gluster as the storage backend.

In GLUSTERFS_DOMAIN, vdsm creates the storage domain by mounting the gluster volume (akin to nfs mounting export path).
VMs created using this domain exploit the QEMU's gluster block backend aka QEMU-GlusterFS native integration.

# Owner

*   Feature owner: Deepak C Shetty <deepakcs@linux.vnet.ibm.com>
    -   REST Component owner:
    -   Engine Component owner: Sharad Mishra <snmishra@linux.vnet.ibm.com>
    -   VDSM Component owner: Deepak C Shetty <deepakcs@linux.vnet.ibm.com>
    -   QA Owner:

# Current Status - Feature Implemented

*   **QEMU-GlusterFS integration** : Done. Available in upstream qemu.
*   **libvirt enablement for Gluster** : Done. Available in upstream libvirt
*   **GLUSTERFS_DOMAIN support in VDSM** : Done. Available in upstream oVirt
*   **oVirt Engine / UI support** : Done. Available in upstream oVirt

# Detailed Description

The current supported way of exploiting GlusterFS as a storage domain is to use POSIXFS_DOMAIN. This works out of the box and since GlusterFS is posix compliant, it fits well under POSIXFS_DOMAIN.
But it doesn't exploit QEMU-GlusterFS native integration, hence has performance overhead and is not the ideal way to consume images hosted in GlusterFS volumes.
POSIXFS_DOMAIN causes QEMU to consume images via GlusterFS mount point, hence incurs FUSE overhead.

GLUSTERFS_DOMAIN support in VDSM exploits QEMU-GlusterFS native integration, hence provides a better & efficient way to access images hosted in GlusterFS volumes.
QEMU-GlusterFS native integration adds Gluster as a block backend to QEMU. QEMU talks with Gluster volume via libgfapi interface of GlusterFS, which does not incur FUSE overhead.
GlusterFS fits as a network block device (<disk type=network.../>) in libvirt XML.

| POSIXFS_DOMAIN                                         | GLUSTERFS_DOMAIN                                                                |
|---------------------------------------------------------|----------------------------------------------------------------------------------|
| Image accessed as a file.                               | Image accessed as a network block device.                                        |
| Eg: -drive file=<path/to/gluster/mount>/<path/to/image> | Eg: -drive file=gluster[+transport]://[server[:port]]/volname/image[?socket=...] |
| Maps to <disk type=file..>...</disk> in libvirt xml.    | Maps to <disk type=network..>...</disk> in libvirt xml.                          |
| FUSE overhead.                                          | No FUSE overhead.                                                                |

## Approach

In VDSM, we mainly add support for

*   GlusterStorageDomain class (and its associated baggage) to represent the new storage domain.
*   GlusterVolume class to represent image hosted in GlusterFS volume.
*   Support in libvirtvm for network block device libvirt XML generation.

Note that on the domain side, VDSM still uses gluster mount point as the root of domain dir, but on the VM side it exploits QEMU-GlusterFS native integration.

## Important Pre-requisites

*   If the GlusterFS volume is created using oVirt's GlusterFS GUI, then don't forget to click on "Optimize for virt. store" which helps set the right permissions and enables the optimum GlusterFS translators for virtualization usecase
    -   If the GlusterFS volume was created manually, then ensure the below options are set on the volume, so that its accessible from oVirt
        -   volume set <volname> storage.owner-uid=36
        -   volume set <volname> storage.owner-gid=36
*   The below settings/options of GlusterFS volume must also be enabled for it to be able to work as a oVirt storage domain. Currently its not possible to set these from oVirt GlusterFS GUI
    -   option rpc-auth-allow-insecure on ==> in glusterd.vol (ensure u restart glusterd service... for this to take effect)
    -   volume set <volname> server.allow-insecure on ==> (ensure u stop and start the volume.. for this to take effect)
*   Other packages that are needed on the hypervisor host (aka VDSM host) are...
    -   Needs minm libvirt version 1.0.1 (which has the gluster protocol/network disk support)
    -   Needs qemu version 1.3 (which has the gluster block backend support)
    -   Needs vdsm-gluster plugin, which pulls in all the related requirements (glusterfs, etc)

## Performance Numbers

Performance numbers for QEMU-GlusterFS integration are available @

*   <http://lists.nongnu.org/archive/html/gluster-devel/2012-08/msg00063.html>
*   <http://lists.nongnu.org/archive/html/qemu-devel/2012-07/msg02718.html>
*   For more up to date info on QEMU-GlusterFS integration and performance numbers, visit ....
    -   <http://raobharata.wordpress.com/2012/10/29/qemu-glusterfs-native-integration/>
    -   Check out the "Performance Numbers" section of the above blog

## User interface

### oVirt Engine (OE) support

Support needs to be added to ovirt-engine to list GLUSTERFS_DOMAIN as a new storage domain. This will mostly be similar to how POSIXFS_DOMAIN fits in the OE today.
The same params as specified by user for PosixFs domain will be applicable to GlusterFS as well (spec, vfsType, options).

*   **spec** : volfileserver:volname
*   **vfsType** : glusterfs
*   **options** : if any, will be passed as-is to the mount cmdline.

### Usability enhancements

*   If user selects GlusterFS domain as the domain type, the **vfsType** field can be pre-filled to 'glusterfs' and the field be greyed/disabled (should not be editable).
*   There is a option in OE to enable a gluster volume for virtualization use ( sets some gluster specific options to ensure its works well when used as a storage domain).
     As part of user creating GLUSTERFS_DOMAIN, it would be good to check if the gluster volume (as part of the **spec**) is enabled for virt use, and if not, call the appropriate Gluster OE API to enable the gluster volume for virt use, before using it as storage domain.
     Not sure how this plays when OE is in virt only, gluster only and virt + gluster modes.
*   Another enhancement could be to list the available gluster volumes known to oVirt when user selects GLUSTERFS_DOMAIN as the DC type as part of new storage domain UI flow.
     User can then select the gluster volume he/she created and the **spec** will be formed automatically based on the gluster volume selected by user.
     This provides better usability (seamlessly integrate virt and storage flows/modes of oVirt) and might be useful when OE is in virt + gluster mode.
*   If a Storage Domain is moved to maintenance and selected to be destroyed, the "Destroy storage domain" dialog should include an option to stop and delete the underlying Gluster volume as well. If the option to delete the volume is selected, a further option should be available to purge any data from the volume.
*   While stopping a Gluster volume, the confirmation dialog should mention that the volume is used as a Storage Domain. Once administrator confirms the the stopping of the volume, the corresponding Storage domain should be moved to maintenance mode and then the volume should be stopped.
*   While removal of Gluster volume, the confirmation dialog should mention that the volume is used as a Storage domain. Once administrator confirms the deletion, the corresponding Storage domain should be destroyed and then the volume should be deleted.
*   While starting a Gluster volume, if it's used as a Storage domain, check if the storage domain is in maintenance mode. If so, Storage domain should be activated first and then the volume should be started.

**Here are some screenshots - (a bit old, TODO update latest screenshots)** ![ 1000px](/images/wiki/Gluster.png)

## Usability enhancements in oVirt 3.6

Out of the enhancements listed in the previous section, the following are planned for 3.6

*   Provide a list of gluster volumes when user selects GlusterFS as the storage domain.
    -   If the virt optimization tunables are not set, the engine would set these tunables on the gluster volume.
    -   If the volume is not a 3-way replica, then the user should be warned that this volume is not recommended. (Maybe, prompt and redirect to Modify volume screen to add additional bricks)

<!-- -->

*   In the gluster Volumes tab, add a menu option to Create storage domain. This would show the Storage domain screen with the values prefilled and greyed out.

The above options to be available when oVirt is installed in "Both" mode i.e virt + gluster

## Screencast/Demo

*   A technology video demo / screencast that showcases the use of GlusterFS as a oVirt storage domain is available below...
    -   <http://www.youtube.com/watch?v=0iIuHCz8L04&feature=youtu.be>

# Benefits to oVirt

oVirt 3.1 already has support to create & manage Gluster Volumes (see 'Volumes' tab in oVirt ) - typically done by storage admin.
This support will allow oVirt to consume GlusterFS storage cluster as a storage domain / image repository and run VMs off it - typically done by virtualization admin.
This support helps complete the story/use-case from a virt. admin perspective !
 It also helps oVirt truly work as a single pane of glass solution for creating, managing & consuming Gluster for storage and virt. use cases.

# Dependencies / Related Features and Projects

*   Gluster volume must be pre-setup (either via oVirt or other means) for it to be used as a storage domain.
*   glusterfs, glusterfs-server and glusterfs-fuse rpm packages must be installed.
*   Needs minm libvirt version 1.0.1 (which has the gluster protocol/network disk support)
*   Needs qemu version 1.3 (which has the gluster block backend support)

# Documentation / External references

*   PosixFS Support - [1](/develop/release-management/features/storage/posixfsconnection.html)
*   Gluster home page - [2](http://www.gluster.org/)
*   Using QEMU to boot a VM image on GlusterFS volume - [3](http://www.youtube.com/watch?v=JG3kF_djclg)
*   Storage Virtualization for KVM - [4](http://www.linuxplumbersconf.org/2012/wp-content/uploads/2012/09/2012-lpc-virt-storage-virt-kvm-rao.pdf)

# Testing

## Setting up a GlusterFS storage volume for using it as a storage domain

*   NOTE: You can choose to use the VDSM host itself to serve GlusterFS volume or any other non-VDSM host should work too
*   NOTE: Pls see the Dependencies section above to ensure you have the right versions of the different tools (qemu, libvirt, glusterfs)
*   Creating GlusterFS volume manually
    -   Use GlusterFS cli to create a volume with sufficient space to be used as oVirt storage domain
    -   Set the GlusterFS volume options as specified in the [Features/GlusterFS_Storage_Domain#Important_Pre-requisites](#important-pre-requisites) section (see above)
*   Using oVirt GUI to create GlusterFS volume
    -   Go to 'Volumes' tab in oVirt GUI and setup GlusterFS volume
    -   Click on 'Optimize for virt store' opton, to make the GlusterFS volume accessible by oVirt
    -   Set the GlusterFS volume options as specified in the Pre-req section (see above)

## Making oVirt use the GlusterFS volume as a native storage domain

*   GlusterFS storage domain is similar to any other oVirt storage domain... so the standard steps of.... creating a new DC (select GlusterFS type), cluster and adding host(s) apply.
*   While creating a new storage domain... user will be prompted to provide the GlusterFS volume details (hostname:volumename), which when provided, oVirt will use that GlusterFS volume as a native storage domain.
*   Once storage domain is created, follow usual steps to create a disk, create a new VM, attach disk to VM and start the VM. oVirt will ensure that the VM is started using QEMU's GlusterFS block backend, which provides a efficient way of accessing vmdisk images stored on GlusterFS volumes.
*   A screencast/demo on how to use GlusterFS storage domain in oVirt is available @
    -   <http://www.youtube.com/watch?v=0iIuHCz8L04&feature=youtu.be>

## Making VMs access GlusterFS storage directly

* Enable libgfapi support using `engine-config -s LibgfApiSupported=true`. Libgfapi support is disabled by default due to incompatibility with Live Storage Migration. VM can not be migrated to the GlusterFS storage domain. See [Open Issues](#open-issues) section for details.
* Create a VM and place it's disks on the GlusterFS storage domain
* Just start the VM

# Future Work

*   Provide ability to set all the required options needed for using GlusterFS volume as a storage domain from oVirt GUI
*   GlusterFS as a VDSM repository engine.
*   Support for GlusterFS volume backed by Block backend (Block Device translator)
*   GlusterFS enablement for json-rpc VDSM API

## Open issues

* [BUG-1306562: (https://bugzilla.redhat.com/1306562)[RFE] - Allow virDomainBlockCopy to use remote RBD volumes as the base backing image]
* [BUG-1465810: (https://bugzilla.redhat.com/1465810) - Unable to make snapshot of the VM with disk on replica 3 gluster volume]

[GlusterFS Storage Domain](/develop/release-management/features/) [GlusterFS Storage Domain](/develop/release-management/releases/3.2/feature.html)
