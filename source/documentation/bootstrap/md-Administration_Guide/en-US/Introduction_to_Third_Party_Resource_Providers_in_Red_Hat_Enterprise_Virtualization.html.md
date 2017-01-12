# Introduction to External Providers in Red Hat Virtualization

In addition to resources managed by the Red Hat Virtualization Manager itself, Red Hat Virtualization can also take advantage of resources managed by external sources. The providers of these resources, known as external providers, can provide resources such as virtualization hosts, virtual machine images, and networks.

Red Hat Virtualization currently supports the following external providers:

Red Hat Satellite for Host Provisioning
: Satellite is a tool for managing all aspects of the life cycle of both physical and virtual hosts. In Red Hat Virtualization, hosts managed by Satellite can be added to and used by the Red Hat Virtualization Manager as virtualization hosts. After you add a Satellite instance to the Manager, the hosts managed by the Satellite instance can be added by searching for available hosts on that Satellite instance when adding a new host. For more information on installing Red Hat Satellite and managing hosts using Red Hat Satellite, see the [Installation Guide](https://access.redhat.com/documentation/en/red-hat-satellite/6.2/paged/installation-guide/) and [Host Configuration Guide](https://access.redhat.com/documentation/en/red-hat-satellite/6.2/paged/host-configuration-guide/).

OpenStack Image Service (Glance) for Image Management
: OpenStack Image Service provides a catalog of virtual machine images. In Red Hat Virtualization, these images can be imported into the Red Hat Virtualization Manager and used as floating disks or attached to virtual machines and converted into templates. After you add an OpenStack Image Service to the Manager, it appears as a storage domain that is not attached to any data center. Virtual machine disks in a Red Hat Virtualization environment can also be exported to an OpenStack Image Service as virtual machine disk images.

OpenStack Networking (Neutron) for Network Provisioning
: OpenStack Networking provides software-defined networks. In Red Hat Virtualization, networks provided by OpenStack Networking can be imported into the Red Hat Virtualization Manager and used to carry all types of traffic and create complicated network topologies. After you add OpenStack Networking to the Manager, you can access the networks provided by OpenStack Networking by manually importing them.

OpenStack Volume (Cinder) for Storage Management
: OpenStack Volume provides persistent block storage management for virtual hard drives. The OpenStack Cinder volumes are provisioned by Ceph Storage. In Red Hat Virtualization, you can create disks on OpenStack Volume storage that can be used as floating disks or attached to virtual machines. After you add OpenStack Volume to the Manager, you can create a disk on the storage provided by OpenStack Volume.

VMware for Virtual Machine Provisioning
: Virtual machines created in VMware can be converted using V2V (`virt-v2v`) and imported into a Red Hat Virtualization environment. After you add a VMware provider to the Manager, you can import the virtual machines it provides. V2V conversion is performed on a designated proxy host as part of the import operation.

External Network Provider for Network Provisioning
: Supported external sofware-defined network providers include any provider that implements the OpenStack Neutron REST API. Unlike OpenStack Networking (Neutron), the Neutron agent is not used as the virtual interface driver implementation on the host. Instead, the virtual interface driver needs to be provided by the implementer of the external network provider.

All external resource providers are added using a single window that adapts to your input. You must add the resource provider before you can use the resources it provides in your Red Hat Virtualization environment.
