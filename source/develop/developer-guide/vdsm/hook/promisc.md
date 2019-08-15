---
title: promisc
authors: dyasny
---

# promisc

The promisc vdsm hook provides the ability to mirror/redirect other VMs network traffic to a single VM.

The hook is getting network (bridge) name and mode:

      promisc=blue:mirror,red:redirect 

and sets the current running VM in promiscuous mode, ie: mirror all blue traffic to current VM

syntax:

      promisc=blue:mirror

mirror monitoring the network blue (all traffic will goto the VMs interface and the network)

      promisc=vnet0:redirect

redirect vm traffic to vnet0 interface (all traffic will go to the VM's interface, and it's the VM responsibility to redirect the traffic back to the VM)

## redirect mode:

In redirect mode with tc we filter the vm interface, NOTE: currently the redirect is redirecting vm interface and not the bridge like the mirror mode does, if you use the bridge interface in redirect mode you can lose the network connection to the server!

vnet0 = security vm, running IPS/IDS vnet1 = the vm which we want to monitor its traffic

add filter:

      $ ifconfig blue promisc
      $ tc qdisc add dev vnet1 ingress
      $ tc filter add dev vnet1 parent ffff: protocol ip u32 match u8 0 0 action mirred egress redirect dev vnet0
      $ tc qdisc replace dev vnet1 parent root prio
      ` $ id=`tc qdisc show dev vnet1 | grep prio | awk '{print $3}'` `
      $ tc filter add dev vnet1 parent $id protocol ip u32 match u8 0 0 action mirred egress redirect dev vnet0

remove filter:

      $ tc qdisc del dev vnet1 root
      $ tc qdisc del dev vnet1 ingress
      $ ifconfig blue -promisc

## in-line (redirect) mode with ebtables sample:

*   use redirect instead of mirror for in-line mode (ie don't copy the packets forward it to ifaceName and he will redirect them)
*   redirect (not mirror) with ebtables:

need to change the mac address of the packets from monitored interface to the monitoring interface. (the IP stays the same, so this way you know that the packets are not meant for the monitoring machine).

set the bridge in promisc mode

      $ ifconfig `<netwok name>` promisc

traffic to the monitoring machine

      $ ebtables -t nat -A PREROUTING -d 00:1a:4a:16:01:51 -i eth0 -j dnat --to-destination 00:1a:4a:16:01:11

traffic from the monitoring machine

      $ ebtables -t nat -A PREROUTING -s 00:1a:4a:16:01:51 -i vnet0 -j dnat --to-destination 00:1a:4a:16:01:11

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-promisc-4.10.0-0.442.git6822c4b.el6.noarch.rpm>
