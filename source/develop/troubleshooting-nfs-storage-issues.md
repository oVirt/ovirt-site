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
  - gocallag
---

# Troubleshooting NFS Storage Issues

### Introduction

To attach NFS storage domains to an oVirt environment, the NFS exports must be configured in a specific way. This page is designed to outline the core requirements for configuring NFS exports, and assist in troubleshooting issues encountered when attempting to attach NFS storage domains to an oVirt environment for the first time.

## RHEL derivative based NFS Servers

### NFS Server - Permissions

In principle, the user **vdsm**, with uid **36** and gid **36**, must have read and write permissions on all NFS exports. However, some daemons on the hypervisor hosts (for example, sanlock) use a different uid but need access to the directory too. Therefore, all incoming NFS requests must be mapped to the aforementioned uid and gid. Two steps are required to ensure this mapping:

1. Change the ownership of the export directory, replacing *directory_name* with the name of the directory:
   ```console
   # chown 36:36 directory_name
   ```

2. Add the **rw** options on the export in `/etc/exports`.
   ```
   /exports/directory_name       *(rw)
   ```

3. Set the permissions of the export directory, replacing *directory_name* with the name of the directory:
   ```console
   # chmod 0755 directory_name
   ```

### NFS Server - Services 

1. The NFS server must actually be running.
   ```console
   # systemctl enable --now nfs-server
   ```

a. Ensure that the **nfs** and **rpcbind** services are running on the NFS server,
b. Ensure that `showmount -e <nfs_server_ip>` shows the expected export(s).

2. Allow traffic through the NFS server firewall

   ```console
   # firewall-cmd --permanent --add-service=nfs
   # firewall-cmd --permanent --add-source=<your manager ip>
   # firewall-cmd --reload        # NFS vers=4 works at this point
   # firewall-cmd --permanent --add-service=rpc-bind --add-service=mountd
   # firewall-cmd --permanent --add-port=32767/tcp --add-port=32767/udp --add-port=32765/tcp --add-port=32765/udp
   # firewall-cmd --reload        # NFS vers=3 and 4 works at this point
   ```

#### NFS Server - SELinux

*   Ensure that selinux is not interfering with NFS access.
    -   `getsebool -a | grep virt_use_nfs` should show `virt_use_nfs --> on`, if not then do `setsebool virt_use_nfs 1` to allow NFS access for VMs
    -   One can also use `setsebool -P virt_use_nfs 1` to make this setting persistent across reboots.

## Engine Server - Testing that the NFS server works

The easiest way to definitively test that an NFS export is ready for use by oVirt is to:

*   On the engine host (as the root user)
    ```console
    # mkdir -p /tmpmnt
    # /bin/mount -t nfs -o soft,nosharecache,timeo=600,retrans=6,nfsvers=3 *your-nfs-servername:/path/of/export* /tmpmnt
    ```

Create the **vdsm** user with uid **36** on the ovirt-engine host if it does not already exist.
*   Change to the **vdsm** user using `su - vdsm -s /bin/bash`
*   Try to create a file in it via the `touch` command, i.e. `touch /tmpmnt/tempfile`
*   Cleanup the file `rm -f /tmpmnt/tempfile`
*   Exit from the vdsm user and cleanup the temporary mountmount
    ```console
    # exit  
    # umount /tmpmnt
    # rf -rf /tmpmnt
    ```


### nfs-check program

A **nfs-check** script is now available to test whether an NFS export is ready for use by oVirt :

*   **nfs-check.py** is a python script to validate nfs targets to use with oVirt project. Some operations include: mount the nfs target, create a file as vdsm:kvm and then remove it.
*   **nfs-check.py** is available in the **vdsm/contrib/** directory of the vdsm source
*   Run it on a node via `python nfs-check.py 'server:/target'`
    ```console
    $ curl -o nfs-check.py https://raw.githubusercontent.com/oVirt/vdsm/refs/heads/master/contrib/nfs-check.py
    $ python3 nfs-check.py myNFSServer:/nfsTarget
    ```

## Commercial NAS

It is not possible to provide details for all commercial NAS devices. The above RHEL derivative information should give you clues as to how the configure your commercial NAS to work with oVirt.
*   In general you will want to at least enable nfsvers=3 in your NAS and enable any appropriate firewall rules.
*   You may need to squash all NFS requests to a specific NAS user on your device and give r/w to that specific NAS user.
*   The `nfs-check.py` will assist you in connection testing to your NAS from oVirt.
