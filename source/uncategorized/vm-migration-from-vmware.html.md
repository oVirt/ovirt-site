---
title: Vm migration from vmware
authors: sven
wiki_title: Vm migration from vmware
wiki_revision_count: 1
wiki_last_updated: 2014-06-27
---

# Vm migration from vmware

Migrate from VMWare to oVirt

1. On VmWare:

a. Export the VM to ovf format. There is a smb/nfs share on virt-v2v you can use as storage. i. NFS: Virtv2v.:/media/Storage ii. SMB: virtv2v. share: virtv2v

2. with virtv2v

a. Log in on the virt-v2v vm.

b. Locate and Extract the ovf file with tar –xvf

c. Convert the extracted vmdk file to raw disk format with the following command:

vboxmanage clonehd --format RAW <VMNAME>.vmdk <NewVMName>.raw

d. Convert the created RAW file to a qemu2 img:

qemu-img convert -f raw <VM-Name>.raw -O qcow2 <VMName>.qcow2

e. Run the vm in virsh:

virt-install --connect qemu:///system --ram 1024 -n griffu -r 2048 --os-type=linux --os-variant=rhel6 --diskpath=/media/Storage/<VMName>.qcow2,device=disk,format=qcow2 --vcpus=2 --vnc --noautoconsole –import

f. Take a xml dump of the VM and copy the result in a new file

<VMName>.xml virsh dumpxml <VMName>

g. Now let’s move the vm to ovirt. Make sure the nfs is attached to the TestDev Datacenter.

virt-v2v -i libvirtxml -ic qemu+ssh://<FQDN-Hypervisor> /system -o rhev -os

<FQDN-NFS-exportdomainserver>:/media/NfsProgress -n ovirtmgmt <VMName>.xml
