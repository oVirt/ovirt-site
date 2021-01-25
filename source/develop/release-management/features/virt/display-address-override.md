---
title: Display Address Override
category: feature
authors: tjelinek
---

# Display Address Override

## Summary

*   Support overriding of the display address per host
*   Add warnings to Web Admin to make the administrator aware if some hosts has the display address overridden and some not

## Owner

*   Name: Tomas Jelinek (TJelinek)
*   Email: <tjelinek@redhat.com>

## Current status

development

## Detailed Description

Support the following scenario:

*   The hosts are defined by internal IP and sitting behind a NAT firewall
*   When the user connects to the guest from User Portal from outside of the internal network, instead of returning the private address of the host on which the guest is running, a public IP or FQDN (which will be resolved in the external network to the public IP) will be returned
*   The firewall NATs the IP to the proper internal IP

### Webadmin

#### Configuration part

*   The new/edit host dialog will have a new side tab named "Console"
*   This side tab will contain a checkbox with label "Override display address"
*   Next to this checkbox a context sensitive help icon will be present with text: "Overrides the display address of all VMs on this host by the specified address."
*   Under this checkbox a text box with label "Display address" will be present which will be enabled only when the checkbox is checked
*   There will be a "hostname or IP" validation attached to this textbox (both on frontend and backend)

#### Usage part

When connecting to the console from WebAdmin or UserPortal, the display address will be the one configured in the Hosts dialog. If it is not configured, the address will be the address of the host.

#### Monitoring part

To help the administrator to avoid the situation that some hosts in the cluster have the display address overridden and some not, the following will be done in Web Admin:

*   In General subtab of the Cluster main tab a warning will be shown (the same format as in the General subtab of the Hosts main tab when the power management is not configured)
*   The warning message will be the following: "Some hosts in this cluster have the console address overridden and some not. For details please see the Hosts subtab"
*   The Hosts subtab of the Cluster main tab contains a table with list of hosts. This table will be enriched by a new column named "Display Address Overridden" which will contain "Yes" if the display address for this host has been overridden, else will contain "No"

### REST API

*   the *host* now contains a "display" property which contains the *address*.
*   if not set, the console address will not be overridden
*   if set, the console address will be overridden by the specified address

Example of creating a host with display address overridden:

      <host>
          <name>hostX</name>
          <address>som.address</address>
          <root_password>somePassword</root_password>
         <display>
             <address>someDisplayAddress</address>
         </display>
      </host>
       

If the display address has been overridden, the example of how to switch it back to the default:

       
      <host>
      <display>
      <address/>
      </display>
      </host>
       

## Documentation / External references

## Known issues

*   Live migration does not keep the spice console opened. To support live migration with opened spice console the <https://bugzilla.redhat.com/show_bug.cgi?id=883936> has to be fixed.

