---
title: Gluster Import Existing Cluster
category: feature
authors:
  - kmayilsa
  - sahina
---

# Gluster Import Existing Cluster

## Summary

This allows the user to import an existing gluster supported cluster to engine. All the hosts part of the cluster will be imported.

## Owner

*   Feature owner: Shireesh Anjal
    -   GUI Component owner: Kanagaraj Mayilsamy
    -   REST Component owner: Shireesh Anjal
    -   Engine Component owner: Dhandapani Gopal <dgopal@redhat.com>
    -   QA Owner: Sudhir Dharanendraiah <sdharane@redhat.com>

## Current Status

*   Status: Complete
*   Last updated date: Fri Sep 25 2012

## Detailed Description

This feature provides the support for importing a storage cluster (gluster enabled) to oVirt engine. The hosts in the cluster will not have vdsm installed. The user needs to provide the details of any host in the cluster which includes IP/Host name of the host and password. "gluster peer status" command will be executed on that host through ssh, the result of the command will provide the list of hosts part of the cluster. Once everything is successful, the list of hosts will be shown to the user. The user verifies(manually) the fingerprint of each and every host and provides passwords for them, the AddHost flow continues from here onwards.

## Design

### Fetching Gluster Hosts

![](/images/wiki/Gluster-Import-Cluster-1.png)

The **Import existing cluster configuration** section will be shown only if the user select **Enable Gluster Service**. When the user types the host **Address** and tab out or click outside, the fingerprint will be fetched and shown to the user. If the engine is not able to fetch the fingerprint either because of host is down or network issue, an error **Error in fetching fingerprint** will be shown in the fingerprint field. If the fingerprint is correct(to make sure we are communicating with the actual host not with some one else), the user will enter the password for the host and click **Ok**. The "gluster peer status" command will be executed through ssh in the remote host. This command will fail if the gluster is not running on the host or password is incorrect. The appropriate error message will be shown in the same place. The user will not be allowed to import even if one of the hosts in the cluster is down or not reachable. If everything is successful, the user will be shown the **Add Hosts** dialog which lists the hosts part of the cluster.

### Importing Gluster Hosts

![](/images/wiki/Gluster-Import-Cluster-2.png)

The list of hosts which are part of the cluster will be shown. The **Name** column for each host will have the same values as the **Hostname/IP** column, the user can change the name of the host. The user needs to enter the **Password** for all the hosts shown in the table. If the passwords for all the hosts are same, the user can select **Use a common password**, enter the **Root Password** and click on **Apply**. The same password will be assigned for all the hosts. The user needs to verify the **Fingerprint** of all the hosts before submitting the details. If the passwords provided for the hosts are correct, the hosts will be added to the engine and available under the **Hosts** tab. The normal **Add Host** flow of bootstrapping, restart,etc continues from here onwards. As the newly imported hosts will not have **vdsm** installed, the bootstrap script will install all the necessary vdsm packages on the hosts.

## User Work flow

1.  Click on **New** in Cluster Main Tab, the Create Cluster dialog opens
2.  Select **Enable Gluster Service** and **Import existing gluster configuration** checkboxes.
3.  Enter the IP Address/Host name of any server in the cluster
4.  Wait for the **Fingerprint** to load, and make sure we are communicating with the correct host
5.  Provide the **Root Password** for the server, and Click **Ok**
6.  *gluster peer status* command will be executed on that server
7.  **Add Hosts** dialog will be shown with the list of hosts in the cluster
8.  Edit the **Name** of the hosts if required and provide **Root Passwords**. Same password can be provided for the all the hosts by selecting **Use a common password**. Click on **Apply** to set the entered password all hosts. The user can provide a different password for one host by editing the **Root Password** field of the respective host.
9.  Make sure the fingerprints are valid and submit the details by clicking **Ok**

None of the hosts will be imported even if the password for a host is wrong or one of the host is not reachable.

