# Example Uses of Custom Bonding Options with Host Interfaces

You can create customized bond devices by selecting **Custom** from the **Bonding Mode** of the **Create New Bond** window. The following examples should be adapted for your needs. For a comprehensive list of bonding options and their descriptions, see the [*Linux Ethernet Bonding Driver HOWTO*](https://www.kernel.org/doc/Documentation/networking/bonding.txt) on Kernel.org.

**xmit_hash_policy**

This option defines the transmit load balancing policy for bonding modes 2 and 4. For example, if the majority of your traffic is between many different IP addresses, you may want to set a policy to balance by IP address. You can set this load-balancing policy by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=4 xmit_hash_policy=layer2+3

**ARP Monitoring**

ARP monitor is useful for systems which can't or don't report link-state properly via ethtool. Set an `arp_interval` on the bond device of the host by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 arp_interval=1 arp_ip_target=192.168.0.2

**Primary**

You may want to designate a NIC with higher throughput as the primary interface in a bond device. Designate which NIC is primary by selecting a **Custom** bonding mode, and entering the following into the text field:

    mode=1 primary=eth0
