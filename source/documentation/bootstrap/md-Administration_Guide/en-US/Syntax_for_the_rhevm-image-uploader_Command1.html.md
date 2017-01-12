# Syntax for the engine-image-uploader Command

The basic syntax for the image uploader command is:

    engine-image-uploader [options] list
    engine-image-uploader [options] upload [file].[file]...[file]

The image uploader command supports two actions - `list`, and `upload`.

* The `list` action lists the export storage domains to which images can be uploaded.

* The `upload` action uploads images to the specified export storage domain.

You must specify one of the above actions when you use the image uploader command. Moreover, you must specify at least one local file to use the `upload` action.

There are several parameters to further refine the `engine-image-uploader` command. You can set defaults for any of these parameters in the `/etc/ovirt-engine/imageuploader.conf` file.

**General Options**

`-h`, `--help`
: Displays information on how to use the image uploader command.

`--conf-file=[PATH]`
: Sets `[PATH]` as the configuration file the command will use. The default is `etc/ovirt-engine/imageuploader.conf`.

`--log-file=[PATH]`
: Sets `[PATH]` as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-image-uploader/ovirt-image-uploader-[date].log`.

`--cert-file=[PATH]`
: Sets `[PATH]` as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

`--insecure`
: Specifies that no attempt will be made to verify the engine.

`--quiet`
: Sets quiet mode, reducing console output to a minimum.

`-v`, `--verbose`
: Sets verbose mode, providing more console output.

`-f`, `--force`
: Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination export domain. This option forces the existing file to be overwritten.

**Red Hat Virtualization Manager Options**

`-u [USER]`, `--user=[USER]`
: Specifies the user whose credentials will be used to execute the command. The `[USER]` is specified in the format `[username]@[domain]`. The user must exist in the specified domain and be known to the Red Hat Virtualization Manager.

`-r [FQDN]`, `--engine=[FQDN]`
: Specifies the IP address or fully qualified domain name of the Red Hat Virtualization Manager from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which the Red Hat Virtualization Manager is installed. The default value is `localhost:443`.

**Export Storage Domain Options**

The following options specify the export domain to which the images will be uploaded. These options cannot be used together; you must used either the `-e` option or the `-n` option.

`-e [EXPORT_DOMAIN]`, `--export-domain=[EXPORT_DOMAIN]`
: Sets the storage domain `EXPORT_DOMAIN` as the destination for uploads.

`-n [NFSSERVER]`, `--nfs-server=[NFSSERVER]`
: Sets the NFS path `[NFSSERVER]` as the destination for uploads.

**Import Options**

The following options allow you to customize which attributes of the images being uploaded are included when the image is uploaded to the export domain.

`-i`, `--ovf-id`
: Specifies that the UUID of the image will not be updated. By default, the command generates a new UUID for images that are uploaded. This ensures there is no conflict between the id of the image being uploaded and the images already in the environment.

`-d`, `--disk-instance-id`
: Specifies that the instance ID for each disk in the image will not be renamed. By default, the command generates new UUIDs for disks in images that are uploaded. This ensures there are no conflicts between the disks on the image being uploaded and the disks already in the environment.

`-m`, `--mac-address`
: Specifies that network components in the image will not be removed from the image. By default, the command removes network interface cards from image being uploaded to prevent conflicts with network cards on other virtual machines already in the environment. If you do not use this option, you can use the Administration Portal to add network interface cards to newly imported images and the Manager will ensure there are no MAC address conflicts.

`-N [NEW_IMAGE_NAME]`, `--name=[NEW_IMAGE_NAME]`
: Specifies a new name for the image being uploaded.
