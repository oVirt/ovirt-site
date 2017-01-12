# Backing Up a Virtual Machine

Use the backup and restore API to back up a virtual machine. This procedure assumes you have two virtual machines: the virtual machine to back up, and a virtual machine on which the software for managing the backup is installed.

**Backing Up a Virtual Machine**

1. Using the REST API, create a snapshot of the virtual machine to back up:

        POST /api/vms/11111111-1111-1111-1111-111111111111/snapshots/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <snapshot>
            <description>BACKUP</description>
        </snapshot>

    **Note:** When you take a snapshot of a virtual machine, a copy of the configuration data of the virtual machine as at the time the snapshot was taken is stored in the `data` attribute of the `configuration` attribute in `initialization` under the snapshot.

    **Important:** You cannot take snapshots of disks that are marked as shareable or that are based on direct LUN disks.

2. Retrieve the configuration data of the virtual machine from the `data` attribute under the snapshot:

        GET /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

3. Identify the disk ID and snapshot ID of the snapshot:

        GET /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111/disks HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

4. Attach the snapshot to the backup virtual machine and activate the disk:

        POST /api/vms/22222222-2222-2222-2222-222222222222/disks/ HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <disk id="11111111-1111-1111-1111-111111111111">
            <snapshot id="11111111-1111-1111-1111-111111111111"/>
            <active>true</active>
        </disk>

5. Use the backup software on the backup virtual machine to back up the data on the snapshot disk.

6. Detach the snapshot disk from the backup virtual machine:

        DELETE /api/vms/22222222-2222-2222-2222-222222222222/disks/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml
        
        <action>
            <detach>true</detach>
        </action>

7. Optionally, delete the snapshot:

        DELETE /api/vms/11111111-1111-1111-1111-111111111111/snapshots/11111111-1111-1111-1111-111111111111 HTTP/1.1
        Accept: application/xml
        Content-type: application/xml

You have backed up the state of a virtual machine at a fixed point in time using backup software installed on a separate virtual machine.
