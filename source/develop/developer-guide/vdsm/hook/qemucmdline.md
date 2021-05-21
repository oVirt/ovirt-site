---
title: qemucmdline
authors:
  - dougsland
  - dyasny
---

# qemucmdline

qemu_cmdline hook:

libvirt provides support for passing QEMU cmdline options. With the help of this, one can inject QEMU options bypassing the libvirt's domain XML code. This can help immensely in testing and developing new qemu features, which are not yet in libvirt and/or injecting experimental options.

The os environ 'qemu_cmdline' points to a json list, containing the qemu option followed by value as individual list entries. For qemu option that does not take any value, skip the value entry.

Note that validation of the option and value list entries is NOT done, its passed as-is to qemu and in the same order as present in the list.

Example:

      qemu_cmdline='["-cdrom","`<path/to/iso>`", ...]'

## Installing the package in the Hypervisor

Download vdsm-hook-qemucmdline from:

[`https://apps.fedoraproject.org/packages/vdsm-hook-qemucmdline`](https://apps.fedoraproject.org/packages/vdsm-hook-qemucmdline)` or `[`http://resources.ovirt.org/pub/`](http://resources.ovirt.org/pub/)

1.  yum/dnf install vdsm-hook-qemucmdline-N-V-R.rpm

If you are using oVirt Node:

       1- Enable SSH via TUI or via Console (Press F2 and execute: /usr/libexec/ovirt-config-password)
       2- Remount FileSystem as read and write
       # mount -o remount,rw /  (Remount the FS as rw)
       3- Install the package and persist the hook
       # rpm -ivh vdsm-hook-qemucmdline-N.V.R.rpm 
       # persist /usr/libexec/vdsm/hooks/before_vm_start/50_qemucmdline

## In the oVirt Engine side

       # engine-config -s "UserDefinedVMProperties=qemu_cmdline=^.*$"
       # service ovirt-engine restart

       Now go to oVirt Engine Admin Portal
         -> Virtual Machines
         -> Stop the virtual machine
         -> Click in the VM and Edit
            -> Custom Properties
               Add the key qemu_cmdline and type in the box your additional param to qemu:
        Example:
                 ["-spice", "tls-ciphers=DES-CBC3-SHA"]
         -> Start the virtual machine

## Testing

       After the virtual machine start, execute ps auxww | grep qemu-kvm in hypervisor. 
       You will see the  flags added into the qemu-kvm process.
