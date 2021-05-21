---
title: Xen
category: how-to
authors:
  - danken
  - sandrobonazzola
---

<!-- TODO: Content review -->

# Configuring Xen Hosts

oVirt uses libvirt to abstract access to its virtual machines. This makes it theoretically possible for oVirt to manage Xen hosts. Trying this out was a goal in [Xen hackathon 2014](http://wiki.xen.org/wiki/Hackathon/May2014#Libvirt_and_Xen_integration_.2F_co-operation).

This is not going to be easy, as oVirt is permeated with KVM-specific assumptions, and Xen (or libvirt's xenlight driver) is currently missing features that are important to oVirt. Still, we've managed to add a Xen dom0 to oVirt and start a VM with Fedora guest.

This page describes the hacked solution, and tracks the known gaps to its fruition.

## What's Done and How to Use It

1.  To manage Xen hosts in oVirt, you first need a Xen host to manage. I followed <http://wiki.xen.org/wiki/Fedora_Host_Installation> to install Xen on Fedora 19. Please note that you'd better set up a bridge named `ovirtmgmt` instead of `br0`. Reboot the host to see that everything is fine, and that you have access to your dom0.
2.  A second step is to installed an unchanged oVirt Engine on a host. I used an [All-in-One](/develop/release-management/features/integration/allinone.html) installation of oVirt, running on my Xen dom0.
3.  I needed to modify Vdsm in so it would be possible to run Xen VMs. My patches are not expected to by accepted upstream, at least not in their current form, so you would need to build Vdsm [from source](/develop/developer-guide/vdsm/developers.html), first applying the [Xen-related patches](http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:xen,n,z). When you build Vdsm, take note of [Vdsm_Developers#Building_with_hooks_support](/develop/developer-guide/vdsm/developers.html#building-with-hooks-support).
4.  Install Vdsm on your dom0. Do not forget to install vdsm-hook-xen.rpm, too.
5.  On your Engine host,

    1.  cat <<EOF >/etc/ovirt-host-deploy.conf.d/50-xen.conf
```
    [environment:enforce]

    VDSM/checkVirtHardware=bool:False

    EOF
```

6.  Log into your Engine's admin portal, and add your dom0 to your cluster. Define a VM and start it up.
7.  To actually have something running inside the VM, I've copied a Fedora image onto the VM's disk volume. I suppose that importing a VM would work, too.

## What's not Done

The whole thing is a fragile hack, with plenty of stuff yet to be solved. The TO-DO list is split to Vdsm-side fixes, and libvirt-side fixes.

### ovirt-host-deploy

1.  Identify that the added host is a Xen dom0, and check Virt Hardware appropriately.

### Vdsm

1.  virt/vm.py has strict assumptions on how each device is reported in libvirt's domain xml. However, Xen's devices do not have a bus address, or a driver, or even an alias. Vdsm should learn to identify devices without this information, or get libvirt-xl expose it.
2.  Xen does not support virtio-serial. Guests agents could be tweaked to use Xen paravirt consoles instead. Until then - virtio-serial devices should not be passed to libvirt
3.  Xen's balloon is not implemented as a virtio-device. Vdsm should user the proper means to specify balloon existence and its size changes.
4.  virtio-net and virtio-block are not supported. The hook converts them to Xen paravirt devices.
5.  I did not try spice, as I was told that it's broken on lower levels, but that's supposedly not exact.

### libvirt xl driver

1.  I found no way to specify "qcow2" in libxl images. Only raw images can be used.
2.  Implement virConnectCompareCPU. At the moment, Vdsm connects to `qemu:///system` to use this API call.
3.  Expose an alias per virtual device. Aliases are assigned by libvirt and are used to uniquely identify a device.
4.  When a cdrom is specified with

```xml
    <tt><disk device="cdrom" snapshot="no" type="file">

    <target bus="ide" dev="hdc"/>

    <readonly/>

    <serial/>

    </disk></tt>
```

    the VM does not attempt to boot from its hard disk. Only complete removal of cdrom worked for me.

5.  When the above cdrom spec has file="", libvirt does a frightening null-pointer dereferencing, instead of interpreting this as an empty cdrom
6.  On an occasion which I did not reproduce, `virsh dumpxml dom` reported a wrong vnc port. This made `virt-viewer` fail, while `xl vncviewer` worked fine.
7.  Some consider this a Xen feature, but for me it is a bug: if for some reason qemu dies, the Xen domain may still live on, and libvirt does not report of any issue. That's usually bad of HVM guests - qemu was started for a reason (to emulate devices) and without it, the guest is not going to get very far along. I'd rather have a means to specify that I'd like such a VM to be shut down in this condition, or at least be told that it has lost its device emulation.
8.  When VM fails to boot, `<on_crash>destroy</on_crash>` takes into actions and stops the VM. My attempts to change this to `preserve` proved futile.
9.  No support for floppy, which is still (seldom) used by oVirt
10. `<interface><filterref>` is silently ignored
11. There is no `<link state="down">`.
12. VNC password cannot be set `libvirtError: unsupported configuration: device type 'graphics' cannot be updated`
13. I failed to connect to the VNC port from outside dom0; I have no idea why I get `unable connect to socket: Connection refused (111)` with iptables set to ACCEPT all.
14. Live migration is in the works
15. Migration cancellation is missing
16. VIR_DOMAIN_DESTROY_GRACEFUL is unsupported: Unknown libvirterror: ecode: 8 edom: 41 level: 2 message: unsupported flags (0x1) in function libxlDomainDestroyFlags

### Xen

1.  When asked to start a domain with only 64MiB RAM, things break in an odd way. qemu dies, but libvirt reports the domain as running.
2.  No CPU hot-plugging, and certainly not something compatible with oVirt's implementation (of starting a VM with 160 considerable CPUs, and setting the current number to 1).

### Nested KVM

If I could run HVM Xen guests within KVM L1 guests, development would have been easier. Unfortunately, with kernel-3.14.5-200.fc20.x86_64 and qemu-kvm-2.0.0-5.fc20.x86_64 on the host, the L1 dom0 \`xl dmesg\` complains about

      (XEN) VMX: CPU0 has insufficient VMExit Control (000f6fff; requires 00008200)
      (XEN) VMX: failed to initialise.

