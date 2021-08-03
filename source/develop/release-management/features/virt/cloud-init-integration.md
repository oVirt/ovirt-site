---
title: Cloud-Init Integration
authors:
  - amedeos
  - danken
  - gpadgett
  - herrold
  - ofrenkel
  - sven
  - vfeenstr
---

# Cloud-Init Integration

## Summary

[Cloud-init](https://launchpad.net/cloud-init/) [1] is a tool used to perform initial setup on cloud nodes, including networking, SSH keys, timezone, user data injection, and more. It is a service that runs on the guest, and supports various Linux distributions including Fedora, RHEL, and Ubuntu.

Integrating support for it into oVirt will help facilitate provisioning of virtual machines. It's already in wide use by cloud software such as OpenStack (via Heat) as well as providers such as Amazon, and its capabilities are a natural fit in our environment.

## Owner

*   Name: Greg Padgett
*   Email: gpadgett@redhatdotcom

## Current Status

Implementation

[existing functionality since 3.3.2](https://bugzilla.redhat.com/show_bug.cgi?id=1039009) can't use cloud-init /run once via api

[existing functionality since 3.4.0](https://bugzilla.redhat.com/show_bug.cgi?id=1045484) REST API cloud init: can't set root password [using json]

[open RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1330217) Enable configuring IPv6 in VM cloud-init (planned to be implemented in 4.2.0)

## Detailed Description

**Use Case**

Use of cloud-init to help provision a guest requires that the guest have cloud-init installed. For cloud instances, this is typically done during image creation; in our use case, it would be installed on a VM or template.

The package currently supports Fedora, RHEL, Debian, and Ubuntu (and compatible derivatives). Initially, we'd like to support Fedora (18), RHEL (6.4), and Ubuntu (12.04 LTS).

After package installation, cloud-init will start during the boot process and looks for various "data sources" that supply it with instructions on what to configure. These sources can be local configuration data stored on the VM itself, an attached block device (config disk) identified by a specific volume labels and directory structure, or a metadata server accessible via the network at a predefined IP address. We'll be using a config disk, which will allow the engine to create and attach data to the VMs dynamically based on user preferences, as well as allowing a user to attach their own already-prepared config disks.

Note that there are multiple config disk types supported by cloud-init, each with their own varying structures and capabilities. We are most interested in using config-drive version 2 [2], which is also in supported by OpenStack.

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
*   set timezone
*   add ssh authorized keys for root user
*   set static IP (address/mask/gateway) for both IPv4 and IPv6 stacks
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

![](/images/wiki/Cloud-init-ui-mock-up.png)

**Screenshot**

![](/images/wiki/Cloud-init-webadmin-screenshot.png)

**API Design**

Example of usage:

```xml
<vm>
  …
  <initialization>
      <host>
        <address>cloudInitInstanceName</address>
      </host>
      <authorized_keys>
        <authorized_key>
          <user>
            <user_name>root</user_name>
          </user>
          <key>ssh-rsa AAAAB3Nza[…]75zkdD user@domain.com</key>
        </authorized_key>
      </authorized_keys>
      <regenerate_ssh_keys>true</regenerate_ssh_keys>
      <timezone>Asia/Jerusalem</timezone>
      <users>
        <user>
          <user_name>root</user_name>
          <password>myPass</password>
        </user>
      </users>
      <dns_search>qa.lab redhat.com</dns_search>
      <dns_servers>8.8.8.8 127.0.0.1</dns_servers>
      <nic_configurations>
        <nic_configuration>
          <name>eth0</name>
          <boot_protocol>static</boot_protocol>
          <ip>
            <address>192.168.2.11</address>
            <netmask>255.255.255.0</netmask>
            <gateway>192.168.2.1</gateway>
          </ip>
          <ipv6_boot_protocol>static</ipv6_boot_protocol>
          <ipv6>
            <address>2001::1234</address>
            <netmask>64</netmask>
            <gateway>2001::fffa</gateway>
          </ipv6>
          <on_boot>true</on_boot>
        </nic_configuration>
        <nic_configuration>
          <name>eth1</name>
          <boot_protocol>dhcp</boot_protocol>
          <ipv6_boot_protocol>none</ipv6_boot_protocol>
        </nic_configuration>
        <nic_configuration>
          <name>eth2</name>
          <boot_protocol>none</boot_protocol>
          <ipv6_boot_protocol>autoconf</ipv6_boot_protocol>
          <on_boot>true</on_boot>
        </nic_configuration>
      </nic_configurations>
      <files>
        <file>
          <name>/tmp/testFile1.txt</name>
          <content>temp content</content>
          <type>PLAINTEXT</type>
        </file>
      </files>
  </initialization>
</vm>
```

**Python SDK**

Example of usage, setting hostname, root password and writing simple text file:

```python
vmstat = vm.get_status().state
if vmstat == 'down':
    
    try:
        osVersion = vm.get_os().get_type()
        if (osVersion == "rhel_6x64" or osVersion == "rhel_6" or osVersion == "rhel_7x64") and CLOUDINIT == "yes":
            print "Starting VM: " + vm.name + " with cloud-init options"
            scontent = "write_files:\n-   content: |\n        search example.com\n        nameserver 10.10.10.1\n        nameserver 10.10.10.2\n    path: /etc/resolv.conf"
            action = params.Action(
                vm=params.VM(
                    initialization=params.Initialization(
                        cloud_init=params.CloudInit(
                            host=params.Host(address="rheltest001.example.com"),
                            users=params.Users(
                                user=[params.User(user_name="root", password="secret")]
                                ),
                            files=params.Files(
                                file=[params.File(name="/etc/resolv.conf", content=scontent, type_="PLAINTEXT")]
                                )
                            )
                        )
                    )
                )
            vm.start( action )
        else:
            print "Starting VM " + vm.name
            vm.start()
        while vmstat != 'down':
            sleep(1)
            vmstat = vm.get_status().state
    except Exception, err:
        print "Error on starting VM"
        print err
```

Same as above, but setting also networking:

```python
action = params.Action(
           vm=params.VM(
               initialization=params.Initialization(
                   cloud_init=params.CloudInit(
                       host=params.Host(address="testvm.example.com"),
                       authorized_keys=params.AuthorizedKeys(
                           authorized_key=[params.AuthorizedKey(user=params.User(user_name="root"), key="ssh-rsa AAAAB3NzaC1yc.........")]
                           ),
                       regenerate_ssh_keys=True,
                       users=params.Users(
                           user=[params.User(user_name="root", password="SecretPassword")]
                           ),
                       network_configuration=params.NetworkConfiguration(
                           nics=params.Nics(nic=[params.NIC(name="eth0",
                                               boot_protocol="STATIC",
                                               on_boot=True,
                                               network=params.Network(ip=params.IP(
                                                                       address="192.168.100.10",
                                                                       netmask="255.255.255.0",
                                                                       gateway="192.168.100.1")))])
                           ),
                       files=params.Files(
                           file=[params.File(name="/etc/motd", content="Automatic configuration", type_="PLAINTEXT")]
                           )
                       )
                   )
               )
           )
```

## Required Changes

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

## Benefit to oVirt

Integrating with cloud-init will make provisioning Linux VMs easier for admins, decreasing the amount of setup time needed and streamlining support for attaching existing config disks to feed data to cloud-init.

## Dependencies / Related Features

Related features:

*   [Features/VMPayload](/develop/release-management/features/virt/vmpayload.html)
*   [Features/Intial Run Vm tab](/develop/release-management/features/virt/intial-run-vm-tab.html)

## Documentation / External References

<references>
1.  [5]
2.  [6]
3.  [7]
4.  [8]

</references>
## Testing

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

Under 'Initial Run' click 'Use Cloud-Init'

Fill in some initialization fields as described in the screenshot above

Click 'OK'

Connect to the VM and observe the CD indeed attached and other changes filled before were applied.



[1] 

[2] 

[3] 

[4] 

[5] Cloud-init documentation: <https://launchpad.net/cloud-init/>

[6] 

[7] 

[8] User-data example: <https://github.com/canonical/cloud-init/blob/master/doc/examples/cloud-config.txt>
