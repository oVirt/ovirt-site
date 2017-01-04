# Settings to Wipe Virtual Disks After Deletion

The `wipe_after_delete` flag, viewed in the Administration Portal as the **Wipe After Delete** check box will replace used data with zeros when a virtual disk is deleted. If it is set to false, which is the default, deleting the disk will open up those blocks for re-use but will not wipe the data. It is, therefore, possible for this data to be recovered because the blocks have not been returned to zero.

The `wipe_after_delete` flag only works on block storage. On file storage, for example NFS, the option does nothing because the file system will ensure that no data exists.

Enabling `wipe_after_delete` for virtual disks is more secure, and is recommended if the virtual disk has contained any sensitive data. This is a more intensive operation and users may experience degradation in performance and prolonged delete times.

**Note:** The wipe after delete functionality is not the same as secure delete, and cannot guarantee that the data is removed from the storage, just that new disks created on same storage will not expose data from old disks.

The `wipe_after_delete` flag default can be changed to `true` during the setup process (see [Configuring the Red Hat Virtualization Manager](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#Red_Hat_Enterprise_Virtualization_Manager_Configuration_Overview) in the *Installation Guide*), or by using the engine configuration tool on the Red Hat Virtualization Manager. Restart the engine for the setting change to take effect.

**Setting SANWipeAfterDelete to Default to True Using the Engine Configuration Tool**

1. Run the engine configuration tool with the `--set` action:

        # engine-config --set SANWipeAfterDelete=true

2. Restart the engine for the change to take effect:

        # systemctl restart ovirt-engine.service

The `/var/log/vdsm/vdsm.log` file located on the host can be checked to confirm that a virtual disk was successfully wiped and deleted.

For a successful wipe, the log file will contain the entry, `storage_domain_id/volume_id was zeroed and will be deleted`. For example:

    a9cb0625-d5dc-49ab-8ad1-72722e82b0bf/a49351a7-15d8-4932-8d67-512a369f9d61 was zeroed and will be deleted

For a successful deletion, the log file will contain the entry, `finished with VG:storage_domain_id LVs: list_of_volume_ids, img: image_id`. For example:

    finished with VG:a9cb0625-d5dc-49ab-8ad1-72722e82b0bf LVs: {'a49351a7-15d8-4932-8d67-512a369f9d61': ImgsPar(imgs=['11f8b3be-fa96-4f6a-bb83-14c9b12b6e0d'], parent='00000000-0000-0000-0000-000000000000')}, img: 11f8b3be-fa96-4f6a-bb83-14c9b12b6e0d 

An unsuccessful wipe will display a log message `zeroing storage_domain_id/volume_id failed. Zero and remove this volume manually`, and an unsuccessful delete will display `Remove failed for some of VG: storage_domain_id zeroed volumes: list_of_volume_ids`.
