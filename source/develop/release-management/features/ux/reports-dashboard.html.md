---
title: Reports Dashboard
category: feature
authors: alkaplan
---

# Reports Dashboard

## Adding a reports dashboard tab

### Summary

Add a dashboard tab for relevant entities in the system to show overview of the entity (based on information from jasper reports)..

### Owner

*   Name: alkaplan (MyUser)

<!-- -->

*   Email: <alkaplan@redhat.com>

### Current status

      Target Release: 3.1

*   Status: ...
*   Last updated date: May 13 2012

### Detailed Description

The following feature adds a dashboard tab for relevant entities (tree items) in the system to show overview of the entity (based on information from jasper reports).
 **The tree items that have dashboard**- System, Data Center, Cluster.
**How to see the dashboard**- Selecting the relevant tree item=>Choosing the dashboard tab (next to the events tab)
**pre-requirements**-
1. Reports.xml- This file includes-
a. The data whether the Jasper server is in ce (client edition) mode or not.
b. The tree items that have dashboard. (The dashboard tab will be visible just for those items).
c. Data for show reports feature- see related links.
The Reports file resides in the engine in the webadmin directory ($JBOSS_HOME/standalone/deployments/engine.ear/webadmin.war/webadmin/Reports.xml)
2. RedirectServletReportsPage- Update the "RedirectServletReportsPage" entry in vdc_options table with jasper sever base url (including protocol-http/https and port, for example <http://10.35.97.118:8080/jasperserver-pro/>)
 If one of the previous two pre-requirements is missing the dashboard tab will be unvisible for all the tree items
 3. Configuring the jasper server to support sso as explained here- <http://gerrit.ovirt.org/#change,3355>

#### Print Shots

![](/images/wiki/Dashboard.png)

### Dependencies / Related Features

[Features/Design/jasper in webadmin](/develop/release-management/features/ux/jasper-in-webadmin/)

