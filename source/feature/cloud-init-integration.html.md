---
title: Cloud-Init Integration
authors: amedeos, danken, gpadgett, herrold, ofrenkel, sven, vfeenstr
wiki_title: Features/Cloud-Init Integration
wiki_revision_count: 18
wiki_last_updated: 2014-12-22
---

# Cloud-Init Integration

### Summary

Cloud-init (link) is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating support for it into oVirt will help facilitate provisioning of virtual machines. It's already in wide use by cloud software such as OpenStack (via Heat) as well as providers such as Amazon, and its capabilities are a natural fit in our environment.

### Owner

*   Name: Greg Padgett
*   Email: gpadgett@redhatdotcom

### Current Status

Planning / investigation

### Detailed Description

**Use Case**

Use of cloud-init to help provision a guest requires that the guest have cloud-init installed. For cloud instances, this is typically done during image creation; in our use case, it would be installed on a VM or template.

The package currently supports Fedora, RHEL, Debian, and Ubuntu (and compatible derivatives). Initially, we'd like to support Fedora (18), RHEL (6.4), and Ubuntu (12.04 LTS).

After package installation, cloud-init will start during the boot process and looks for various "data sources" that supply it with instructions on what to configure. These sources can local configuration data stored on the VM itself, attached block devices (config disks) containing specific volume labels and directory structures, and metadata servers accessible via the network at a predefined IP address. We'll be using a config disks, which will allow the engine to create and attach data to the VMs dynamically based on user preferences, as well as allowing a user to attach their own already-prepared config disks.

Once cloud-init discovers a data source, it scans it for meta-data and user-data. Generally, meta-data contains information about the cloud that is passed to the guest (instance identification, network setup, etc [1]), whereas user-data contains instructions on provisioning the specific system in question (usernames/passwords to configure, timezone, custom scripts to run, packages to install, etc [2]). Cloud-init will then act on this information, configuring the system as desired so that is it ready for use without requiring a login or other manual configuration steps.

In summary, a typical workflow for using cloud-init in oVirt to assist in guest provisioning might involve:

*   Create new VM
*   Install OS
*   Install cloud-init
*   (Create template if desired)
*   Configure cloud-init options through webadmin or rest api, or attach disk/payload with pre-constructed config disk
*   Start VM
*   Wait (usually just seconds) for cloud-init configuration to complete
*   VM is configured and ready for use

TODO: still pending is whether and/or how to communicate to oVirt engine that cloud-init has finished guest setup.

**Functionality**

There is a long list of configuration options supported by cloud-init. The ones we are currently targeting for inclusion in oVirt include:

*   set root password
*   set user passwords
*   set timezone\*
*   add ssh authorized keys for root user
*   auto-generate system SSH key (public & private)
*   set static networking (ip/mask/gw/etc)\*
*   set and persist hostname\*
*   inject user data/files to guest disk

In addition, there are some usability goals for the project:

*   allow guest setup with default cloud-init package installation (no custom configuration steps necessary)\*
*   don't create additional user only for cloud-init setup (e.g. ec2-user)
*   after reboot, cloud-init shouldn't cause a delay due to no data source being present\*
*   be compatible with multiple data sources (ConfigDrive, NoCloud, ...)

(\* Items with asterisk indicate that a workaround or bugfix is needed)

**\1**

*   The primary config disk format for oVirt to use is still undecided, though ConfigDrive looks like a good choice.
*   Config disks will be attached to VMs as ISOs using the VM Payload feature, so both a payload and cloud-init configuration cannot be used at the same time.

**API Design**

TBD

### Required Changes

Further details and UI mock-up TBD

*   UI
    -   Modifications to store config options from user (location TBD)
    -   Method to disallow having both payload and cloud-init configuration
*   REST API
    -   Allow specification of cloud-init configuration options
    -   Payload type configuration (i.e. like sysprep type, also with option to support different config disk types either now or in the future)
*   Engine/Backend/Db
    -   Create config disk from passed-in configuration options
*   VDSM
    -   Support custom volume label for vm payloads

### Benefit to oVirt

Integrating with cloud-init will make provisioning Linux VMs easier for admins, decreasing the amount of setup time needed and streamlining support for attaching existing config disks to feed data to cloud-init.

### Dependencies / Related Features

Related features:

*   <http://www.ovirt.org/Features/VMPayload>
*   <http://wiki.ovirt.org/Features/Intial_Run_Vm_tab>

### Documentation / External References

[1] OpenStack meta-data example: <http://docs.openstack.org/trunk/openstack-compute/admin/content/config-drive.html> [2] User-data example: <http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/examples/cloud-config.txt> [3] Cloud-init documentation: <https://launchpad.net/cloud-init>

### Comments and Discussion

*   Refer to [Talk:Cloud-Init Integration](Talk:Cloud-Init Integration)
