---
title: Self Hosted Engine Maintenance Flows
category: feature
authors:
  - gpadgett
  - mlipchuk
  - sandrobonazzola
---

# Self Hosted Engine Maintenance Flows

## Hosted Engine Maintenance Flow Unification

### Summary

Make maintenance operations easier on hosted engine clusters and their participating nodes by providing a method to initiate HA maintenance from the engine UI.

### Owner

*   Featue Owner: Greg Padgett (gpadgett)


### Current status

*   Design and initial implementation


### Detailed Description

Today, the Hosted Engine functionality is mainly monitored and controlled on the command line. The host status (HA or not) and score is reported to the engine, but further information is lacking.

The aim of this feature is to make management of a hosted engine setup easier. We'll do this by reporting additional information about the hosted engine system to the engine, and by allowing the engine to control the hosted engine maintenance modes. Both of these goals require changes in the VDSM as well as ovirt-engine.

#### Display of Additional Information

New fields will be returned to the engine through VDSM's getVdsStats call (under a new parent member in the result, 'haStatus') and stored in the vds_statistics table:

*   ha_configured - HA is installed on the host
*   ha_active - HA is currently running/updating on the host
*   ha_global_maintenance - HA global maintenance is enabled according to the host
*   ha_local_maintenance - HA local maintenance is enabled on the host
*   ha_score - (Existing field) Host score

The engine UI will display a summary of this information in the Host > General tab for each selected host as follows:

*   Hosted Engine HA: Active (score: xxxx) <- If the agent is configured and active
*   Hosted Engine HA: Not Active <- If the agent is configured but not active
*   Hosted Engine HA: [Local/Global] Maintenance Enabled <- Maintenance enabled
*   (No entry will show up if not configured)

#### Maintenance Commands

The two types of HA maintenance will be configured in different ways.

Local maintenance, which affects only the host on which it is enabled, will be tied into the existing VDS maintenance operation. This will be initiated in the engine bll layer. Upon enabling host maintenance, if HA is configured, a command will be sent to the Hosted Engine agent through VDSM to enable local maintenance. Upon activating the host, the converse will occur and local HA maintenance will be disabled. (Note that it is possible for the host and HA states to become out of sync; this should be discoverable in the host status field and fixable via the command line or by de-/re-activating the host.)

Global maintenance affects the entire HA cluster, for which there isn't a perfect 1:1 representation in the engine. Due to this, along with the fact that global HA maintenance is enabled/disabled via commands run on the hosts, the operation in the UI is also tied to the hosts. To enable or disable global maintenance, new items will be available in each host's context (right-click) menu. These will follow a similar pattern to local maintenance, sending a command to the HA Agent through VDSM.

In each case above, the HA maintenance state will be reflected in the Host > General tab.

### Dependencies / Related Features

[Self_Hosted_Engine](/develop/release-management/features/sla/self-hosted-engine.html)

