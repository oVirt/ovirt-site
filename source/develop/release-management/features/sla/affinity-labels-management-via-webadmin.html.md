---
title: Affinity Labels Management via Webadmin
category: feature
authors: phbailey
wiki_category: SLA
feature_name: Affinity Labels Management via Webadmin
feature_modules: Webadmin
feature_status: Complete
---

# Affinity Labels Management via Webadmin

## Summary

Provide affinity label management within the webadmin UI.

## Owner

*   Owner: Phillip Bailey
*   Email: phbailey@redhat.com

## Detailed Description

[Affinity labels](/documentation/sla/affinity-labels) were introduced in version 4.0, but could only be managed via the REST API. This feature allows users to manage their labels without ever leaving the webadmin UI.

### Affinity Label Sub Tabs

A sub tab has been added to the clusters, virtual machines, and hosts main tabs. The sub tabs for virtual machines and hosts display the labels that have been assigned to the currently selected entity. For the moment, the clusters sub tab displays all labels in the system. In the future, it is intended to restrict labels at the cluster level. At that time, the clusters sub tab will only display labels associated with the selected cluster.

![](/images/wiki/affinity-labels-vm-subtab-with-label.png)  
<br />

#### Label Creation/Modification

Affinity labels can be created and modified from the sub tabs. To create a new affinity label, click the "New" button. This will open the "New Affinity Label" popup. Enter a name for the label, select the desired VMs and hosts from the drop downs, then click "OK". Note: If you open the dialog from the sub tabs located in the VM or host main tabs, the currently selected entity will automatically be selected for you.

To edit a label, select one from the list and click "Edit". This will open the "Edit Affinity Label" popup, which is the same as the "New Affinity Label" popup, only pre-populated with the selected label's data.

![](/images/wiki/affinity-labels-new-label-popup.png)  
<br />

#### Label Deletion

In order to delete a label, all of its VMs and hosts must first be removed. This can be accomplished by editing the label from any of the sub tabs and clicking the minus signs next to each VM and host entry. Once this is accomplished, the label can be deleted by selecting it from the sub tab in the clusters main tab, clicking "Delete", and then clicking "OK" on the confirmation popup.

![](/images/wiki/affinity-labels-cluster-subtab-with-labels.png)  
<br />

### Adding/Removing Existing Labels

Existing affinity labels can be added to VMs and hosts from the "Affinity Labels" side tab of their respective new/edit popups. To select a label, either click the drop down arrow and select one from the list or click inside the text box area of the drop down and enter text to filter the list. Once you have selected a label, click the "Add" button to add it to the list of selected labels.

To remove a label, simply click the "x" next to the label name in the label list.

![](/images/wiki/affinity-labels-edit-vm-with-label.png)  
<br />

## References
RFE in Bugzilla: [BZ 1338799](https://bugzilla.redhat.com/show_bug.cgi?id=1338799)
