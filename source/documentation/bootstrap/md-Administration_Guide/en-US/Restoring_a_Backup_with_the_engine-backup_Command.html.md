# Restoring a Backup with the engine-backup Command

Restoring a backup using the engine-backup command involves more steps than creating a backup does, depending on the restoration destination. For example, the `engine-backup` command can be used to restore backups to fresh installations of Red Hat Virtualization, on top of existing installations of Red Hat Virtualization, and using local or remote databases.

**Important:** Backups can only be restored to environments of the same major release as that of the backup. For example, a backup of a Red Hat Virtualization version 4.0 environment can only be restored to another Red Hat Virtualization version 4.0 environment. To view the version of Red Hat Virtualization contained in a backup file, unpack the backup file and read the value in the `version` file located in the root directory of the unpacked files.
