---
title: Updating the oVirt Environment
---

# Chapter 1: Updating the oVirt Environment

## oVirt Upgrade Overview

This guide explains how to upgrade your current environment to 4.2. Two upgrade paths are documented here:

* **Local Database:** Both Data Warehouse and the Manager database are installed on the Manager.

* **Remote Database:** Data Warehouse is on a separate machine.

To upgrade a self-hosted engine, see "Upgrading a Self-Hosted Engine Environment" in the [Self-Hosted Engine Guide](../self-hosted/Self-Hosted_Engine_Guide).

Select the appropriate instructions for your environment from the following table. Note that the source version refers to the Engine version. If your Engine and host versions differ (if you have previously upgraded the Engine but not the hosts), follow the instructions that match the Engine’s version.

**Supported Upgrade Paths**

<table>
 <thead>
  <tr>
   <td>Current Manager version</td>
   <td>Target Manager version</td>
   <td>Relevant section</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td>3.6</td>
   <td>4.2</td>
   <td>
   <p><b>Local database environment:</b> [Chapter 2, Upgrading from 3.6 to oVirt 4.2](../chap-Upgrading_from_3.6_to_oVirt_4.2)</p>
   <p><b>Remote database environment:</b> [Chapter 5, Upgrading a Remote Database Environment from 3.6 to oVirt 4.2](../chap-Upgrading_a_Remote_Database_Environment_from_3.6_to_oVirt_4.2)</p>
  </td>
  </tr>
  <tr>
   <td>4.0</td>
   <td>4.2</td>
   <td>
   <p><b>Local database environment:</b> [Chapter 3, Upgrading from 4.0 to oVirt 4.2](../chap-Upgrading_from_4.0_to_oVirt_4.2)</p>
   <p><b>Remote database environment:</b> [Chapter 6, Upgrading a Remote Database Environment from 4.0 to oVirt 4.2](../chap-Upgrading_a_Remote_Database_Environment_from_4.0_to_oVirt_4.2)</p>
  </td>
  </tr>
  <tr>
   <td>4.1</td>
   <td>4.2</td>
   <td>
   <p><b>Local database environment:</b> [Chapter 4, Upgrading from 4.1 to oVirt 4.2](../chap-Upgrading_from_4.1_to_oVirt_4.2)</p>
   <p><b>Remote database environment:</b> [Chapter 7, Upgrading a Remote Database Environment from 4.1 to oVirt 4.2](../chap-Upgrading_a_Remote_Database_Environment_from_4.1_to_oVirt_4.2)</p>
  </td>
  </tr>
  <tr>
   <td>4.2.x</td>
   <td>4.2.y</td>
   <td>[Chapter 9, Updates Between Minor Releases](../chap-Updates_between_Minor_Releases/)</td>
  </tr>
 </tbody>
</table>

To upgrade a oVirt Node 3.6 host that uses local storage, see the “Upgrading from 3.6 to oVirt Node While Preserving Local Storage” section in [Chapter 2, Upgrading from 3.6 to oVirt 4.2](../chap-Upgrading_from_3.6_to_oVirt_4.2)

**Next:** [Chapter 2, Upgrading from 3.6 to oVirt 4.2](../chap-Upgrading_from_3.6_to_oVirt_4.2)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/upgrade_guide/chap-updating_the_red_hat_enterprise_virtualization_environment)
