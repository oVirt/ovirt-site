# Restoring a Virtual Machine

Restore a virtual machine that has been backed up using the backup and restore API. This procedure assumes you have a backup virtual machine on which the software used to manage the previous backup is installed.

**Restoring a Virtual Machine**

1. In the Administration Portal, create a floating disk on which to restore the backup. See [Creating Unassociated Virtual Machine Hard Disks](Creating_Unassociated_Virtual_Machine_Hard_Disks) for details on how to create a floating disk.

2. Attach the disk to the backup virtual machine:

        POST /api/vms/22222222-2222-2222-2222-222222222222/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <disk id="11111111-1111-1111-1111-111111111111">
        </disk>

3.  Use the backup software to restore the backup to the disk.

4. Detach the disk from the backup virtual machine:

        DELETE /api/vms/22222222-2222-2222-2222-222222222222/disks/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <action>
            <detach>true</detach>
        </action>

5. Create a new virtual machine using the configuration data of the virtual machine being restored:

        POST /api/vms/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <vm>
            <cluster>
                <name>cluster_name</name>
            </cluster>
            <name>NAME</name>
            ...
        </vm>

6. Attach the disk to the new virtual machine:

        POST /api/vms/33333333-3333-3333-3333-333333333333/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <disk id="11111111-1111-1111-1111-111111111111">
        </disk>

You have restored a virtual machine using a backup that was created using the backup and restore API.
