# NFS Metrics

NFS metrics enable you to analyze the use of NFS procedures.

The following table describes the NFS metrics reported by the **NFS** plugin.

<table>
<tr>
  <th>Metric Name</th>
  <th colspan="3">collectd.type_instance</th>
  <th>Description</th>
</tr>
<tr>
  <td>collectd.nfs.nfs_procedure </td>
  <td>null / getattr / lookup / access / readlink / read / write / create / mkdir / symlink / mknod / rename / readdir / remove / link / fsstat / fsinfo / readdirplus / pathconf / rmdir / commit / compound / reserved / access / close / delegpurge / putfh / putpubfh putrootfh / renew / restorefh / savefh / secinfo </td>
  <td> / setattr / setclientid / setcltid_confirm / verify / open / openattr / open_confirm / exchange_id / create_session / destroy_session / bind_conn_to_session / delegreturn / getattr / getfh / lock / lockt / locku / lookupp /  open_downgrade / nverify </td>
  <td> / release_lockowner / backchannel_ctl / free_stateid / get_dir_delegation / getdeviceinfo / getdevicelist / layoutcommit / layoutget / layoutreturn / secinfo_no_name / sequence / set_ssv / test_stateid / want_delegation / destroy_clientid / reclaim_complete </td>
  <td>The number of processes per _collectd.type_instance_ state.</td>
</tr>
</table>

**Additional Values**

* **collectd.plugin:** NFS
* **collectd.plugin_instance:** *File system + server or client (for example: v3client)*
* **collectd.type:** nfs_procedure
* **ovirt.entity:** host
* **ovirt.cluster.name.raw:** *The cluster's name*
* **ovirt.engine_fqdn.raw:** *The Manager's FQDN*
* **hostname:** *The host's FQDN*
* **ipaddr4:** *IP address*
* **interval:** 10
* **collectd.dstypes:** [Derive](../Derive)

