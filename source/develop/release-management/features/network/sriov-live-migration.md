---
title: SR-IOV Live Migration without downtime
category: feature
authors: amusil
---

# SR-IOV Live Migration without downtime

## Summary

This feature allows you to migrate VM that is connected via SR-IOV with
a minimal network downtime and supersedes the [Live Migration Support For SRIOV][1]
that required additional configuration inside affected VM.

The state of the feature is tracked in [[RFE] [SR-IOV] Migration should not require downtime as of today][2].
Related patches can be found on [gerrit topic:sriov_live_migration][3].

## Owner

*   Name: [Ales Musil](https://github.com/almusil)

*   Email: <amusil@redhat.com>


## Detailed Description

In order to migrate a VM that is connected to SR-IOV passthrough profile
we need to first unplug the SR-IOV device from a VM on the source, migrate
the VM and plug SR-IOV device on the destination. This causes longer downtime
during which the VM is not connected to the network.

The current implementation allowed to mitigate this downtime
[Live Migration Support For SRIOV][1], however this approach required manual
configuration to be done in the guest which is not convenient for large setups.

In order to achieve minimal downtime the [NET_FAILOVER][4] support was added
to Linux kernel. The driver provides automated mechanism which is transparent
to the VM, and the user space. It is achieved by `failover` netdev which acts
as master device and controls two slave devices, the `primary` device being
SR-IOV passtrough and the virtio as `standby`. The VM user access network
through the `failover` device.

There is still need to provide two interfaces, the SR-IOV passtrough device
and virtio device, to the affected VM, but the  overall configuration overhead
has been reduced to selecting suitable vNIC profile pair.


## Prerequisites

The implementation requires a [Linux kernel][5], [libvirt][6] and [qemu][7]
support with `net_failover`.

The [Linux kernel][5] support has to be only on guest side.

## Limitations

* In addition to the SR-IOV NIC, a linux-bridge based has to be connected to the source, and the destination host.
* Because of the required support in the guest, only RHEL8 (Linux kernel version >=4.18 or >=5.10) and Windows
  (Windows VirtIO Drivers >=0.1.189) guests are supported.
* Hosts with Cluster level version of >=4.6 are required.
* Updating of the vNIC profile acting as `failover` is not allowed.
* Due to internal implementation details attaching two `VF`s, that are using the same `failover` vNIC profile,
  to the same VM will fail in libvirt.

## Implementation

### Entity Description

vNIC profile will get a new attribute that will point to the failover virtio
vNIC profile. This selection will be only available with `Passthrough` and `Migratable`
selected.

### User Experience

Upon creation of vNIC profile, the user can enable failover and select
the failover network vNIC profile. The `Failover` selection is available
only for `Passthrough` and `Migratable` vNIC profiles.

REST API takes an additional parameter for vNIC called `failover`
containing id of the failover vNIC profile:

```
<vnic_profile id="123">
  <name>vNIC_name</name>
  <pass_through>
    <mode>enabled</mode>
  </pass_through>
  <migratable>true</migratable>
  <failover id="456"/>
</vnic_profile>
```

VM interface then requires only single vNIC profile that has the `failover` attribute
in order to utilize this behavior.

### Engine backend

As engine is responsible for creating XML for a new VM nic, the
appropriate XML will be created and provided to libvirt.

In order to ensure that the virtio network is available the migration policy needs to be updated.

The `ActivateDeactivateVmNicCommand` will be updated to handle plug/unplug of the failover nic, when needed.
During migration the command will ensure that only `VF` VM nic is unplugged and then plugged back, any other
user interaction will affect both `VF` and `failover` VM nic.

As mentioned in the [Limitations](#limitations), new cluster level is required to ensure correct package version
of libvirt and qemu.

### Libvirt XML

If the feature is activated for a new VM nic, the libvirt XML definition
contains an additional network with attribute [teaming element][8],
as follows:

```
<devices>
  <interface type='bridge'>
    <mac address='00:11:22:33:44:55' />
    <model type='virtio' />
    <link state='up' />
    <source bridge='ovirtmgmt' />
    <mtu size='1500' />
    <alias name='ua-virtio-net' />
    <teaming type='persistent'/>
  </interface>
  <interface managed='no' type='hostdev'>
    <mac address='00:11:22:33:44:55' />
    <source>
      <address bus='0xb3' domain='0x0000' function='0x3' slot='0x02' type='pci' />
    </source>
    <link state='up' />
    <driver name='vfio' />
    <alias name='ua-sriov-hostdev' />
    <teaming type='transient' persistent='ua-virtio-net'/>
  </interface>
</devices>
```

### Vdsm

Because of the current rule that `VF` and `failover` have same MAC address, vdsm code needs to adjusted
to account for that. In order to achieve that, vdsm will require matching of alias and MAC address if the
interface xml contains `teaming` attribute.

## Installation/Upgrade

The feature will not affect new or existing installations.

## Testing

To test this feature, the desired VM with SR-IOV failover
configured, should be migrated to a different host.

## Open qeustions

* An allowed limit of packet drop during migration?
* Can the virtio device be connected to the same PF as VF?


## Documentation & External references

[Live Migration Support For SRIOV][1]

[1]: https://www.ovirt.org/develop/release-management/features/network/liveMigrationSupportForSRIOV.html

[Bug 1688177 - [RFE] [SR-IOV] Migration should not require downtime as of today][2]

[2]: https://bugzilla.redhat.com/show_bug.cgi?id=1688177

[gerrit topic:sriov_live_migration][3]

[3]: https://gerrit.ovirt.org/#/q/topic:sriov_live_migration

[Linux: NET_FAILOVER][4]

[4]: https://www.kernel.org/doc/html/latest/networking/net_failover.html

[Linux: net: Introduce generic failover module][5]

[5]: https://github.com/torvalds/linux/commit/30c8bd5aa8b2c78546c3e52337101b9c85879320

[qemu: net/virtio: add failover support][6]

[6]: https://github.com/patchew-project/qemu/commit/9711cd0dfc3fa414f7f64935713c07134ae67971

[Bug 1693587 - RFE: support for net failover devices in libvirt][7]

[7]: https://bugzilla.redhat.com/show_bug.cgi?id=1693587

[Teaming a virtio/hostdev NIC pair][8]

[8]: https://libvirt.org/formatdomain.html#teaming-a-virtio-hostdev-nic-pair
