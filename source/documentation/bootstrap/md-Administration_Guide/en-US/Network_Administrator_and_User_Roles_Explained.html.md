# Network Administrator and User Roles Explained

**Network Permission Roles**

The table below describes the administrator and user roles and privileges applicable to network administration.

**Red Hat Virtualization Network Administrator and User Roles**

| Role | Privileges | Notes |
|-
| NetworkAdmin | Network Administrator for data center, cluster, host, virtual machine, or template. The user who creates a network is automatically assigned **NetworkAdmin** permissions on the created network. | Can configure and manage the network of a particular data center, cluster, host, virtual machine, or template. A network administrator of a data center or cluster inherits network permissions for virtual pools within the cluster. To configure port mirroring on a virtual machine network, apply the **NetworkAdmin** role on the network and the **UserVmManager** role on the virtual machine. |
| VnicProfileUser | Logical network and network interface user for virtual machine and template. | Can attach or detach network interfaces from specific logical networks. |
