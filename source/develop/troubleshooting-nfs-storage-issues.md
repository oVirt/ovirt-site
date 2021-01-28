---
title: Troubleshooting NFS Storage Issues
authors: adahms, didi, dougsland, dpkshetty, jbrooks, nkesick, rharper, sgordon, suppentopf, 
  wdennis

---

# Troubleshooting NFS Storage Issues

### Introduction

To attach NFS storage domains to an oVirt environment, the NFS exports must be configured in a specific way. This page is designed to outline the core requirements for configuring NFS exports, and assist in troubleshooting issues encountered when attempting to attach NFS storage domains to an oVirt environment for the first time.

### Permissions

In principle, the user **vdsm**, with uid **36** and gid **36**, must have read and write permissions on all NFS exports. However, some daemons on the hypervisor hosts (for example, sanlock) use a different uid but need access to the directory too. Therefore, all incoming NFS requests must be mapped to the aforementioned uid and gid on both client and NFS server. There are several steps required to ensure this mapping  works as needed:

1. Change the ownership of the export directory, replacing *directory_name* with the name of the directory:

        # chown 36:36 directory_name

2. Add the **rw** options on the export in **/etc/exports**.

        # /exports/directory_name       *(rw)

3. Set the permissions of the export directory, replacing *directory_name* with the name of the directory:

        # chmod 0755 directory_name

4. The NFS server must actually be running.

5. For some Linux NFS server configurations, specifically Ubuntu, the --manage-gids flag (default) for rpc.mountd must be disabled.

        # grep RPCMOUNTDOPTS /etc/default/nfs-kernel-server
          RPCMOUNTDOPTS=""               # <--- correct setting
          #RPCMOUNTDOPTS="--manage-gids" # <--- Incorrect setting

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
*   Change to the **sanlock** user using **su - sanlock -s /bin/bash**
*   Test that sanlock user can cat the file created *by* vdsm. i.e. **cat /tmpmnt/tempfile**


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

       $ git clone "https://gerrit.ovirt.org/vdsm"
       $ cd vdsm/contrib
       $ python nfs-check.py myNFSServer:/nfsTarget

### Setting NFS Server

#### Ubuntu 19.10 or 20.04 - without network directory/group/user services
See the [Ubuntu NFS Server documentation](https://ubuntu.com/server/docs/service-nfs) for more details.

    #> mkdir -m 0755 /exports/00
    #> chown 36:36 /exports/00
    #> cat /etc/exports
    # setting anonuid and anongid to 36:36 here allows you to omit creating the specific UID and GID on the server.
    /exports/00 *(rw,sync,anonuid=36,anongid=36,no_subtree_check)   
    #> systemctl enable nfs-kernel-server && systemctl start nfs-kernel-server
    #> systemctl enable rpcbind.service && systemctl start rpcbind.service
    #> exportfs -a

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

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # yum -y install nfs-utils

      # cat /etc/exports
      /storage    *(rw)

      # systemctl start rpcbind.service
      # systemctl start nfs-server.service
      
      # Relevant only for NFS v3
      # systemctl start nfs-lock.service 
      

      # systemctl enable rpcbind.service
      # systemctl enable nfs-server.service
       

      # Relevant only for NFS v3
      # systemctl enable nfs-lock.service

#### RHEL7 based distro

      #> groupadd kvm -g 36
      #> useradd vdsm -u 36 -g kvm

      # mkdir /storage

      # chmod 0755 /storage
      # chown 36:36 /storage/

      # cat /etc/exports
      /storage    *(rw)

      # systemctl enable rpcbind
      # systemctl enable nfs-server
      # systemctl start rpcbind 
      # systemctl start nfs-server


# Workarounds for known issues

#### TODO: update for the newer supported releases

## NFS Lockups

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


## Failure to activate NFS Storage 
When deploying Self Hosted Engine through cli (ovirt-hosted-engine-setup) or Cockpit web UI, or when adding NFS storage domain to a Standalone manager installation activation of NFS storage fails. The above nfs-check.py will missleadingly succeed.  

### Troubleshooting checklist
* NFS share mounts successfully briefly but reports failure. You can monitor if NFS share  by running simple while loop on the ovirt node in another terminal. 
        # while :; do  mount| grep nfs | grep -v rpc_pipefs; done
* Files are created with correct uid:gid (36:36)
* Check that sanlock user can  read and write files to the filesystem when mounted manually. 
* Disable SELinux or AppArmor on the NFS server (as a last resort) doesn't fix the issue.

### Check the logs 
There are 3 logs to check for storage initialization issues found in /var/log/.
* vdsm/vdsm.log
* vdsm/supervdsm.log
* sanlock.log

Review these log files for errors. If you see an error in sanlock.log like the one below, you likely need to change the settings of your NFS server.

    open error -13 EACCES: no permission to open /rhev/data-center/mnt/nfsserver.example.net:_exports_00/68d3a420-00db-429f-be76-259fdc407c3d/dom_md/ids2021-01-24 15:31:26 230083 [121045]: check that daemon user sanlock 179 group sanlock 179 has access to disk or file.






