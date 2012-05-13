---
title: jasper in webadmin
category: feature
authors: alkaplan
wiki_category: Feature
wiki_title: Features/Design/jasper in webadmin
wiki_revision_count: 17
wiki_last_updated: 2012-05-14
---

# jasper in webadmin

## Integrate Jasper Reports into the webadmin

### Summary

Provide context menu/drop down menu allowing to open reports for relevant entities in the system.

### Owner

*   Name: [ My User](User:MyUser)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: <alkaplan@redhat.com>

### Current status

      Target Release: 3.1

*   Status: ...
*   Last updated date: May 13 2012

### Detailed Description

The following feature will provide a context menu/drop down menu allowing to open reports for relevant entities in the system.
**The entites that have reports**- dcs, clusters, hosts, storage, vms.
**How to open a report**- Selecting the relevant entity in the main tab=>
 1. Right clicks=> Show reports
 OR
 2. Clicking on show report in the action bar
 => choosing the report you want.
 Jasper system ui will be opened in a new tab/window (depends on the browser) and the selected report will be shown (no need to enter user and password).
**pre-requirements**- 1. Reports.xml- This file includes-
 a. The data about te enteties reports. The show reports menu of each entity is constructed according to this file.
 b. The data whether the Jasper server is in ce (clien edition) mode or not.
The Reports file resides in the engine in the webadmin directory ($JBOSS_HOME/standalone/deployments/engine.ear/webadmin.war/webadmin/Reports.xml)
2. RedirectServletReportsPage- Update the "RedirectServletReportsPage" entry in vdc_options table with jasper sever base url (including protocol-http/https and port, for example <http://10.35.97.118:8080/jasperserver-pro/>)
 If one of these tow pre-requirements is missing the show report menu will be unvisible for all the entites.
 3. Configuring the jasper server as explain here- <http://gerrit.ovirt.org/#change,3355>

<Category:Feature>
