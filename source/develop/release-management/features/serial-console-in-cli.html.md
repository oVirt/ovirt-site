---
title: Serial Console in CLI
category: cli
authors: dyasny, oernii, rmiddle
---

<!-- TODO: Content review -->

# Serial Console access within oVirt-CLI

## Summary

**This feature is obsoleted by the [serial console] (/develop/release-management/features/engine/serial-console/) feature**

This document describes the VM Serial Console feature, it's use cases and specifications.

## Background

oVirt currently can only provide graphical VM consoles, that may not be usable in environments that have limited or no GUI or no option to install a SPICE/VNC client.

## Owner

*   Name: Dan Yasny (Dyasny)

<!-- -->

*   Email: <dyasny _AT_ redhat _DOT_ com>

## Current status

*   Target Release: N/A
*   Status: A workaround set of scripts is available
*   Last updated date: N/A

## Detailed Description

A user in the CLI, with no GUI (X server or otherwise) is able to administer every aspect of oVirt, but is unable to open VMs' consoles, because that would require a graphical VNC or Spice window. the logical way to provide VM console access in GUI mode is to provide access to VMs' serial console.

## Benefit to oVirt

Having a minimal CLI console available can make the product more attractive to users who use the command line and prefer to avoid using the GUI. It can also provide a simple and fast shell that requires no special client besides an ssh client, without having to connect to the actual VM. Serial console access can also be used for VM troubleshooting at the lower level.

## Dependencies / Related Features

ovirt-shell: [CLI](/develop/release-management/features/infra/cli/) ovirt Guest Agent: [Guest Agent](/develop/developer-guide/vdsm/guest-agent/)

## User Experience

The user should be able to run a command, specifying a VM to connect to, and will have the VM's serial console opened in the shell he is working in.

## Use Cases

### Highly Secure Environment

A Data Centre with no direct access to hosts or VMs, where the administrator has to ssh into a stripped and locked down bastion host, from which all he has is the shell to the rest of the DC. Such a user can manage all aspects of oVirt using the API and ovirt-shell, but will not be able to access the VMs, unless the VMs are on the same network and have ssh/telnet/etc enabled, which might not always be the case. With this feature, such administrators will also have the option to get into the VM's console for management and troubleshooting

### CLI-Only VM rich(er) experience

Accessing a VM with no X server installed and setting it up can be frustrating, as the VNC/Spice shells are very limited, and are lacking copy/paste, scrolling and scaling features. With a serial console all the standard shell features will be available in the console with no additional feature development.

### Unsupported Client Workstations

A user accessing oVirt's management from an unsupported client OS (MAC/BSD/Solaris/etc) will probably be able to work with the webadmin, but will not be able to start Spice sessions if there is no Spice client available for the client OS. Serial console access will provide the minimal means of still being able to access VMs, without having to switch the admin's desktop to a different OS.

## What it will look like

      [oVirt shell (connected)]# action vm $VMNAME serial-console 
      Connected to domain $VMNAME
      Escape character is ^]
      Login: root
      Password: 
      [root@$VMNAME ~]# 
      ...

## What needs to be done

### VDSM Integration

Integrate the console hook into vdsm, OR automatically start all VMs (that have the relevant Guest OS running) with the console enabled (see further in "VM configuration (Engine Backend)")

### Guest Agent

oVirt Guest Agent should integrate a script that would edit grub to enable console access, when the option is selected and the guest OS supports serial consoles.

### RHEL/Fedora installation to automatically have the console enabled

This is already possible with RHEL/Fedora, for both the guest OS installation process and for it's consequent operation, and can be resolved at the documentation level:

*   A kickstart option to add "console=ttyS0" to grub after the guest is done installing (a line in the kickstart %post section)
*   A kickstart option to boot the VM with the console enabled during the actual setup - appending "console=ttyS0" to the boot line:

      linux ks=$pathToKS console=ttyS0

### oVirt Shell

oVirt shell should add the new command that would start up the console

### VM configuration (Engine Backend)

Whether the VM will be accessible via the serial console should be a configurable option, with default set to "Enabled". When disabled, we can simply not start the VM with serial console support at the libvirt level.

## Guest support

The workaround has been successfully tested with RHEL and Fedora guests. In theory, any Linux and BSD guest should support this feature. BSD setup example: <http://www.cyberciti.biz/faq/linux-kvm-redirecting-freebsd-virtual-machines-console-to-aserialport/>

## Documentation / External references

<http://libvirt.org/formatdomain.html#elementsConsole>

## Currently operational workaround

Setting up serial console access for Linux VMs in a oVirt environment

1. The VM's grub.conf kernel options line should contain "console=ttyS0" Example:

      # cat /boot/grub/grub.conf
      default=0
      timeout=5
      splashimage=(hd0,0)/grub/splash.xpm.gz
      hiddenmenu
      title Red Hat Enterprise Linux (2.6.32-220.el6.x86_64)
        root (hd0,0)
`  kernel /vmlinuz-2.6.32-220.el6.x86_64 ro root=/dev/mapper/vg0-lv_root rd_NO_LUKS rd_LVM_LV=vg0/lv_root LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=vg0/lv_swap SYSFONT=latarcyrheb-sun16 rhgb crashkernel=auto quiet  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet `**`console=ttyS0`**
        initrd /initramfs-2.6.32-220.el6.x86_64.img

2. Setting up a User-Defined VM property, to be used by the Hooking mechanism:

      [root@rhevm-dot4 ~]# rhevm-config -s UserDefinedVMProperties='SerialConsole=^([a-z]|[0-9])+$' --cver=3.0
      [root@rhevm-dot4 ~]# service jbossas restart

For ovirt 3.1

      [root@rhevm-dot4 ~]# engine-config -s UserDefinedVMProperties='SerialConsole=^([a-z]|[0-9])+$' --cver=3.1
      [root@rhevm-dot4 ~]# service ovirt-engine restart

For ovirt 3.2

      [root@rhevm-dot4 ~]# engine-config -s UserDefinedVMProperties='SerialConsole=^([a-z]|[0-9])+$' --cver=3.2
      [root@rhevm-dot4 ~]# service ovirt-engine restart

3. Edit the VM's custom properties. Enter "SerialConsole=0"[\*]

*   any string will work instead of 0

4. Add the hook script "50_console" to the Hypervisor:

      #pwd
      /usr/libexec/vdsm/hooks/before_vm_start
      [root@dot14 before_vm_start]# cat 50_console
      #!/usr/bin/python
      import os
      import sys
      import hooking
      import traceback
      '''
      # add serial console support for domain xml:
`# `<serial type='pty'>
`# `<target port='0'/>
`# `</serial>
`#  `<console type='pty'>
`#  `<target type='serial' port='0'/>
`# `</console>
      '''
      if os.environ.has_key('SerialConsole'):
          try:
          #Read VM XML definition
              domxml = hooking.read_domxml()
              devices = domxml.getElementsByTagName('devices')[0]
              serial = domxml.createElement('serial')
              serial.setAttribute('type','pty')
              devices.appendChild(serial)
              target = domxml.createElement('target')
              target.setAttribute('port','0')
              serial.appendChild(target)
              console = domxml.createElement('console')
              console.setAttribute('type','pty')
              devices.appendChild(console)
              target1 = domxml.createElement('target')
              target1.setAttribute('type','serial')
              target1.setAttribute('port','0')
              console.appendChild(target1)
              hooking.write_domxml(domxml)
          except:
          #log to vdsm.log
              sys.stderr.write('SerialConsole: [Unexpected Error]: %s\n' % traceback.format_exc())
              sys.exit(2)
          else:
              sys.stderr.write('SerialConsole: This VM is not using me')
              sys.exit(0)

5. Use the attached script in the oVirt engine machine's root shell to access a VM's serial console:

locateVm.py should run on the Engine host. It will ask for VM name and API password, determine on which $HOST the VM is running, and execute the following to access the console:

      ssh -t -i /etc/pki/rhevm/keys/rhevm_id_rsa root@$HOST 'virsh -c qemu+tls://$(grep "Subject:" /etc/pki/vdsm/certs/vdsmcert.pem | cut -d= -f3)/system console $VM' 

Sample output:

      # ./locateVm.py --help
      locateVm.py - Locate a VM by name and return the IP of the host it is running on
      Usage:  locateVm.py | [arg].internal..[argN]
      Options:
      --help:                Print this help screen.
`--address=`<FQDN or IP: Use non-default (127.0.0.1) IP to access the RHEV-M API.
 --port=<PORT>`:         Use non-default (8443) port to access the RHEV-M API.`
      --user=`<Username>`:     Use non-default (admin@internal) username to access RHEV-M API. Must use USER@DOMAIN 
      --password=`<PASSWORD>`: Enter the API user password
      --vm=`<VM NAME>`:        Enter name of the requested VM
      If no options are entered, or --password and/or --vm options are missing, will enter interactive mode.

Sample output:

      # ./locateVm.py 
      Missing some options. Entering interactive mode...
      Enter the RHEV-Manager address [127.0.0.1]: 
      Enter the RHEV-Manager API port [8443]: 
      Enter the RHEV-Manager API user name [admin@internal]: 
      Enter the RHEV-Manager API password []: P@ssw0rd
      Enter the Virtual Machine name []: RHEL6x64
      Connected to domain RHEL6x64
      Escape character is ^]
       
      Red Hat Enterprise Linux Server release 6.2 (Santiago)
      Kernel 2.6.32-220.el6.x86_64 on an x86_64
      localhost.localdomain login: root
      Password: 
      Last login: Wed Feb 22 19:22:11 on ttyS0
      [root@localhost ~]# exit
      logout
      Red Hat Enterprise Linux Server release 6.2 (Santiago)
      Kernel 2.6.32-220.el6.x86_64 on an x86_64
      localhost.localdomain login: 
      Connection to $HOST closed.

