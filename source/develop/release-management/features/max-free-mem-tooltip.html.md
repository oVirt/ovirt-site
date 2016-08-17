---
title: Explanatory Tooltip for "Max Free Memory for scheduling new VMs" Field
category: feature
authors: phbailey
wiki_category: Feature|Explanatory Tooltip for "Max Free Memory for scheduling new VMs" Field
wiki_title: Features/Explanatory Tooltip for "Max Free Memory for scheduling new VMs" Field
wiki_revision_count: 0
wiki_last_updated: 2016-04-19
feature_name: 'Explanatory Tooltip for "Max Free Memory for scheduling new VMs" Field'
feature_modules: webadmin
feature_status: NEW
---

# Explanatory Tooltip for "Max Free Memory for scheduling new VMs" Field

### Summary

Provide an explanation of the calculation used to determine the "Max Free Memory for scheduling new VMs" value displayed in the "General" sub tab of the "Hosts" main tab.

### Owner

*   Name: Phillip Bailey
*   Email: phillip@redhat.com

### Detailed Description

*   This feature adds a tooltip to the label of the "Max Free Memory for scheduling new VMs" field found in the "General" sub tab of the "Hosts" main tab. The tooltip displays the formula used to calculate the value, as well as a description for each of the values used in the calculation.

![tooltip](/images/wiki/max-free-mem-tooltip.png)

### Benefit to oVirt

*   Convenient access to the calculation details for this field will reduce confusion by increasing user understanding of the value's meaning and usefulness.

### Testing

*   Deploy hosted engine on a setup with at least 1 host
*   Navigate to the "General" sub tab of the "Hosts" main tab
*   Hover the mouse pointer over the "Max Free Memory for scheduling new VMs" label and confirm that the tooltip appears
