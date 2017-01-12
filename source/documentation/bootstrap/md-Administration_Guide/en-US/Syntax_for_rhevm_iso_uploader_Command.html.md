# Syntax for the engine-iso-uploader Command

The basic syntax for the ISO uploader command is:

    engine-iso-uploader [options] list
    engine-iso-uploader [options] upload [file].[file]...[file]

The ISO uploader command supports two actions - `list`, and `upload`.

* The `list` action lists the ISO storage domains to which ISO files can be uploaded. The Red Hat Virtualization Manager creates this list on the machine on which the Manager is installed during the installation process.

* The `upload` action uploads a single ISO file or multiple ISO files separated by spaces to the specified ISO storage domain. NFS is used by default, but SSH is also available.

You must specify one of the above actions when you use the ISO uploader command. Moreover, you must specify at least one local file to use the `upload` action.

There are several parameters to further refine the `engine-iso-uploader` command.

**General Options**

`--version`
: Displays the version of the ISO uploader command.

`-h`, `--help`
: Displays information on how to use the ISO uploader command.

`--conf-file=[PATH]`
: Sets `[PATH]` as the configuration file the command will to use. The default is `/etc/ovirt-engine/isouploader.conf`.

`--log-file=[PATH]`
: Sets `[PATH]` as the specific file name the command will use to write log output. The default is `/var/log/ovirt-engine/ovirt-iso-uploader/ovirt-iso-uploader[date].log`.

`--cert-file=[PATH]`
: Sets `[PATH]` as the certificate for validating the engine. The default is `/etc/pki/ovirt-engine/ca.pem`.

`--insecure`
: Specifies that no attempt will be made to verify the engine.

`--nossl`
: Specifies that SSL will not be used to connect to the engine.

`--quiet`
: Sets quiet mode, reducing console output to a minimum.

`-v`, `--verbose`
: Sets verbose mode, providing more console output.

`-f`, `--force`
: Force mode is necessary when the source file being uploaded has the same file name as an existing file in the destination ISO domain. This option forces the existing file to be overwritten.

**Red Hat Virtualization Manager Options**

`-u [USER]`, `--user=[USER]`
: Specifies the user whose credentials will be used to execute the command. The `[USER]` is specified in the format `[username]`@`[domain]`. The user must exist in the specified domain and be known to the Red Hat Virtualization Manager.

`-r [FQDN]`, `--engine=[FQDN]`
: Specifies the IP address or fully qualified domain name of the Red Hat Virtualization Manager from which the images will be uploaded. It is assumed that the image uploader is being run from the same machine on which the Red Hat Virtualization Manager is installed. The default value is `localhost:443`.

**ISO Storage Domain Options**

The following options specify the ISO domain to which the images will be uploaded. These options cannot be used together; you must used either the `-i` option or the `-n` option.

`-i`, `--iso-domain=[ISODOMAIN]`
: Sets the storage domain `[ISODOMAIN]` as the destination for uploads.

`-n`, `--nfs-server=[NFSSERVER]`
: Sets the NFS path `[NFSSERVER]` as the destination for uploads.

**Connection Options**

The ISO uploader uses NFS as default to upload files. These options specify SSH file transfer instead.

`--ssh-user=[USER]`
: Sets `[USER]` as the SSH user name to use for the upload. The default is `root`.

`--ssh-port=[PORT]`
: Sets `[PORT]` as the port to use when connecting to SSH.

`-k [KEYFILE]`, `--key-file=[KEYFILE]`
: Sets `[KEYFILE]` as the public key to use for SSH authentication. You will be prompted to enter the password of the user specified with `--ssh-user=[USER]` if no key is set.

