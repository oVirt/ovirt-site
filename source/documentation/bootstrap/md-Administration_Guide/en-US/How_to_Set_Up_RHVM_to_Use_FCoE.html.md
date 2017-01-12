# How to Set Up Red Hat Virtualization Manager to Use FCoE

You can configure Fibre Channel over Ethernet (FCoE) properties for host network interface cards from the Administration Portal. The **fcoe** key is not available by default and needs to be added to the Manager using the engine configuration tool. You can check whether **fcoe** has already been enabled by running the following command:

    # engine-config -g UserDefinedNetworkCustomProperties

You also need to install the required VDSM hook package on the hosts. Depending on the FCoE card on the hosts, special configuration may also be needed; see [Configuring a Fibre Channel over Ethernet Interface](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/fcoe-config.html) in the *Red Hat Enterprise Linux Storage Administration Guide*.

**Adding the fcoe Key to the Manager**

1. On the Manager, run the following command to add the key:

        # engine-config -s UserDefinedNetworkCustomProperties='fcoe=^((enable|dcb|auto_vlan)=(yes|no),?)*$'

2. Restart the `ovirt-engine` service: 

        # systemctl restart ovirt-engine.service

3. Install the VDSM hook package on each of the Red Hat Enterprise Linux hosts on which you want to configure FCoE properties. The package is available by default on Red Hat Virtualization Host (RHVH).

        # yum install vdsm-hook-fcoe

The **fcoe** key is now available in the Administration Portal. See [Editing host network interfaces](Editing_host_network_interfaces) to apply FCoE properties to logical networks.
