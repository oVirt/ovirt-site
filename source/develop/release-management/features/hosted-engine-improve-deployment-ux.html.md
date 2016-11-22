---
title: Improve Hosted Engine Deployment User Experience
category: feature
authors: phbailey
wiki_category: Feature|Improve Hosted Engine Deployment User Experience
wiki_title: Features/Improve Hosted Engine Deployment User Experience
wiki_revision_count: 0
wiki_last_updated: 2016-11-21
feature_name: Improve Hosted Engine Deployment User Experience
feature_status: In Development
---

# Improve Hosted Engine Deployment User Experience

## Summary

The current user interface for managing deployment of hosted engine support on hosts provides a less than optimal user experience. For instance, the 'Hosted Engine' side tab appears in 'New Host' popups regardless of whether or not hosted engine is setup for ovirt-engine and doesn't appear at all in 'Edit Host' popups. Additionally, both the DEPLOY and UNDEPLOY options are displayed, in addition to the default value of NONE, whether they are appropriate in the given context or not.

This goal of this feature is to improve the current interface to provide a much more intuitive user experience.

## Owner

*   Name: [Phillip Bailey](https://github.com/pcbailey)
*   Email: <phbailey@redhat.com>

## Detailed Description

*   Display the 'Hosted Engine' side tab only if the system is configured for hosted engine

*   Change the interface element to a drop-down box

*   Display the 'Hosted Engine' side tab in the 'Edit Host' popup

*   Only display the appropriate deployment options for the given context (in addition to the NONE option)

    *   Only display the DEPLOY option in 'New Host' popups

        ![](HE_Deployment_new_host.png "HE_Deployment_new_host.png")

    *   For 'Edit Host' popups:

        *   If the host is not a hosted engine node, display the DEPLOY option

            ![](HE_Deployment_edit_on_non_he_node.png "HE_Deployment_edit_on_non_he_node.png")

        *   If the host is a hosted engine node and:

            *   It is NOT the last hosted engine node in the system, display the UNDEPLOY option

                ![](HE_Deployment_edit_on_he_node.png "HE_Deployment_edit_on_he_node.png")

            *   It IS the last hosted engine node in the system, disable the drop-down box and provide an informative tooltip to explain why the element has been disabled

                ![](HE_Deployment_edit_on_last_he_node.png "HE_Deployment_edit_on_last_he_node.png")

## Benefit to oVirt

*   Provides a greatly improved user experience for managing the deployment of hosted engine to hosts.
*   Provides additional capabilities by allowing users to manage hosted engine deployment for existing hosts.

## Dependencies / Related Features

*   VDSM will report the status of hosted engine components when reporting VDS capabilities.
    *   VDSM will report `not_detected`, `installed`, or `running` for the key `hostedEngineComponents`.
    *   Hosted engine components consist of a configuration file located at `/etc/ovirt-hosted-engine/hosted-engine.conf` and the `ovirt-ha-agent` and `ovirt-ha-broker` services.
    *   The components are considered `installed` if all three components are installed and are considered `running` if all three components are installed and both services are running.    
    *   Bugzilla ticket: [https://bugzilla.redhat.com/show_bug.cgi?id=1392957](https://bugzilla.redhat.com/show_bug.cgi?id=1392957)

## Documentation / External references

*   Bugzilla ticket: [https://bugzilla.redhat.com/show_bug.cgi?id=1369827](https://bugzilla.redhat.com/show_bug.cgi?id=1369827)

## Testing

*   Check whether the 'Hosted Engine' tab is displayed in the 'New Host' and 'Edit Host' popups in both a hosted engine system and a regular system. You can set the 'origin' field for one of the hosts to '5' or '6' in the database to check behavior for the hosted engine setup. The side tab should only be displayed in the popups on the hosted engine setup. All remaining steps assume you are on a hosted engine setup or have simulated one as suggested above.

*   Check that the only options displayed in the side tab of the 'New Host' popup are 'NONE' and "DEPLOY'.

*   Check the options available in the side tab of the 'Edit Host' popup for non-hosted engine nodes, hosted engine nodes, and the last hosted engine node in the system. For this step, you must have at least one host that does not have the hosted engine components installed and two hosts with them installed and running.

    *   Check the side tab in the 'Edit Host' popup for the non-hosted engine node and ensure that the only options displayed are 'NONE' and 'DEPLOY'.

    *   Check the side tab in the 'Edit Host' popup for one of the hosted engine nodes and ensure that the only values displayed are 'NONE' and 'UNDEPLOY'.

    *   Remove all but one of the hosted engine nodes from the system, the check the side tab in the 'Edit Host' popup and ensure that the drop-down box can no longer be selected. Hover over the drop-down box and ensure that a tooltip is displayed explaining that the last hosted engine node in the system can't be undeployed.

## Contingency Plan

*   The current user interface will remain in use.
