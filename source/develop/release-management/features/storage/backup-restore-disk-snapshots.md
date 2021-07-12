---
title: Backup-Restore Disk-Snapshots
category: feature
authors: derez
---

# Backup-Restore Disk-Snapshots

## Summary

This feature is a complementary component for providing ability to backup and
restore virtual machines. The feature introduces a support for downloading and
uploading disk-snapshots, using the REST-API. Images transfer is facilitated
using [ovirt-imageio](https://github.com/oVirt/ovirt-imageio)

The following backup/restore examples are facilitated using oVirt Python-SDK.
oVirt REST-API/SDKs can be used in a similar manner.

## Backup 

### Download a VM OVF

[Full Example](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_vm_ovf.py)

In order to fetch a VM configuration data, 'all_content' flag should be specified.
Then, it can be written into a new file - that's the OVF. 
Note: The OVF contains sufficient information about disks and snapshots to restore
the VM to original state (e.g. alias/description/date). However, it isn't automatically
parsed by the system, but rather should be done by the SDK user.  

```python
vm_name = 'myvm'
vm = vms_service.list(search="name=%s" % vm_name, all_content=True)[0]
ovf_filename = "%s.ovf" % vm.id
with open(ovf_filename, "wb") as ovf_file:
    ovf_file.write(vm.initialization.configuration.data)
```

### Download Disks

[Full Example](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_all_disk_snapshots.py)

The following example demonstrates the procedure of downloading the non-active disk-snapshots
of a specified disk. Hence, in order to include the active layer as well, either create
a new snapshot for the disk in advance, or download the active disk-snapshot using the[Download Disk Example](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_disk.py)


In order to download the active

* For each disk, iterate over its disk-snapshots and execute image transfer.

  ```python
    # Set relevant disk and stroage domain IDs
    disk_id = 'ccdd6487-0a8f-40c8-9f45-40e0e2b30d79'
    sd_name = 'mydata'
        
    # Get a reference to the storage domains service:
    storage_domains_service = system_service.storage_domains_service()
        
    # Look up for the storage domain by name:
    storage_domain = storage_domains_service.list(search='name=%s' % sd_name)[0]
        
    # Get a reference to the storage domain service in which the disk snapshots reside:
    storage_domain_service = storage_domains_service.storage_domain_service(storage_domain.id)
        
    # Get a reference to the disk snapshots service:
    disk_snapshot_service = storage_domain_service.disk_snapshots_service()
        
    # Get a list of disk snapshots by a disk ID
    all_disk_snapshots = disk_snapshot_service.list()
        
    # Filter disk snapshots list by disk id
    disk_snapshots = [s for s in all_disk_snapshots if s.disk.id == disk_id]
        
    # Download disk snapshots
    for disk_snapshot in disk_snapshots:
        download_disk_snapshot(disk_snapshot)
  ```

* The ImageTransfer object should be specified with a 'snapshot' attribute.

  ```python
    transfer = transfers_service.add(
        types.ImageTransfer(
            snapshot=types.DiskSnapshot(id=disk_snapshot_id),
            direction=types.ImageTransferDirection.DOWNLOAD,
        )
    )
  ```

## Restore

[Full Example](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/upload_disk_snapshots.py)

### Compose disk-snapshots chain

Using the saved images files, create a chain of the disk-snapshots.
The chain is built by fetching the volume info (using qemu-img)
of each file, and find the backing filename (volume's parent).
By maintaing a map between parent and child volumes, we can
construct the chain, starting from base volume.

```python
    volumes_info = {}   # {filename -> vol_info}
    backing_files = {}  # {backing_file (parent) -> vol_info (child)}
    for root, dirs, file_names in os.walk(disk_path):
        for file_name in file_names:
            volume_info = get_volume_info("%s/%s" % (disk_path, file_name))
            volumes_info[file_name] = volume_info
            if 'full-backing-filename' in volume_info:
                backing_files[volume_info['full-backing-filename']] = volume_info
    
    base_volume = [v for v in volumes_info.values() if 'full-backing-filename' not in v ][0]
    child = backing_files[base_volume['filename']]
    images_chain = [base_volume]
    while child != None:
        images_chain.append(child)
        parent = child
        if parent['filename'] in backing_files:
            child = backing_files[parent['filename']]
        else:
            child = None
    
    return images_chain
```

### Create disks

For each disk, invoke disk creation for the base image using 
the generated images chain from previous step. The content of
the disks will be uploaded in a later step.

```python
    base_image = images_chain[0]
    initial_size = base_image['actual-size']
    provisioned_size = base_image['virtual-size']
    image_id = os.path.basename(base_image['filename'])

    disk = disks_service.add(
        types.Disk(
            id=disk_id,
            image_id=image_id,
            name=disk_id,
            format=types.DiskFormat.RAW,
            provisioned_size=provisioned_size,
            initial_size=initial_size,
            storage_domains=[
                types.StorageDomain(
                    name=sd_name
                )
            ]
        )
    )
```

### Add a VM from OVF

Adding the saved VM is done by specifing the ovf data within the configuration element.

```python
    ovf_file_path = 'c3a8e806-106d-4aff-b59a-3a113eabf5a9.ovf'
    ovf_data = open(ovf_file_path, 'r').read()
    vms_service = system_service.vms_service()
    vm = vms_service.add(
        types.Vm(
            cluster=types.Cluster(
                name='Default',
            ),
            initialization = types.Initialization(
                configuration = types.Configuration(
                    type = types.ConfigurationType.OVF,
                    data = ovf_data
                )
            ),
        ),
    )
```

### Create Snapshots

For each disk-snapshot in the chain, create a snapshot using the disk ID and image ID
(and optionally the saved description).

```python
    # Locate the service that manages the snapshots of the virtual machine:
    snapshots_service = vm_service.snapshots_service()

    # Add the new snapshot:
    snapshot = snapshots_service.add(
        types.Snapshot(
            description=description,
            disk_attachments=[
                types.DiskAttachment(
                    disk=types.Disk(
                        id=disk_id,
                        image_id=image_id
                    )
                )
            ]
        ),
    )
```

### Upload disks

For each disk-snapshot in the chain, start an upload transfer. 

```python
    # Get a reference to the service that manages the image transfer:
    transfers_service = system_service.image_transfers_service()

    # Add a new image transfer:
    transfer = transfers_service.add(
        types.ImageTransfer(
            snapshot=types.DiskSnapshot(id=disk_snapshot_id),
            direction=types.ImageTransferDirection.UPLOAD,
        )
    )

    # Get reference to the created transfer service:
    transfer_service = transfers_service.image_transfer_service(transfer.id)

    while transfer.phase == types.ImageTransferPhase.INITIALIZING:
        time.sleep(1)
        transfer = transfer_service.get()

    try:
        proxy_url = urlparse(transfer.proxy_url)
        proxy_connection = get_proxy_connection(proxy_url)
        path = disk_path

        # Set needed headers for uploading:
        upload_headers = {
            'Authorization': transfer.signed_ticket,
        }

        with open(path, "rb") as disk:
            size = os.path.getsize(path)
            chunk_size = 1024 * 1024 * 8
            pos = 0
            while pos < size:
                # Extend the transfer session.
                transfer_service.extend()
                # Set the content range, according to the chunk being sent.
                upload_headers['Content-Range'] = "bytes %d-%d/%d" % (pos, min(pos + chunk_size, size) - 1, size)
                # Perform the request.
                proxy_connection.request(
                    'PUT',
                    proxy_url.path,
                    disk.read(chunk_size),
                    headers=upload_headers,
                )
                # Print response
                r = proxy_connection.getresponse()
                print r.status, r.reason, "Completed", "{:.0%}".format(pos / float(size))
                # Continue to next chunk.
                pos += chunk_size

        print "Completed", "{:.0%}".format(pos / float(size))
    finally:
        # Finalize the session.
        transfer_service.finalize()
```

## Appendix

### Python SDK examples

* [Download VM OVF](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_vm_ovf.py)

* [Download Disk Snapshots](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_all_disk_snapshots.py)

* [Upload Disk Snapshots](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/upload_disk_snapshots.py)

* [Download Disk](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/download_disk.py)

* [Upload Disk](https://github.com/oVirt/ovirt-engine-sdk/blob/master/sdk/examples/upload_disk.py)
