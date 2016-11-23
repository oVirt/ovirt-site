# Live Migration Prerequisites

Live migration is used to seamlessly move virtual machines to support a number of common maintenance tasks. Ensure that your Red Hat Virtualization environment is correctly configured to support live migration well in advance of using it.

At a minimum, for successful live migration of virtual machines to be possible:n

* The source and destination host should both be members of the same cluster, ensuring CPU compatibility between them.

    **Note:** Live migrating virtual machines between different clusters is generally not recommended. The currently only supported use case is documented at [https://access.redhat.com/articles/1390733](https://access.redhat.com/articles/1390733).

* The source and destination host must have a status of `Up`.

* The source and destination host must have access to the same virtual networks and VLANs.

* The source and destination host must have access to the data storage domain on which the virtual machine resides.

* There must be enough CPU capacity on the destination host to support the virtual machine's requirements.

* There must be enough RAM on the destination host that is not in use to support the virtual machine's requirements.

* The migrating virtual machine must not have the `cache!=none` custom property set.

In addition, for best performance, the storage and management networks should be split to avoid network saturation. Virtual machine migration involves transferring large amounts of data between hosts.

Live migration is performed using the management network. Each live migration event is limited to a maximum transfer speed of 30 MBps, and the number of concurrent migrations supported is also limited by default. Despite these measures, concurrent migrations have the potential to saturate the management network. It is recommended that separate logical networks are created for storage, display, and virtual machine data to minimize the risk of network saturation.
