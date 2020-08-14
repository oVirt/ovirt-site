---
title: VDSM-Hooks
category: vdsm
authors: dyasny, ovedo, sandrobonazzola
---

# VDSM-Hooks

VDSM Hooks are a means to insert arbitrary commands and scripts at certain point in a VM's lifecycle as well as in VDSM daemon's lifecycle. VDSM, when entering a certain checkpoint in a VM's execution cycle, will check whether there is a hook present for that point, and if a hook is found, it will be executed.

[VDSM-Hooks Catalogue](/develop/developer-guide/vdsm/hooks-catalogue.html)

The current repository of built hooks can be found at:

Fedora 19: <http://resources.ovirt.org/pub/ovirt-3.4/rpm/fc19/noarch/>

Fedora 20: <http://resources.ovirt.org/pub/ovirt-3.4/rpm/fc20/noarch/>

EL6: <http://resources.ovirt.org/pub/ovirt-3.4/rpm/el6/noarch/>

The hooks reside on every host in /usr/libexec/vdsm/hooks/ A hook can be any executable (bash/python/perl/binary/etc).

Here is the complete list:

*before_vdsm_start* *after_vdsm_stop* These can be used to insert additional command sets before the vdsmd daemon starts and after it stops, this hook is not related specifically to VMs.

*before_vm_start* *after_vm_start* These are executed before vdsmd passes a VM start command to libvirt, and afterwards. The flow is as follows: Engine is ordered to start a VM, it gathers the required parameters, and passed a createVM command to vdsmd on a host vdsmd gathers the parameters provided by Engine, and then executes the before_vm_start hook. At this point it is possible to alter the VM configuration on the fly, that will be discussed later on. After the hook is done running, vdsmd will start the VM by passing the parameters down to libvirt. Once the VM is started, vdsmd can execute an after_vm_start hook, usually a good place to finalize VM startup flows

*before_vm_destroy* *after_vm_destroy* When Engine stops a VM, it passes a vmStop command to vdsmd, which receives the command, executes the before_vm_stop hooks, and then sends the VM a stop command. After the VM is down, after_vm_destroy hooks are called.

*before_vm_pause* *after_vm_pause* When Engine pauses a VM, vdsmd will receive the pause command, execute the before_vm_pause hooks, and pause the VM. After the VM is paused, the after_vm_pause hooks will be called.

*before_vm_cont* *after_vm_cont* When Engine unpauses (continues) a VM, vdsmd will receive the continue command, execute the before_vm_cont hooks, and un-pause the VM. After the VM is up and running, the after_vm_cont hooks will be called.

*before_vm_hibernate* *after_vm_hibernate* When Engine sends a command to hibernate a VM, vdsmd will receive the hibernate command, execute the before_vm_hibernate hooks, and place the VM in hibernation mode. After the VM is hibernating, the after_vm_hibernate hooks will be called.

''before_vm_dehibernate '' *after_vm_dehibernate* When Engine sends a command to dehibernate a VM, vdsmd will receive the dehibernate command, execute the before_vm_dehibernate hooks, and then take the VM out of hibernation. After the VM is up and running, the after_vm_hibernate hooks will be called.

*before_vm_migrate_source* *after_vm_migrate_source* These are called on the source migration host. Before the VM is live-migrated, before_vm_migrate_source hooks are called, and only then will vdsmd start the VM migration process. After the process is complete, after_vm_migrate_source hooks are executed

*before_vm_migrate_destination* *after_vm_migrate_destination* These are called on the destination migration host. Before the VM is live-migrated, before_vm_migrate_destination hooks are called, and only then will vdsmd start receiving the migrating VM from the migration source host. After the process is complete, after_vm_migrate_destination hooks are executed

------------------------------------------------------------------------

Besides a simple script execution, there is a mechanism that allows us to connect specific VMs to hooks. This is done by using the vdsm hooking module, through which the VM runtime parameters can be obtained, parsed and acted upon. It is possible to either execute specific scripts if specific standard VM parameters (like VM name or VM UUID) are detected, or by looking for VM's custom properties, and acting upon those. A custom property can be defined in RHEV-M and attached to a VM. It can be just a property as such (and a hook will simply check for it's existence) or it can contain it's own parameters (and the hook can take the property and it's paramaters, parse them and perform actions specific to these custom parameters).

VMs are defined by an XML-formatted property list Example:

```xml
<domain type='kvm' id='1'>
 <name>myvm</name>
 <uuid>3573e29e-5de9-468a-9fae-16050c6b3dcc</uuid>
 <memory unit='KiB'>524288</memory>
 <currentMemory unit='KiB'>524288</currentMemory>
 <vcpu placement='static'>1</vcpu>
 <cputune>
   <shares>1020</shares>
 </cputune>
 <sysinfo type='smbios'>
   <system>
     <entry name='manufacturer'>Red Hat</entry>
     <entry name='product'>RHEV Hypervisor</entry>
     <entry name='version'>6Server-6.3.0.3.el6</entry>
     <entry name='serial'>C0F9945F-3F73-B601-CE49-001A647A9462_00:1A:64:7A:94:62</entry>
     <entry name='uuid'>3573e29e-5de9-468a-9fae-16050c6b3dcc</entry>
   </system>
 </sysinfo>
 <os>
   <type arch='x86_64' machine='rhel6.2.0'>hvm</type>
   <boot dev='hd'/>
   <smbios mode='sysinfo'/>
 </os>
 <features>
   <acpi/>
 </features>
 <cpu mode='custom' match='exact'>
   <model fallback='allow'>Conroe</model>
   <topology sockets='1' cores='1' threads='1'/>
 </cpu>
 <clock offset='variable' adjustment='0'>
   <timer name='rtc' tickpolicy='catchup'/>
 </clock>
 <on_poweroff>destroy</on_poweroff>
 <on_reboot>restart</on_reboot>
 <on_crash>destroy</on_crash>
 <devices>
   <emulator>/usr/libexec/qemu-kvm</emulator>
   <disk type='block' device='disk'>
     <driver name='qemu' type='raw' cache='none' error_policy='stop' io='native'/>
     <source dev='/rhev/data-center/9fd8d38c-218e-4e8c-a78f-2895b447de0d/b3ecfe84-9f03-4245-b34a-131174cfdfc3/images/2b6843e5-b2fd-4007-b0fa-4aaa66515a31/73da4394-e024-4bc5-a440-e4672bfcfd85'/>
     <target dev='vda' bus='virtio'/>
     <serial>07-b0fa-4aaa66515a31</serial>
     <alias name='virtio-disk0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
   </disk>
   <disk type='file' device='cdrom'>
     <driver name='qemu' type='raw'/>
     <target dev='hdc' bus='ide'/>
     <readonly/>
     <alias name='ide0-1-0'/>
     <address type='drive' controller='0' bus='1' target='0' unit='0'/>
   </disk>
   <controller type='virtio-serial' index='0' ports='16'>
     <alias name='virtio-serial0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
   </controller>
   <controller type='ide' index='0'>
     <alias name='ide0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
   </controller>
   <controller type='usb' index='0'>
     <alias name='usb0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
   </controller>
   <interface type='bridge'>
     <mac address='00:1a:4a:23:18:01'/>
     <source bridge='rhevm'/>
     <target dev='vnet0'/>
     <model type='virtio'/>
     <alias name='net0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
   </interface>
   <interface type='bridge'>
     <mac address='00:1a:4a:23:18:02'/>
     <source bridge='rhevm'/>
     <target dev='vnet1'/>
     <model type='virtio'/>
     <alias name='net1'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
   </interface>
   <interface type='bridge'>
     <mac address='00:1a:4a:23:18:03'/>
     <source bridge='rhevm'/>
     <target dev='vnet2'/>
     <model type='virtio'/>
     <alias name='net2'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
   </interface>
   <channel type='unix'>
     <source mode='bind' path='/var/lib/libvirt/qemu/channels/myvm.com.redhat.rhevm.vdsm'/>
     <target type='virtio' name='com.redhat.rhevm.vdsm'/>
     <alias name='channel0'/>
     <address type='virtio-serial' controller='0' bus='0' port='1'/>
   </channel>
   <channel type='spicevmc'>
     <target type='virtio' name='com.redhat.spice.0'/>
     <alias name='channel1'/>
     <address type='virtio-serial' controller='0' bus='0' port='2'/>
   </channel>
   <input type='mouse' bus='ps2'/>
   <graphics type='spice' port='5900' tlsPort='5901' autoport='yes' listen='0' keymap='en-us' passwdValidTo='1970-01-01T00:00:01'>
     <listen type='address' address='0'/>
     <channel name='main' mode='secure'/>
     <channel name='inputs' mode='secure'/>
   </graphics>
   <video>
     <model type='qxl' vram='65536' heads='1'/>
     <alias name='video0'/>
     <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
   </video>
   <memballoon model='none'>
     <alias name='balloon0'/>
   </memballoon>
 </devices>
 <seclabel type='dynamic' model='selinux' relabel='yes'>
   <label>system_u:system_r:svirt_t:s0:c183,c514</label>
   <imagelabel>system_u:object_r:svirt_image_t:s0:c183,c514</imagelabel>
 </seclabel>
</domain>
```

This xml can be changed in order to alter the VM settings in ways ovirt-engine doesn't support directly.

**NOTE**: Only the before_vm_start hooks are actually able to alter the VM's xml definitions, this is due to the fact that once the xml definitions are passed to libvirt, they cannot be changed as long as the VM is running. All other VM related hooks can access the VM's xml definitions, but in read-only mode.

**Writing VDSM hooks:**

Currently, the hooking module only exists in python. Here is an example of a simple vdsm hook that blocks a VM's live migration: 50_cant_migrate.py placed in before_VM_migrate_source. This hook looks for a custom property calles "cantmigrate" and if it is found, will block the VM from migrating. This can be useful for VMs that rely on a specific resource found only locally on a specific host (like a passed through USB license dongle or a TBU)

```python
#!/usr/bin/python
import os
import sys 
if os.environ.has_key('cantmigrate'):
   sys.stderr.write('cantmigrate: before_vm_migrate_source: cannot migrate this VM\n')
   sys.exit(2)
```

This script does not use the hooking module, because it does not need to actually act upon the VM's specific XML.

And this is an example that uses the Hooking module to read a custom property that defines CPU pinning for a VM, and alters the VM's XML accordingly:

```python
#!/usr/bin/python 
import os
import sys
import hooking
import traceback
    
#pincpu usages
#=============
#pincpu="0" (use the first cpu)
#pincpu="1-4" (use cpus 1-4)
#pincpu="^3" (don't use cpu 3)
#pincpu="1-4,^3,6" (or all together)
  
if os.environ.has_key('pincpu'):
    try:
       domxml = hooking.read_domxml()   #here we read the VM XML into the domxml variable
       vcpu = domxml.getElementsByTagName('vcpu')[0] #find and read the CPU definition in the VM XML

       if not vcpu.hasAttribute('cpuset'):
          sys.stderr.write('pincpu: pinning cpu to: %s\n' % os.environ['pincpu'])  #sys.stderr.write is caught by vdsm and logged into vdsm.log for debugging
          vcpu.setAttribute('cpuset', os.environ['pincpu'])  #change an attribute here
          hooking.write_domxml(domxml)                       #and write to the altered domxml
       else:
          sys.stderr.write('pincpu: cpuset attribute is present in vcpu, doing nothing\n')
    except:
       sys.stderr.write('pincpu: [unexpected error]: %s\n' % traceback.format_exc())
       sys.exit(2)
```
