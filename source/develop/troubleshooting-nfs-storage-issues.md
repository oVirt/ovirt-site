---
title: Troubleshooting NFS Storage Issues
authors:
  - adahms
  - didi
  - dougsland
  - dpkshetty
  - jbrooks
  - nkesick
  - rharper
  - sgordon
  - suppentopf
  - wdennis
---

# Troubleshooting NFS Storage Issues

### Introduction

To attach NFS storage domains to an oVirt environment, the NFS exports must be configured in a specific way. This page is designed to outline the core requirements for configuring NFS exports, and assist in troubleshooting issues encountered when attempting to attach NFS storage domains to an oVirt environment for the first time.

### Permissions

In principle, the user **vdsm**, with uid **36** and gid **36**, must have read and write permissions on all NFS exports. However, some daemons on the hypervisor hosts (for example, sanlock) use a different uid but need access to the directory too. Therefore, all incoming NFS requests must be mapped to the aforementioned uid and gid. Two steps are required to ensure this mapping:

1. Change the ownership of the export directory, replacing *directory_name* with the name of the directory:

        # chown 36:36 directory_name

2. Add the **rw** options on the export in **/etc/exports**.

        # /exports/directory_name       *(rw)

3. Set the permissions of the export directory, replacing *directory_name* with the name of the directory:

        # chmod 0755 directory_name

4. The NFS server must actually be running.

a. Ensure that the **nfs** and **rpcbind** services are running on the NFS server,
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

##### TODO: Update to a current version

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

       $ git clone "https://gerrit.ovirt.org/vdsm"
       $ cd vdsm/contrib
       $ python nfs-check.py myNFSServer:/nfsTarget

### Setting NFS Server

#### Debian Squeeze
##### TODO: Update to current Debian

     #> groupadd kvm -g 36
     #> useradd vdsm -u 36 -g kvm

     # mkdir /storage
 
     #> chmod 0755 /storage
     #> chown 36:36 /storage/
     #> cat /etc/exports
     /storage    *(rw)

     #>/etc/init.d/nfs-kernel-server restart 


#### Fedora 26 or higher

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # yum -y install nfs-utils

      # cat /etc/exports
      /storage    *(rw)

      # systemctl start rpcbind.service
      # systemctl start nfs-server.service
      
      # Relevant only for NFS v3
      # systemctl start nfs-lock.service 
      

      # systemctl enable rpcbind.service
      # systemctl enable nfs-server.service
       

      # Relevant only for NFS v3
      # systemctl enable nfs-lock.service

#### RHEL7 based distro

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw)

      # systemctl enable rpcbind
      # systemctl enable nfs-server
      # systemctl start rpcbind 
      # systemctl start nfs-server


#### Synology DSM 6.2.4-25556 Update 2 and later

Synology DSM 6.2.4-25556 Update 2 / DSM 7 extends Access Control Lists (ACLs) on all shared folders, and removes `groupadd` and `useradd` commands.
To allow ovirt nodes to connect via NFS the ACL permissions and /etc/exports file need to be updated manually (_take backups before editing!_).

1.  Create the shared folder required as usual and allow your oVirt host IP's in the NFS permissions section

2.  Login to your Synology NAS via SSH (search the web for 'synology enable ssh access') as root or sudo to root once logged in

3.  Add a line for the kvm group (id 36) to /etc/group

    `kvm:x:36`

4.  Add a line for the vdsm user (id 36) to /etc/passwd

    `vdsm:x:36:36::/dev/null:/bin/false`

5.  Update the Synology ACLs to allow access to kvm:vdsm

        EXPORT_DIR=/volumeX/...
        ALLOW_USER='user:vdsm:allow:rwxpdDaARWcCo:fd--'
        ALLOW_GROUP='group:kvm:allow:rwxpdDaARWcCo:fd--'

        synoacltool -get "$EXPORT_DIR" | grep -q "$ALLOW_USER" || synoacltool -add "$EXPORT_DIR" $ALLOW_USER > /dev/null
        synoacltool -get "$EXPORT_DIR" | grep -q "$ALLOW_GROUP" || synoacltool -add "$EXPORT_DIR" $ALLOW_GROUP > /dev/null
        synoacltool -get "$EXPORT_DIR"

6.  Edit /etc/exports and replace the `anonuid` and `anongid` values with 36, e.g.

        /volume1/ovirt 1.1.1.1(<Synology defined options>,anonuid=1025,anongid=100) 1.1.1.2(<Synology defined options>anonuid=1025,anongid=100)

Would become

        /volume1/ovirt 1.1.1.1(<Synology defined options>,anonuid=36,anongid=36) 1.1.1.2(<Synology defined options>,anonuid=36,anongid=36)

**Warning** any edits (i.e. adding a new host) to the NFS share in the Synology UI will reset the `anonuid` and `anongid` back to Synology defatuls.

## Workarounds for known issues

#### TODO: update for the newer supported releases

### NFS Lockups

Normally the NFS server of any distro should work out of the box. Using older NFS servers or following different tuning advices throughout the internet may lead to a misconfiguration that gives lockups/freezes/stalls. Rule of thumb is to always ensure that the tcp window size parameters of your server are larger than the wsize and rsize mount option of your hypervisor hosts. E.g. using Fedora 19 as a hypervisor node these parameters are set to 1 MB.

       # df
      ...
      10.10.30.253:/var/nas3/ovirt on /rhev/data-center/mnt/10.10.30.253:_var_nas3_ovirt type nfs (...,rsize=1048576,wsize=1048576,...)
      ...
       

In this case it is a good idea to set the tcp window parameters on the NFS server to at least 4 MB in /etc/sysctl.conf.

       # cat /etc/sysctl.conf
      net.ipv4.tcp_mem=4096 65536 4194304
      net.ipv4.tcp_rmem=4096 65536 4194304
      net.ipv4.tcp_wmem=4096 65536 4194304
      net.core.rmem_max=8388608
      net.core.wmem_max=8388608
       

To activate these settings for the running server reload them with

       # sysctl -p 
