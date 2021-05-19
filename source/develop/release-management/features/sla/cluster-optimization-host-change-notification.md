---
title: Cluster Optimization Host Change Notification
category: feature
authors: phbailey
---

# Cluster Optimization Host Change Notification

## Summary

Provide a notification in webadmin of steps required for host-level changes made in the Optimization side tab of the new/edit Cluster popup to take effect.

## Owner

*   Owner: Phillip Bailey
*   Email: phbailey@redhat.com

## Detailed Description

Host-level changes made in the Optimization side tab of the new/edit Cluster popup do not take effect until the host is activated for the first time, enters and exits maintenance mode, or MOM policy is manually synchronized. This requirement is currently not communicated to the user in any form, which could cause confusion when the expected changes don't take effect immediately. This feature separates the options in the side tab that are affected by this requirement from those that are not and adds a notification explaining the available options to make the changes take effect.

### Webadmin

A horizontal rule will be used to separate the host-level options in the side tab from the other options located there. An information-style notification will be displayed below the horizontal rule and above the options the notification text addresses as shown below.

![](/images/wiki/Cluster-optimization-host-changes-notification.png)

## References
- RFE in Bugzilla: [BZ 1231859](https://bugzilla.redhat.com/show_bug.cgi?id=1231859)
- Patch creating the notification with icon widget: [Gerrit change 81055](https://gerrit.ovirt.org/#/c/81055/)
- Patch adding the notification to the Optimization side tab: [Gerrit change 81056](https://gerrit.ovirt.org/#/c/81056/)
