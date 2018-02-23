---
title: Troubleshooting NFS Storage Issues
authors: adahms, didi, dougsland, dpkshetty, jbrooks, nkesick, rharper, sgordon, suppentopf,
  wdennis
---

# Troubleshooting NFS Storage Issues

### Introduction

To attach NFS storage domains to an oVirt environment, the NFS exports must be configured in a specific way. This page is designed to outline the core requirements for configuring NFS exports, and assist in troubleshooting issues encountered when attempting to attach NFS storage domains to an oVirt environment for the first time.

### Permissions

In principle, the user **vdsm**, with uid **36** and gid **36**, must have read and write permissions on all NFS exports. However, some daemons on the hypervisor hosts (for example, sanlock) use a different uid but need access to the directory too. Therefore, all incoming NFS requests must be mapped to the aforementioned uid and gid. Two steps are required to ensure this mapping:

1. Change the ownership of the export directory, replacing *directory_name* with the name of the directory:

        # chown 36:36 directory_name

2. Add the **anonuid=36**, **anongid=36** and **all_squash** options on the export in **/etc/exports**.

        # /exports/directory_name       *(rw,anonuid=36,anongid=36,all_squash)

3. Set the permissions of the export directory, replacing *directory_name* with the name of the directory:

        # chmod 0755 directory_name

4. The NFS server must actually be running.

a. Ensure that the **nfs** and **rpcbind** services are running on the NFS server, Fedora 16 users should instead look for the **netfs** service.

b. Ensure that **showmount -e *<nfs_server_ip>*** shows the expected export(s).

#### SELinux

*   Ensure that selinux is not interfering with NFS access.
    -   getsebool -a | grep virt_use_nfs should show virt_use_nfs --> on, if not then do \`setsebool virt_use_nfs 1\` to allow NFS access for VMs
    -   One can also use \`setsebool -P virt_use_nfs 1\` to make this setting persistent across reboots.

The easiest way to definitively test that an NFS export is ready for use by oVirt is to:

*   Create the **vdsm** user with uid **36** on the ovirt-engine host if it does not already exist.
*   Change to the **vdsm** user using **su - vdsm -s /bin/bash**
*   Attempt to mount the export on a temporary directory (for example, /tmpmnt) using the following command form: **/usr/bin/sudo -n /bin/mount -t nfs -o soft,nosharecache,timeo=600,retrans=6,nfsvers=3 *servername:/path/of/export* /tmpmnt**
*   If the mount succeeds, then try to create a file in it via the **touch** command, i.e. **touch /tmpmnt/tempfile**

#### ISO Domain

The **engine-setup** command can optionally create an ISO domain and export it.

*   Until oVirt 3.3, it always exported to the entire network.
*   In 3.4 it prompted the user for an ACL, and the default was still the entire network.
*   In 3.5 it still prompts the user, but the default was changed to allow access for the local machine only.

The format for the ACL is simply that of **/etc/exports** - see the exports(5) manpage for details. Some simple examples:

*   To allow access to 3 hosts host1, host2 and host3, input: *host1(rw) host2(rw) host3(rw)*
*   To allow access to the entire Internet, input: *\*(rw)*

If you use the last example, you must ensure that other means such as a firewall are in place to protect the ISO domain. When configuring this option, also consider protecting the ISO domain from untrusted guests that you might want to run on your hosts.

### nfs-check program

A new **nfs-check** script is now available to test whether an NFS export is ready for use by oVirt :

*   **nfs-check.py** is a python script to validate nfs targets to use with oVirt project. Some operations include: mount the nfs target, create a file as vdsm:kvm and then remove it.
*   **nfs-check.py** is available in the **vdsm/contrib/** directory of the vdsm source
*   Run it on a node via **\1**

       $ git clone http://gerrit.ovirt.org/p/vdsm.git
       $ cd vdsm/contrib
       $ python nfs-check.py myNFSServer:/nfsTarget

### Setting NFS Server

#### Debian Squeeze

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # /etc/init.d/nfs-kernel-server restart 

#### Fedora 16 or higher

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # yum -y install nfs-utils

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # systemctl start rpcbind.service
      # systemctl start nfs-server.service
      # systemctl start nfs-lock.service 

      # systemctl enable rpcbind.service
      # systemctl enable nfs-server.service
      # systemctl enable nfs-lock.service

#### RHEL6 based distro

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw,sync,no_subtree_check,all_squash,anonuid=36,anongid=36)

      # /etc/init.d/nfs restart 

## Workarounds for known issues

### NFS Lockups

Normally the NFS server of any distro should work out of the box. Using older NFS servers or following different tuning advices throughout the internet may lead to a misconfiguration that gives lockups/freezes/stalls. Rule of thumb is to always ensure that the tcp window size parameters of your server are larger than the wsize and rsize mount option of your hypervisor hosts. E.g. using Fedora 19 as a hypervisor node these parameters are set to 1 MB.

       # df
      ...
      10.10.30.253:/var/nas3/ovirt on /rhev/data-center/mnt/10.10.30.253:_var_nas3_ovirt type nfs (...,rsize=1048576,wsize=1048576,...)
      ...
       

In this case it is a good idea to set the tcp window parameters on the NFS server to at least 4 MB in /etc/sysctl.conf.

       # cat /etc/sysctl.conf
      net.ipv4.tcp_mem=4096 65536 4194304
      net.ipv4.tcp_rmem=4096 65536 4194304
      net.ipv4.tcp_wmem=4096 65536 4194304
      net.core.rmem_max=8388608
      net.core.wmem_max=8388608
       

To activate these settings for the running server reload them with

       # sysctl -p 

### NFS Storage Domain Failure on Fedora 17

In the past, nodes running Fedora 17 kernels newer than 3.4 have trouble with NFS storage domains.
This issue has been fixed in: vdsm-4.10.0-10.fc17
Download: <http://koji.fedoraproject.org/koji/buildinfo?buildID=358280>
More info: <https://bugzilla.redhat.com/show_bug.cgi?id=845660#c29>
 In case, you still use vdsm < 4.10.0-10, the workaround is to use the 3.4 kernel in F17.
You can use grub2's SAVEDEFAULT option to keep the endpoint booted on 3.4.

*   Confirm you have a 3.4 kernel

       # rpm -qa | grep kernel-3.4
      kernel-3.4.0-1.fc17.x86_64 

*   Update default grub config to ensure 'saved default' works

      $EDITOR /etc/default/grub
       

*   Ensure you have the following two lines

      GRUB_SAVEDEFAULT=true
      GRUB_DEFAULT=saved
       

*   Generate new grub config

      # grub2-mkconfig -o /boot/grub2/grub.cfg
       

*   Reboot your system

      # reboot
       

*   Interrupt boot sequence and select the 3.4 kernel under the 'Advanced' menu.
*   Login and confirm you're running 3.4

      # uname -a
      Linux ichigo-dom228 3.4.0-1.fc17.x86_64 #1 SMP Sun Jun 3 06:35:17 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
       

*   Reboot once more and let it boot back up by itself and confirm it selected the 3.4 kernel
