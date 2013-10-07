---
title: Cloud-Init Integration
authors: amedeos, danken, gpadgett, herrold, ofrenkel, sven, vfeenstr
wiki_title: Features/Cloud-Init Integration
wiki_revision_count: 18
wiki_last_updated: 2014-12-22
wiki_warnings: references
---

# Cloud-Init Integration

### Summary

[Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating support for it into oVirt will help facilitate provisioning of virtual machines. It's already in wide use by cloud software such as OpenStack (via Heat) as well as providers such as Amazon, and its capabilities are a natural fit in our environment.

### Owner

*   Name: Greg Padgett
*   Email: gpadgett@redhatdotcom

### Current Status

Implementation

### Detailed Description

**Use Case**

Use of cloud-init to help provision a guest requires that the guest have cloud-init installed. For cloud instances, this is typically done during image creation; in our use case, it would be installed on a VM or template.

The package currently supports Fedora, RHEL, Debian, and Ubuntu (and compatible derivatives). Initially, we'd like to support Fedora (18), RHEL (6.4), and Ubuntu (12.04 LTS).

After package installation, cloud-init will start during the boot process and looks for various "data sources" that supply it with instructions on what to configure. These sources can be local configuration data stored on the VM itself, an attached block device (config disk) identified by a specific volume labels and directory structure, or a metadata server accessible via the network at a predefined IP address. We'll be using a config disk, which will allow the engine to create and attach data to the VMs dynamically based on user preferences, as well as allowing a user to attach their own already-prepared config disks.

Note that there are multiple config disk types supported by cloud-init, each with their own varying structures and capabilities. We are most interested in using [config-drive version 2](http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/sources/configdrive/README.rst) [2], which is also in supported by OpenStack.

Once cloud-init discovers a data source, it scans it for meta-data and user-data. Generally, meta-data contains information about the cloud that is passed to the guest (instance identification, network setup, etc [3]), whereas user-data contains instructions on provisioning the specific system in question (usernames/passwords to configure, timezone, custom scripts to run, packages to install, files to inject, etc [4]). If cloud-init has not previously seen the supplied instance identifier (i.e. this is a new configuration), it will proceed to set up the system accordingly. The end result is a system with all basic provisioning complete before the first login.

In summary, a typical workflow for using cloud-init in oVirt to assist in guest provisioning might involve:

*   Create new VM
*   Install OS
*   Install cloud-init
*   (Create template if desired)
*   Configure cloud-init options through webadmin or rest api, or attach disk/payload with pre-constructed config disk
*   Start VM
*   Wait (usually just seconds) for cloud-init configuration to complete
*   VM is configured and ready for use

TODO: still pending is whether and/or how to communicate to oVirt engine that cloud-init has finished guest setup, set vm initialized flag, ...

**Functionality**

There is a long list of configuration options supported by cloud-init. The ones we are currently targeting for inclusion in oVirt include:

*   set root password
*   set timezone\*
*   add ssh authorized keys for root user
*   set static networking (ip/mask/gw/etc)\*
*   set and persist hostname\*
*   inject user data/files to guest disk

Some additional options for later investigation:

*   create users and/or set user passwords
*   auto-generate system ssh key (public & private) - should consider using [virtio-rng before doing so](http://libvirt.org/formatdomain.html#elementsRng)
*   assign system ssh key to user-specified value (public & private)
*   "phone home" once system is up
*   shut down and/or reboot
*   run custom scripts and/or commands
*   set system locale

In addition, there are some usability goals for the project:

*   allow guest setup with default cloud-init package installation (no custom configuration steps necessary)\*
*   don't create additional user only for cloud-init setup (e.g. ec2-user)
*   after reboot, cloud-init shouldn't cause a delay due to no data source being present\*

(\* Items with asterisk indicate that a workaround or bugfix is needed, these are expected by the time the feature is ready.)

**\1**

*   Config disks will be attached to VMs as ISOs using the VM Payload feature, so both a payload and cloud-init configuration cannot be used at the same time. However, cloud-init can be used to inject files into the guest, effectively an alternate way to deliver a payload.

**UI Mock-Up**

Details subject to change:

![](cloud-init-ui-mock-up.png "cloud-init-ui-mock-up.png")

**Screenshot**

![](cloud-init-webadmin-screenshot.png "cloud-init-webadmin-screenshot.png")

**API Design**

Details TBD, maybe something like this:

<vm>
       ...
`   `<initialization type='cloud-init'>
`       `<network>
`           `<interface name='eth0'>
`               `<proto>`static`</proto>
`               `<ip>`192.168.0.25`</ip>
`               `<netmask>`24`</netmask>
`               `<gateway>`192.168.0.1`</gateway>
`               `<onboot>`true`</onboot>
`               `<dns-nameservers>
`                  `<dns-nameserver>`192.168.0.1`</dns-nameserver>
`               `</dns-nameservers>
`               `<dns-search>`domain.com`</dns-search>
`           `</interface>
`       `</network>
`       `<hostname>`vm01`</hostname>
`       `<authorized_keys>
`           `<key user='root'>`ssh-rsa AAAAB3Nza[...]sODU/NH+w== user@domain.com`</key>
`       `</authorized_keys>
`       `<timezone>`Antarctica/South_Pole`</timezone>
`       `<files>
`           `<file>
`               `<path>`/usr/local/bin/hello.py`</path>
`               `<permissions>`0777`</permissions>
`               `<content encoding='base64'>`IyEvdXNyL2Jpbi9weXRob24KcHJpbnQgJ0hlbGxvIFdvcmxkIScK`</content>
`           `</file>
`       `</files>
`   `</initialization>
</vm>

### Required Changes

Further details TBD

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
*   <http://www.ovirt.org/Features/Intial_Run_Vm_tab>

### Documentation / External References

<references>
1.  [5]
2.  [6]
3.  [7]
4.  [8]

</references>
### Testing

*   Test case: **Initialize vm parameters**
    -   setup:

Create VM in 3.3 cluster

Make sure the vm OS is set correctly ("Other Linux" should be a good choice to fit any linux)
:Install latest Fedora/RHEL/Ubuntu and install cloud-init package ("yum/apt-get install cloud-init")
:When done shut down the vm.

*   -   test:

Click 'run-once' in the webadmin, under 'Inital Run' click 'Use Cloud-Init'

Fill in some initialization fields as described in the screenshot above

Click 'OK'

Connect to the VM and observe the changes filled before were applied.

*   Test case: **Initialize vm parameters and attach a CD**
    -   setup:

Same as first test

*   -   test:

Click 'run-once' in the webadmin, under Boot select 'attach CD' and select any cd to attach to the vm

Under 'Inital Run' click 'Use Cloud-Init'

Fill in some initialization fields as described in the screenshot above

Click 'OK'

Connect to the VM and observe the CD indeed attached and other changes filled before were applied.

### Comments and Discussion

*   Refer to [Talk:Cloud-Init Integration](Talk:Cloud-Init Integration)

[1] 

[2] 

[3] 

[4] 

[5] Cloud-init documentation: <https://launchpad.net/cloud-init/>

[6] Config-Drive version 2 readme: <http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/sources/configdrive/README.rst>

[7] OpenStack meta-data example: <http://docs.openstack.org/grizzly/openstack-compute/admin/content/config-drive.html>

[8] User-data example: <http://bazaar.launchpad.net/~cloud-init-dev/cloud-init/trunk/view/head:/doc/examples/cloud-config.txt>
