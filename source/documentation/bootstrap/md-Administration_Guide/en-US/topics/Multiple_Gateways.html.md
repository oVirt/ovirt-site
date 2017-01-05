# Viewing or Editing the Gateway for a Logical Network

Users can define the gateway, along with the IP address and subnet mask, for a logical network. This is necessary when multiple networks exist on a host and traffic should be routed through the specified network, rather than the default gateway.

If multiple networks exist on a host and the gateways are not defined, return traffic will be routed through the default gateway, which may not reach the intended destination. This would result in users being unable to ping the host.

Red Hat Virtualization handles multiple gateways automatically whenever an interface goes up or down.

**Viewing or Editing the Gateway for a Logical Network**

1. Click the **Hosts** resource tab, and select the desired host.

2. Click the **Network Interfaces** tab in the details pane to list the network interfaces attached to the host and their configurations.

3. Click the **Setup Host Networks** button to open the **Setup Host Networks** window.

4. Hover your cursor over an assigned logical network and click the pencil icon to open the **Edit Management Network** window.

The **Edit Management Network** window displays the network name, the boot protocol, and the IP, subnet mask, and gateway addresses. The address information can be manually edited by selecting a **Static** boot protocol.

