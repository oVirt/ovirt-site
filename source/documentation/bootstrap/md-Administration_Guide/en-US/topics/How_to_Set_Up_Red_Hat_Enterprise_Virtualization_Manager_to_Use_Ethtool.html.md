# How to Set Up Red Hat Virtualization Manager to Use Ethtool

You can configure ethtool properties for host network interface cards from the Administration Portal. The **ethtool_opts** key is not available by default and needs to be added to the Manager using the engine configuration tool. You also need to install the required VDSM hook package on the hosts.

**Adding the ethtool_opts Key to the Manager**

1. On the Manager, run the following command to add the key:

        # engine-config -s UserDefinedNetworkCustomProperties=ethtool_opts=.* --cver=4.0

2. Restart the `ovirt-engine` service: 

        # systemctl restart ovirt-engine.service

3. On the hosts that you want to configure ethtool properties, install the VDSM hook package. The package is available by default on Red Hat Virtualization Host but needs to be installed on Red Hat Enterprise Linux hosts.

        # yum install vdsm-hook-ethtool-options

The **ethtool_opts** key is now available in the Administration Portal. See [Editing host network interfaces](Editing_host_network_interfaces) to apply ethtool properties to logical networks.
