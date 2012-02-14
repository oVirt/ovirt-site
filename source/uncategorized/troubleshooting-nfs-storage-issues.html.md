---
title: Troubleshooting NFS Storage Issues
authors: adahms, didi, dougsland, dpkshetty, jbrooks, nkesick, rharper, sgordon, suppentopf,
  wdennis
wiki_title: Troubleshooting NFS Storage Issues
wiki_revision_count: 24
wiki_last_updated: 2015-01-31
---

# Troubleshooting NFS Storage Issues

oVirt currently requires that NFS exports be configured in a specific way. This page is an attempt to list those requirements and assist with troubleshooting issues encountered when trying to attach an NFS storage domain to the oVirt environment for the first time.

*   The NFS server must support NFSv3. oVirt does not currently support NFSv4. To force an NFS client to use NFSv3, add this option to the configuration file (**/etc/nfsmount.conf**):

      Nfsvers=3

*   To disable NFSv4 on an NFS server, add this option to the configuration file (**/etc/sysconfig/nfs**):

      NFS4_SUPPORT="no"

*   The exported directory must be readable and writeable to the user/group with uid **36** which is the **vdsm** user. There are two ways to ensure this:
    -   Chown the directory being exported 36:36.
    -   Add the **anonuid=36** and **anongid=36** options on the export in **/etc/exports**.

      /exports/iso       *(rw,anonuid=36,anongid=36)

*   The exported directory should have permissions **0755**:
*   The NFS server must actually be running.
    -   Ensure that the **nfs** and **rpcbind** services are running on the NFS server, Fedora 16 users should instead look for the **netfs** service.
    -   Ensure that **showmounts -e *<nfs_server_ip>*** shows the expected export(s).
*   Ensure that selinux is not interfering with NFS access.
    -   getsebool -a | grep virt_use_nfs should show virt_use_nfs --> on, if not then do \`setsebool virt_use_nfs 1\` to allow NFS access for VMs
    -   One can also use \`setsebool -P virt_use_nfs 1\` to make this setting persistent across reboots.

The easiest way to definitively test that an NFS export is ready for use by oVirt is to:

*   Create the **vdsm** user with uid **36** on the ovirt-engine host if it does not already exist.
*   Change to the **vdsm** user using **su - vdsm**.
*   Attempt to mount the export to a temporary directory and touch a file on it.
