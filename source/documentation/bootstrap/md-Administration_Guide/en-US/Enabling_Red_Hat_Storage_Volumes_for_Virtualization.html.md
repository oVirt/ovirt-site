# Optimizing Red Hat Gluster Storage Volumes to Store Virtual Machine Images

Optimize a Red Hat Gluster Storage volume to store virtual machine images using the Administration Portal.

To optimize a volume for storing virtual machines, the Manager sets a number of virtualization-specific parameters for the volume.

Volumes can be optimized to store virtual machines during creation by selecting the **Optimize for Virt Store** check box, or after creation using the **Optimize for Virt Store** button from the **Volumes** resource tab.

**Important:** If a volume is replicated across three or more nodes, ensure the volume is optimized for virtual storage to avoid data inconsistencies across the nodes.

An alternate method is to access one of the Red Hat Gluster Storage nodes and set the volume group to `virt`. This sets the `cluster.quorum-type` parameter to `auto`, and the `cluster.server-quorum-type` parameter to `server`.

    # gluster volume set VOLUME_NAME group virt

Verify the status of the volume by listing the volume information:

    # gluster volume info VOLUME_NAME


