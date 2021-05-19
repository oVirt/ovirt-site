---
title: Hosted Engine Improve Management in Host Dialogs
category: feature
authors: phbailey
---

# Hosted Engine: Improve Management in Host Dialogs

## Summary

The current user interface for managing deployment of hosted engine support on hosts provides a less than optimal user experience and limited options. For instance, the 'Hosted Engine' side tab appears in 'New Host' popups regardless of whether or not hosted engine is setup for ovirt-engine, and doesn't appear at all in 'Edit Host' popups. Additionally, both the DEPLOY and UNDEPLOY options are displayed whether they are appropriate in the given context or not.

This goal of this feature is to improve hosted engine support in host dialogs by providing a more intuitive user experience and increasing the available range of options for hosted engine deployment.

## Owner

*   Name: [Phillip Bailey](https://github.com/pcbailey)
*   Email: <phbailey@redhat.com>

## Detailed Description

The specific goals associated with this feature are as follows:

*   Display the 'Hosted Engine' side tab only if the system is configured for hosted engine

*   Change the interface element to a drop-down box

*   Display the 'Hosted Engine' side tab in the 'Edit Host' popup

*   Only display the appropriate deployment options for the given context. Note that the NONE option is displayed in all contexts.

    *   Only display the DEPLOY option in 'New Host' popups

        ![](/images/wiki/HE_Deployment_new_host.png)

    *   For 'Edit Host' popups:

        *   If the host is **not** a hosted engine node, display the DEPLOY option

            ![](/images/wiki/HE_Deployment_edit_on_non_he_node.png)

        *   If the host **is** a hosted engine node and it is **not** the last hosted engine node in the system, display the UNDEPLOY option

            ![](/images/wiki/HE_Deployment_edit_on_he_node.png)

        *   If the host **is** a hosted engine node and it **is** the last hosted engine node in the system, disable the drop-down box and provide an informative tooltip to explain why the element has been disabled

            ![](/images/wiki/HE_Deployment_edit_on_last_he_node.png)

## Benefit to oVirt

*   Provides a greatly improved user experience for managing the deployment of hosted engine to hosts.
*   Provides additional capabilities by allowing users to manage hosted engine deployment for existing hosts.

## Dependencies / Related Features

*   In order to implement this feature, ovirt-engine must be able to determine whether hosted engine is deployed and running on a given host. Hosted engine is defined as being deployed if the ovirt-hosted-engine-ha package is installed and the hosted engine configuration file is present and isn't empty. Hosted engine is considered running if the the `ovirt-ha-agent` and `ovirt-ha-broker` services are running. To enable ovirt-engine to make this determination, the following changes have been made to ovirt-hosted-engine-ha and VDSM:
    *   ovirt-hosted-engine-ha will report whether the hosted engine configuration file is present and non-empty.
    *   VDSM will report the following:
        *   Whether the ovirt-hosted-engine-ha package is installed
        *   Whether hosted engine is deployed using the information reported by ovirt-hosted-engine-ha.
        *   Whether the `ovirt-ha-agent` and `ovirt-ha-broker` services are running
        *   Bugzilla ticket for the VDSM changes: [https://bugzilla.redhat.com/show_bug.cgi?id=1392957](https://bugzilla.redhat.com/show_bug.cgi?id=1392957)

## Documentation / External references

*   Bugzilla ticket: [https://bugzilla.redhat.com/show_bug.cgi?id=1369827](https://bugzilla.redhat.com/show_bug.cgi?id=1369827)

## Testing

*   Check whether the 'Hosted Engine' tab is displayed in the 'New Host' and 'Edit Host' popups in both a hosted engine system and a regular system. Setting the 'origin' database field for a VM running on one of the hosts to '5' or '6' to simulate a hosted engine environment is sufficient if a real hosted engine setup isn't available. The 'Hosted Engine' side tab should only be displayed in the popups on the hosted engine system. All remaining steps assume you are on a hosted engine system or have simulated one as described above.

*   Check that the only options displayed in the side tab of the 'New Host' popup are 'NONE' and "DEPLOY'.

*   Check the available deployment options in the 'Edit Host' popup for (1) non-hosted engine nodes, (2) hosted engine nodes, and (3) the last hosted engine node in the system. For this step, you must have at least one host that does not have the hosted engine components installed and two hosts with them installed and running.

    1.   Check the side tab in the 'Edit Host' popup for the non-hosted engine node and ensure that the only options displayed are 'NONE' and 'DEPLOY'.

    2.   Check the side tab in the 'Edit Host' popup for one of the hosted engine nodes and ensure that the only values displayed are 'NONE' and 'UNDEPLOY'.

    3.   Remove all but one of the hosted engine nodes from the system, then check the side tab in the 'Edit Host' popup and ensure that the drop-down box can no longer be selected. Hover over the drop-down box and ensure that a tooltip is displayed explaining that the last hosted engine node in the system can't be undeployed.

## Contingency Plan

*   The current user interface will remain in use.
