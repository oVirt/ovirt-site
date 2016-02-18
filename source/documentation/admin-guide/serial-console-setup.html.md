---
title: Serial Console Setup
authors: fromani
wiki_title: Serial Console Setup
wiki_revision_count: 22
wiki_last_updated: 2015-10-12
---

# Serial Console Setup

## General

The purpose of this page is to document how to properly setup and troubleshoot the [Serial_Console](Serial_Console) feature, available in oVirt 3.6.0.

## Setup

The Serial Console can be setup either automatically, using engine-setup, or manually (not recommended). In both cases, the ovirt-vmconsole-proxy services must run on the same host on which Engine runs. This requirement will be lifted in a future release. The following sections documents fresh install of oVirt 3.6.x. For upgrading from 3.5.x, please see **upgrade notes** and **troubleshooting** below.

### Automatic Setup

1.  make sure you have all the required package installed. Alongside ovirt-engine and ovirt-engine setup, you must make sure you have the *ovirt-vmconsole-proxy* package installed in the same host on which ovirt-engine runs.
2.  to make ovirt-vmconsole-proxy host accessible, make sure the port "2222" is open. The setup procedure will setup "firewalld" accordingly.
3.  run engine-setup and follow instructions provided interactively. Please note that the vmconsole proxy setup is disabled if the *ovirt-vmconsole-proxy* package is NOT detected when the setup runs.
4.  once the setup succesfully run, and once ovirt-engine is running, you can log in and register a SSH key. (TODO: add picture)
5.  when you install an hypervisor host, the deploy procedure will automatically install and setup the "ovirt-vmconsole-host" package.
6.  make sure the user which want to use the serial console feature has permissions on the VM on which he wants to connect.
7.  make sure the relevant VM have the "Virtio Console Device" enabled
8.  congratulations! setup is now done. Please check **Connecting to consoles** below.

### Manual Setup

**This is NOT the recommended way**. The setup is a complex procedure. Use automatic setup whenever possible, and report bugs! Consider the following more like a checklist for troubleshooting rather than an HOWTO!

#### step 1: proxy and Engine setup

**TODO: verify the steps**

You need to have ovirt-engine installed. "password", below, is the ovirt-engine PKI password. As usual, "#" represents the root prompt. Since you need to leverage Engine's PKI, execute the following on the host on which Engine runs:

First, create certificates and keys for the vmconsole proxy helper:

       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=vmconsole-proxy-helper --password=password --subject="/C=COUNTRY/O=ORG/CN=FQDN" --ku=digitalSignature --eku=1.3.6.1.4.1.2312.13.1.2.1.1
       # /usr/share/ovirt-engine/bin/pki-pkcs12-extract.sh --name=vmconsole-proxy-helper --password=password
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cert
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass
       # chmod 0600 /etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass

Now configure the helper:

*   edit the helper configuration file $PREFIX/etc/ovirt-engine/ovirt-vmconsole-proxy-helper.conf.d/10-setup.conf
*   add content:

       ENGINE_BASE_URL=`[`https://$ENGINE_IP`](https://$ENGINE_IP)`:$ENGINE_PORT/ovirt-engine
       TOKEN_CERTIFICATE=$PREFIX/etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cer
       TOKEN_KEY=$PREFIX/etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass

**please note:** there is no shell variable expansion support. Here $PREFIX and $ENGINE_ADDRESS and $ENGINE_PORT are just a placeholders for the actual values you should use. The reminder are the default paths assumed.

Full example:

` ENGINE_BASE_URL=`[`https://sercon.test.lan:8443/ovirt-engine/`](https://sercon.test.lan:8443/ovirt-engine/)
       TOKEN_CERTIFICATE=/usr/local/etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cer
       TOKEN_KEY=/usr/local/etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass

Now, configure the ovirt-vmconsole-proxy package to use the helper.

*   edit the proxy configuration file /etc/ovirt-vmconsole/ovirt-vmconsole-proxy/conf.d/10-engine-setup.conf
*   add content:

       [proxy]
       key_list = exec $PREFIX/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py --version {version} keys
       console_list = exec $PREFIX/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py --version {version} consoles --entityid {entityid}"

**please note:** ovirt-vmconsole package expands {version} and {entityid}, not $PREFIX. Here $PREFIX is just a placeholder for the actual prefix on which you installed ovirt-engine. For example if you installed ovirt-engine with PREFIX=/usr/local, the above should read

       [proxy]
       key_list = exec /usr/local/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py --version {version} keys
       console_list = exec /usr/local/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py --version {version} consoles --entityid {entityid}"

That should be it! Now you can verify the helper is running OK

       # developer installation
       [root@sercon ~]# /usr/local/ovirt/sercon/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py --version 1 keys
        {"content": "key_list", "keys": [{"username": "admin", "entityid": "fdfc627c-d875-11e0-90f0-83df133b58cc", "key": "ssh-rsa AAAB3NzaC1yc2EAAAADAQABAAABAQDSosmEQPVsPPysLmAJQy5vfbb8qf2x8+3jLQAqYc7Zhp4kIasHZ2lLOxFJ5hZR3ajaB/JsdMmblMMMkxZlv9YPZhd+1rHsjt85AS+Yt1AGRFK5KK9f3MIyj8nlOERr+N96L7nCRJ4y0r+Wtnrs5b6iYhciohpexVUBXAcu4LTrqw4kvm67lvTv0CgTxTQAMcrIgAhvdqNy4VfWmprKj0zTIWC5A4Hw4WFRftri3cJZL/onl/z+3WZjMcbApKXw6Ir7aFwFOgwDK8eqLQLt8ZGcevchYnS6XUyYbWyFQxxwCxpRea3M+/s2LCAyKQsCID+HRvT+1CWHW7nJnw3eMs59 fromani@musashi.rokugan.lan", "entity": "user-id"}], "version": 1}

And that the proxy package is working OK as well:

       [root@sercon ~]# su - ovirt-vmconsole -c 'ovirt-vmconsole-proxy-keys list'
       command="exec "/usr/sbin/ovirt-vmconsole-proxy-shell"  accept --entityid="fdfc627c-d875-11e0-90f0-83df133b58cc" --entity="user-id"",no-agent-forwarding,no-port-forwarding,no-user-rc,no-X11-forwarding ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSosmEQPVsPPysLmAJQy5vfbb8qf2x8+3jLQAqYc7Zhp4kIasHZ2lLOxFJ5hZR3ajaB/JsdMmblMMMkxZlv9YPZhd+1rHsjt85AS+Yt1AGRFK5KK9f3MIyj8nlOERr+N96L7nCRJ4y0r+Wtnrs5b6iYhciohpexVUBXAcu4LTrqw4kvm67lvTv0CgTxTQAMcrIgAhvdqNy4VfWmprKj0zTIWC5A4Hw4WFRftri3cJZL/onl/z+3WZjMcbApKXw6Ir7aFwFOgwDK8eqLQLt8ZGcevchYnS6XUyYbWyFQxxwCxpRea3M+/s2LCAyKQsCID+HRvT+1CWHW7nJnw3eMs59 fromani@musashi.rokugan.lan[root@sercon ~]#

#### step 2: host connection setup

Install the needed packages on the hypervisor hosts:

       ovirt-vmconsole
       ovirt-vmconsole-host

Make sure the port 2223 is open on the hypervisor hosts

You need to have ovirt-engine installed. "password", below, is the ovirt-engine PKI password. As usual, "#" represents the root prompt. Since you need to leverage Engine's PKI, execute the following on the host on which Engine runs:

       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=proxy1-host --password=password --subject="/CN=proxy1"
       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=proxy1-user --password=password --subject="/CN=proxy1"
       # /usr/share/ovirt-engine/bin/pki-enroll-openssh-cert.sh --name=proxy1-host --id=proxy1 --host --principals=@PROXY_FQDN@
       # /usr/share/ovirt-engine/bin/pki-enroll-openssh-cert.sh --name=proxy1-user --id=proxy1 --principals=ovirt-vmconsole-proxy
       # cp /etc/pki/ovirt-engine/certs/proxy1-host-cert.pub /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa-cert.pub
       # cp /etc/pki/ovirt-engine/certs/proxy1-user-cert.pub /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa-cert.pub
       # openssl pkcs12 -passin password -in /etc/pki/ovirt-engine/keys/proxy1-host.p12 -nodes -nocerts > /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa
       # openssl pkcs12 -passin password -in /etc/pki/ovirt-engine/keys/proxy1-user.p12 -nodes -nocerts > /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa
       # chmod 0600 /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa

## Connecting to consoles

Access to proxy by user is perform using the following command, a menu with the available consoles will be presented:

       $ ssh -t -p 2222 ovirt-vmconsole@proxy-host connect

Access to specify console can be done using the following command:

       $ ssh -t -p 2222 ovirt-vmconsole@proxy-host connect --vm-id=1E12DF323

List available consoles:

       $ ssh -t -p 2222 ovirt-vmconsole@proxy-host list

Usage:

       $ ssh -t  -p 2222 ovirt-vmconsole@proxy-host -- --help

### Serial console on boot

It's possible to use serial console immediately from the virtual machine startup with recent development versions of Engine and VDSM, if the BIOS of the virtual machine supports serial console. Then you can see BIOS bootup messages, select booting method, choose GRUB menu items, etc. on the console.

Just note that serial console is not a very powerful editing tool. For instance, when using arrow keys or Escape you may need to press them multiple times to take effect. Also the screen output may not be pretty and some things may be hard to achieve.

When you want to use serial console on boot, it may be a good idea to start the virtual machine in paused mode. Then you can connect to the console before the machine actually starts.

One of the features the recent Engine versions provide to make serial console available on boot is switching from hv0 to ttyS0 console device. So make sure your getty process runs on ttyS0. This is not important to see the bootup messages but it is important to be able to log into your system using serial console.

## Upgrade Notes

If you are upgrading fro oVirt 3.5.x, to use the serial consone feature you must perform engine-setup and key registration in Engine exactly as per fresh start. Hoever, additional care is needed.

1.  the upgrade procedure **will automatically upgrade the existing VM to use the new Serial Console Device**. Please see "Troubleshooting" below if you still need to manually connect to your consoles. Otherwise, the upgrade
2.  to use the new Serial Console Device, you must redeploy all existing host, to make sure the correct setup is performed.

Please note that installing the needed package on your hypervisor hosts (ovirt-vmconsole, ovirt-vmconsole-host), is necessary, but not sufficient to use the feature. You also must enroll keys and certificates, and this is what reinstall will do.

## Troubleshooting

### Cannot connect to VM/VM not present in the available consoles list

Make sure the user has the permissions on the VM (s)he wants to connect to. In webadmin: VM panel -> permissions subpanel.

### I need to access the console the old way

Starting 3.6.x. the VM console are no longer connected to PTYs, but to unix domain socket. In 3.5.x days, the way to connect to VM consoles was something like

       ssh hypervisor-host
       virsh console $VM_NAME

in 3.6.x, if you need to manually connect to console, you can connect to unix domain socket:

       ssh hypervisor-host
       minicom -D unix#$VM_SOCKET

Please note that the user which runs minicom must be part of the **ovirt-vmconsole** group the socket will have paths like

       /var/run/ovirt-vmconsole-console/$VM_UUID.sock

another option is using socat:

       socat -,raw,echo=0,escape=1 UNIX-LISTEN:/var/run/ovirt-vmconsole-console/$VM_UUID.sock,user=ovirt-vmconsole

### SELinux denials running ovirt-vmconsole-list.py

This should be handled by packaging, so it is highly unlikley you ever encounter this. If it happens, however, please make sure that

*   You have this patch applied:

` `[`https://gerrit.ovirt.org/#/c/43655/`](https://gerrit.ovirt.org/#/c/43655/)

*   the ovirt-vmconsole-list.py helper has the right SELinux label:

       # chcon -t bin_t $PREFIX/libexec/ovirt-vmconsole-proxy-helper/ovirt-vmconsole-list.py

*   As last resort, on Fedora/RHEL/Centos/Scientifix Linux, please make sure this boolean is enabled:

       # setsebool -P nis_enabled 1
       This was reported to help, and it is only slightly better than disabling selinux alltogether.

if you still get SELinux denials after checking the above, please file a bug.

### I succesfully selected a console, but now I get just a blank screen

This most likely means that the system set up the connection properly, but nothing is listening on the guest side of the connection. You need to make sure the a getty is spawned on the guest, so something is actually listening.

For example, in CentOS 7.x, you need to make sure the serial-getty is running

       # systemctl status serial-getty@hvc0.service

and start it if not

       # systemctl start serial-getty@hvc0.service

You may also want to enable the serial console emulation. This boils down to set the console type to "serial" instead of "virtio" (This is going to be fixed in oVirt 3.6.0-final thanks to [this patch](https://gerrit.ovirt.org/#/c/46700/)) for greater compatibility. In modern systems, like CentOS 7, this will likely make the getty listen on the console automatically.
