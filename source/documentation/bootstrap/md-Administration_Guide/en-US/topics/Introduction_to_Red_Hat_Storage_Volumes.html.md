# Introduction to Red Hat Gluster Storage (GlusterFS) Volumes

Red Hat Gluster Storage volumes combine storage from more than one Red Hat Gluster Storage server into a single global namespace. A volume is a collection of bricks, where each brick is a mountpoint or directory on a Red Hat Gluster Storage Server in the trusted storage pool.

Most of the management operations of Red Hat Gluster Storage happen on the volume.

You can use the Administration Portal to create and start new volumes. You can monitor volumes in your Red Hat Gluster Storage cluster from the **Volumes** tab.

While volumes can be created and managed from the Administration Portal, bricks must be created on the individual Red Hat Gluster Storage nodes before they can be added to volumes using the Administration Portal
