# Red Hat Virtualization Manager User Accounts

A number of system user accounts are created to support Red Hat Virtualization when the `rhevm` package is installed. Each system user has a default user identifier (UID). The system user accounts created are: 

* The `vdsm` user (UID `36`). Required for support tools that mount and access NFS storage domains.

* The `ovirt` user (UID `108`). Owner of the `ovirt-engine` Red Hat JBoss Enterprise Application Platform instance.

* The `ovirt-vmconsole` user (UID `498`). Required for the guest serial console. 


