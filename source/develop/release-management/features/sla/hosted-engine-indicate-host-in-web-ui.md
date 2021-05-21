---
title: Hosted Engine indicate hosted engine host in Web UI
category: feature
authors: phbailey
---

# Hosted Engine: Indicate Host Running the Hosted Engine VM

### Summary

Provide a visual indicator on the host running the hosted engine virtual machine in the hosts main tab of the administration portal user interface.

### Owner

*   Name: Phillip Bailey
*   Email: phillip@redhat.com

### Detailed Description

*   The VDS business entity model must be updated to reflect whether it is hosting the hosted engine VM
*   The ovirt-engine web UI must be changed to display the indicator on the hosted engine host

### Benefit to oVirt

*   A clear visual indicator will improve the user experience by adding to the amount of pertinent information available in the administration interface

### Testing

*   Deploy hosted engine on a setup with at least 2 hosts
*   Determine the host on which the hosted engine VM is running
*   Confirm in the web UI that the indicator is displayed on the correct host
