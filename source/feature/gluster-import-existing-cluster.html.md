---
title: Gluster Import Existing Cluster
category: feature
authors: kmayilsa, sahina
wiki_category: Feature
wiki_title: Features/Gluster Import Existing Cluster
wiki_revision_count: 19
wiki_last_updated: 2014-01-15
---

# Gluster Import Existing Cluster

## Summary

This allows the user to import an existing gluster supported cluster to engine. All the hosts part of the cluster will be imported.

## Owner

*   Feature owner: Shireesh Anjal <sanjal@redhat.com>
    -   GUI Component owner: Kanagaraj Mayilsamy <kmayilsa@redhat.com>
    -   REST Component owner: Shireesh Anjal
    -   Engine Component owner: Dhandapani Gopal <dgopal@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Complete
*   Last updated date: Fri Sep 25 2012

## Detailed Description

This feature provides the support for importing a storage cluster (gluster enabled) to oVirt engine. The hosts in the cluster will not have vdsm installed. The user needs to provide the details of any host in the cluster which includes IP/Host name of the host and password. "gluster peer status" command will be executed on that host through ssh, the result of the command will provide the list of hosts part of the cluster. Once everything is successful, the list of hosts will be shown to the user. The user verifies the fingerprint of the each host and provides the passwords for them, the AddHost flow continues from here.

## Design

### Fetching Gluster Hosts

![](Gluster-Import-Cluster-1.png "Gluster-Import-Cluster-1.png")

### Importing Gluster Hosts

![](Gluster-Import-Cluster-2.png "Gluster-Import-Cluster-2.png")

## User Work flow

1.  Click on **New** in Clsuter Main Tab, the Create Cluster dialog opens
2.  Select **Enable Gluster Service** and **Import existing gluster configuration** checkboxes.
3.  Enter the IP Address/Host name of any server in the cluster
4.  Wait for the **Fingerprint** to load, and make sure we are communicating with the correct host
5.  Provide the **Root Password** for the server, and Click **Ok**
6.  *gluster peer status* command will be executed on that server
7.  **Add Hosts** dialog will be shown with the list of hosts in the cluster
8.  Edit the **Name** of the hosts if required and provide **Root Passwords**. Same password can be provided for the all the hosts by selecting **Use a common password**
9.  Make sure the fingerprints are valid and submit the details by clicking **Ok**

None of the hosts will be imported even if the password for one host is wrong or one of the host is not reachable.

<Category:Feature>
