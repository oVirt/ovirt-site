---
title: jasper in webadmin
category: feature
authors: alkaplan
---

# jasper in webadmin

## Integrate Jasper Reports into the webadmin

### Summary

Provide context menu/drop down menu allowing to open reports for relevant entities in the system.

### Owner

*   Name: alkaplan (MyUser)

<!-- -->

*   Email: <alkaplan@redhat.com>

### Current status

      Target Release: 3.1

*   Status: ...
*   Last updated date: May 13 2012

### Detailed Description

The following feature will provide a context menu/drop down menu allowing to open reports for relevant entities in the system.
 **The entities that have reports**- dcs, clusters, hosts, storage, vms.
**How to open a report**- Select the relevant entity in the main tab=>
 1. Right click=> Show reports
 OR
 2. Click on Show Report in the action bar
 => choose the report you want.
 Jasper system ui will be opened in a new tab/window (depends on the browser) and the selected report will be shown (no need to enter user and password).
**pre-requirements**-
1. Reports.xml- This file includes-
a. The data about te entities reports. The show reports menu of each entity is constructed according to this file.
b. Extra details for reports dashboards- see related features
The Reports file resides in the engine in the webadmin directory ($JBOSS_HOME/standalone/deployments/engine.ear/webadmin.war/webadmin/Reports.xml)
2. RedirectServletReportsPage- Update the "RedirectServletReportsPage" entry in vdc_options table with jasper sever base url (including protocol-http/https and port, for example <http://10.35.97.118:8080/jasperserver-pro/>)
 If one of the previous two pre-requirements is missing the show report menu will be invisible for all the entities.
 3. Configuring the jasper server to support sso as explained here- <http://gerrit.ovirt.org/#change,3355>

#### Print Shots

![](/images/wiki/ShowReportsMenu.png) ![](/images/wiki/ShowReportsRightClick.png)

### Dependencies / Related Features

<http://www.ovirt.org/w/index.php?title=Features/Design/Reports_Dashboard>

