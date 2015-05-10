---
title: KatelloIntegration
category: feature
authors: gshereme, moti
wiki_category: Feature
wiki_title: Home/Features/KatelloIntegration
wiki_revision_count: 18
wiki_last_updated: 2015-05-10
feature_name: Katello Integration
feature_modules: engine
feature_status: Development
wiki_warnings: list-item?
---

# Katello Integration

### Summary

[Katello](http://www.katello.org/) is content and life-cycle host manager.
oVirt can leverage Katello capabilities to report errata information for the hosts or for the ovirt-engine server.
[Integration with Foreman](Features/ForemanIntegration) was introduced in 3.5. Integrating with Katello (which is based on Foreman) extends it to support also the content management of the physical or virtual host.

### Owner

*   Name: [ Moti Asayag](User:Moti Asayag)
*   Email: <masayag@redhat.com>

### Detailed Description

The Katello integration support presenting available errata to the user, for both hosts or for the ovirt-engine server.
See the following figure for the topology:

![](OVirt-Katello_integration.jpg "OVirt-Katello_integration.jpg")

Errata information is not stored on the engine server, rather being queried from the Katello server each time it is requested by the administrator.
**Erratum** includes the following details:

*   Id
*   Title
*   Description
*   Type
*   Issued date
*   Severity
*   Solution
*   Summary
*   Packages

#### Workflow

Any host should be registered to Katello and properly configured:

*   katello-agent installed
*   Subscribed to the relevant content view/environment/repositories within the Katello server.

The hosts are being identified at the Katello engine by their **host name**. Hence hosts added by their IP address to the system wouldn't be able to report errata - since there is no measure to identify them within the Katello system. The motivation for reporting errata for hosts with **host name** (FQDN) in the system is to dismiss the need to maintain the external content host id on the ovirt-engine side as well.

##### Katello errata for hosts

*   Associate a host with the 'Foreman' external provider
    -   By provisioning a host via 'Foreman' external provider
    -   By updating the host via 'Edit', see:

![](EditHost.png "EditHost.png")

*   UI: Go to "Hosts" ---> "General" sub-tab ---> "Errata":

![](System_host_errata.jpg "System_host_errata.jpg")

*   UI: Go to "Hosts" ---> "General" sub-tab ---> "Errata" --> Specific severity:

![](System_host_detailed_errata.jpg "System_host_detailed_errata.jpg")

    * In case no errata is available, the following message will be shown: "0 pending errata"

    * In case the host is not associated with Katello, the 'Errata' section won't be shown within the 'General' sub-tab at all.

    * In case of a problem with the Katello server, error alerts will be shown on the tabs:

![](System_host_errata_wth_errors.jpg "System_host_errata_wth_errors.jpg")

![](EngineErrata_with_error.png "EngineErrata_with_error.png")

*   API:
    -   /api/hosts/{host:id}/katelloerrata
    -   /api/hosts/{host:id}/katelloerrata/{katelloerratum:id}/

##### Katello errata for vms

*   Associate a vm with the 'Foreman' external provider
    -   By updating the VM via 'Edit' action.
    -   By provisioning a VM via 'Foreman' external provider (not supported in 3.6).

<!-- -->

*   UI: Go to "VMs" ---> "General" sub-tab ---> "Errata":

**Required Mockup**

*   UI: Go to "VMs" ---> "General" sub-tab ---> "Errata" --> Specific severity:

**Required Mockup**

    * In case no errata is available, the following message will be shown: "0 pending errata"

    * In case the host is not associated with Katello, the 'Errata' section won't be shown within the 'General' sub-tab at all.

    * In case of a problem with the Katello server, error alerts will be shown on the tabs:

![](System_host_errata_wth_errors.jpg "System_host_errata_wth_errors.jpg")

![](EngineErrata_with_error.png "EngineErrata_with_error.png")

*   API:
    -   /api/vms/{vm:id}/katelloerrata
    -   /api/vms/{vm:id}/katelloerrata/{katelloerratum:id}/

##### Katello errata for ovirt-engine server

Since the expectation is to have very few 'Foreman' providers (or a single one), instead of managing registration of the ovirt-engine server to a specific provider, the system will iterate over the providers and will try to match a content host within Katello by the ovirt-engine host name.

*   UI:

The errata for the ovirt-engine server will be added to the 'System' tree: ![](EngineErrata.png "fig:EngineErrata.png")

    * In case no errata is available, the following message will be shown: "0 pending errata"

    * In case the ovirt-engine server is not associated with Katello, the 'Errata' node won't be shown on the system left-pane tree.

*   API:
    -   /api/katelloerrata
    -   /api/katelloerrata/{katelloerratum:id}/

### Benefit to oVirt

oVirt will allow the administrator for view from a single system the availability for errata, categorized by their severity, for the ovirt-engine itself or for its managed hosts.
The Host administrator could be updated about available errata and their importance from the same dashboard which he uses to manage the host configuration.

### Dependencies / Related Features

*   [Integration with Foreman](Features/ForemanIntegration) has introduced the Foreman external provider which is also used to register Katello server to the system.

### Documentation / External references

### Testing

### Release Notes

#### Katello Integration

oVirt extends 'Foreman' Integration to support also host lifecycle and content management by integrating with Katello. oVirt adds support to report Katello errata information for the hosts in the system and for ovirt-engine server.

### Comments and Discussion

<Category:Feature> <Category:Template>
