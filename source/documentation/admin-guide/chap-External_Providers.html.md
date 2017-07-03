---
title: External Providers
---

# Chapter 12: External Providers

## Introduction to External Providers in oVirt

In addition to resources managed by the oVirt Engine itself, oVirt can also take advantage of resources managed by external sources. The providers of these resources, known as external providers, can provide resources such as virtualization hosts, virtual machine images, and networks.

oVirt currently supports the following external providers:

Foreman for Host Provisioning
: Foreman is a tool for managing all aspects of the life cycle of both physical and virtual hosts. In oVirt, hosts managed by Foreman can be added to and used by the oVirt Engine as virtualization hosts. After you add a Foreman instance to the Engine, the hosts managed by the Foreman instance can be added by searching for available hosts on that Foreman instance when adding a new host.

OpenStack Image Service (Glance) for Image Management
: OpenStack Image Service provides a catalog of virtual machine images. In oVirt, these images can be imported into the oVirt Engine and used as floating disks or attached to virtual machines and converted into templates. After you add an OpenStack Image Service to the Engine, it appears as a storage domain that is not attached to any data center. Virtual machine disks in a oVirt environment can also be exported to an OpenStack Image Service as virtual machine disk images.

OpenStack Networking (Neutron) for Network Provisioning
: OpenStack Networking provides software-defined networks. In oVirt, networks provided by OpenStack Networking can be imported into the oVirt Engine and used to carry all types of traffic and create complicated network topologies. After you add OpenStack Networking to the Engine, you can access the networks provided by OpenStack Networking by manually importing them.

OpenStack Volume (Cinder) for Storage Management
: OpenStack Volume provides persistent block storage management for virtual hard drives. The OpenStack Cinder volumes are provisioned by Ceph Storage. In oVirt, you can create disks on OpenStack Volume storage that can be used as floating disks or attached to virtual machines. After you add OpenStack Volume to the Engine, you can create a disk on the storage provided by OpenStack Volume.

VMware for Virtual Machine Provisioning
: Virtual machines created in VMware can be converted using V2V (`virt-v2v`) and imported into a oVirt environment. After you add a VMware provider to the Engine, you can import the virtual machines it provides. V2V conversion is performed on a designated proxy host as part of the import operation.

External Network Provider for Network Provisioning
: Supported external sofware-defined network providers include any provider that implements the OpenStack Neutron REST API. Unlike OpenStack Networking (Neutron), the Neutron agent is not used as the virtual interface driver implementation on the host. Instead, the virtual interface driver needs to be provided by the implementer of the external network provider.

All external resource providers are added using a single window that adapts to your input. You must add the resource provider before you can use the resources it provides in your oVirt environment.

## Adding External Providers

### Adding a Foreman Instance for Host Provisioning

Add a Foreman instance for host provisioning to the oVirt Engine. oVirt 4.0 is supported with Foreman 6.1.

**Adding a Foreman Instance for Host Provisioning**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add** to open the **Add Provider** window.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/7286.png)

2. Enter a **Name** and **Description**.

3. From the **Type** list, ensure that **Foreman** is selected.

4. Enter the URL or fully qualified domain name of the machine on which the Foreman instance is installed in the **Provider URL** text field. You do not need to specify a port number.

    **Important:** IP addresses cannot be used to add a Foreman instance.

5. Enter the **Username** and **Password** for the Foreman instance. You must use the same user name and password as you would use to log in to the Foreman provisioning portal.

6. Test the credentials:

    1. Click **Test** to test whether you can authenticate successfully with the Foreman instance using the provided credentials.

    2. If the Foreman instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the Foreman instance provides.

        **Important:** You must import the certificate that the Foreman instance provides to ensure the Engine can communicate with the instance.

7. Click **OK**.

You have added the Foreman instance to the oVirt Engine, and can work with the hosts it provides.

### Adding an OpenStack Image (Glance) Instance for Image Management

Add an OpenStack Image (Glance) instance for image management to the oVirt Engine.

**Adding an OpenStack Image (Glance) Instance for Image Management**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add** to open the **Add Provider** window.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/7289.png)

3. Enter a **Name** and **Description**.

4. From the **Type** list, select **OpenStack Image**.

5. Enter the URL or fully qualified domain name of the machine on which the OpenStack Image instance is installed in the **Provider URL** text field.

6. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Image instance. You must use the user name and password for the OpenStack Image user registered in Keystone, the tenant of which the OpenStack Image instance is a member, and the URL and port of the Keystone server.

7. Test the credentials:

    1. Click **Test** to test whether you can authenticate successfully with the OpenStack Image instance using the provided credentials.

    2. If the OpenStack Image instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the OpenStack Image instance provides.

        **Important:** You must import the certificate that the OpenStack Image instance provides to ensure the Engine can communicate with the instance.

8. Click **OK**.

You have added the OpenStack Image instance to the oVirt Engine, and can work with the images it provides.

### Adding an OpenStack Networking (Neutron) Instance for Network Provisioning

Add an OpenStack Networking (Neutron) instance for network provisioning to the oVirt Engine. To add other third-party network providers that implement the OpenStack Neutron REST API, see [Adding an External Network Provider](Adding_an_External_Network_Provider).

**Important:** oVirt supports Red Hat OpenStack Platform 8 as an external network provider.

**Adding an OpenStack Networking (Neutron) Instance for Network Provisioning**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add** to open the **Add Provider** window.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/externalNetworkProvider2.png)

3. Enter a **Name** and **Description**.

4. From the **Type** list, select **OpenStack Networking**.

5. Ensure that **Open vSwitch** is selected in the **Networking Plugin** field.

6. Enter the URL or fully qualified domain name of the machine on which the OpenStack Networking instance is installed in the **Provider URL** text field, followed by the port number. The **Read-Only** check box is selected by default. This prevents users from modifying the OpenStack Networking instance.

    **Important:** You must leave the **Read-Only** check box selected for your setup to be supported by Red Hat.

7. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Networking instance. You must use the user name and password for the OpenStack Networking user registered in Keystone, the tenant of which the OpenStack Networking instance is a member, and the URL and port of the Keystone server.

8. Test the credentials:

    1. Click **Test** to test whether you can authenticate successfully with the OpenStack Networking instance using the provided credentials.

    2. If the OpenStack Networking instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the OpenStack Networking instance provides to ensure the Engine can communicate with the instance.

    **Warning:** The following steps are provided only as a Technology Preview. oVirt only supports preconfigured Neutron hosts.

9. Click the **Agent Configuration** tab.

    **The Agent Configuration Tab**

    ![The Agent Configuration Tab](/images/admin-guide/6589.png)

10. Enter a comma-separated list of interface mappings for the Open vSwitch agent in the **Interface Mappings** field.

11. Select the message broker type that the OpenStack Networking instance uses from the **Broker Type** list.

12. Enter the URL or fully qualified domain name of the host on which the message broker is hosted in the **Host** field.

13. Enter the **Port** by which to connect to the message broker. This port number will be 5762 by default if the message broker is not configured to use SSL, and 5761 if it is configured to use SSL.

14. Enter the **Username** and **Password** of the OpenStack Networking user registered in the message broker instance.

15. Click **OK**.

You have added the OpenStack Networking instance to the oVirt Engine. Before you can use the networks it provides, import the networks into the Engine. See [Importing Networks](Importing_Networks).

### Adding an OpenStack Volume (Cinder) Instance for Storage Management

Add an OpenStack Volume (Cinder) instance for storage management to the oVirt Engine. The OpenStack Cinder volumes are provisioned by Ceph Storage.

**Adding an OpenStack Volume (Cinder) Instance for Storage Management**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add** to open the **Add Provider** window.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/7290.png)

3. Enter a **Name** and **Description**.

4. From the **Type** list, select **OpenStack Volume**.

5. Select the **Data Center** to which OpenStack Volume storage volumes will be attached.

6. Enter the URL or fully qualified domain name of the machine on which the OpenStack Volume instance is installed, followed by the port number, in the **Provider URL** text field.

7. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Volume instance. You must use the user name and password for the OpenStack Volume user registered in Keystone, the tenant of which the OpenStack Volume instance is a member, and the URL, port, and API version of the Keystone server.

8. Click **Test** to test whether you can authenticate successfully with the OpenStack Volume instance using the provided credentials.

9. Click **OK**.

10. If client Ceph authentication (`cephx`) is enabled, you must also complete the following steps. The `cephx` protocol is enabled by default.

    1. On your Ceph server, create a new secret key for the `client.cinder` user using the `ceph auth get-or-create` command. If a key already exists for the `client.cinder` user, retrieve it using the same command.

    2. In the Administration Portal, select the newly-created Cinder external provider from the **Providers** list.

    3. Click the **Authentication Keys** sub-tab.

    4. Click **New**.

    5. Enter the secret key in the **Value** field.

    6. Copy the automatically-generated **UUID**, or enter an existing UUID in the text field.

    7. On your Cinder server, add the UUID from the previous step and the `cinder` user to `/etc/cinder/cinder.conf`:

            rbd_secret_uuid = UUID
            rbd_user = cinder

You have added the OpenStack Volume instance to the oVirt Engine, and can work with the storage volumes it provides. See [Creating Unassociated Virtual Machine Hard Disks](Creating_Unassociated_Virtual_Machine_Hard_Disks) for more information about creating a OpenStack Volume (Cinder) disk.

### Adding a VMware Instance as a Virtual Machine Provider

Add a VMware vCenter instance to import virtual machines from VMware to the oVirt Engine.

oVirt uses V2V to convert VMware virtual machines to the correct format before they are imported. You must install the `virt-v2v` package on a least one Red Hat Enterprise Linux 7.2 or later host. This package is available in the base `rhel-7-server-rpms` repository.

**Adding a VMware vCenter Instance as a Virtual Machine Provider**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add** to open the **Add Provider** window.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/7291.png)

3. Enter a **Name** and **Description**.

4. From the **Type** list, select **VMware**.

5. Select the **Data Center** into which VMware virtual machines will be imported, or select **Any Data Center** to instead specify the destination data center during individual import operations (using the **Import** function in the **Virtual Machines** tab).

6. Enter the IP address or fully qualified domain name of the VMware vCenter instance in the **vCenter** field.

7. Enter the IP address or fully qualified domain name of the host from which the virtual machines will be imported in the **ESXi** field.

8. Enter the name of the data center in which the specified ESXi host resides in the **Data Center** field.

9. If you have exchanged the SSL certificate between the ESXi host and the Engine, leave **Verify server's SSL certificate** checked to verify the ESXi host's certificate. If not, uncheck the option.

10. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider. If you selected **Any Data Center** above, you cannot choose the host here, but instead can specify a host during individual import operations (using the **Import** function in the **Virtual Machines** tab).

11. Enter the **Username** and **Password** for the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.

12. Test the credentials:

    1. Click **Test** to test whether you can authenticate successfully with the VMware vCenter instance using the provided credentials.

    2. If the VMware vCenter instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the VMware vCenter instance provides.

        **Important:** You must import the certificate that the VMware vCenter instance provides to ensure the Engine can communicate with the instance.

13. Click **OK**.

You have added the VMware vCenter instance to the oVirt Engine, and can import the virtual machines it provides. See "Importing a Virtual Machine from a VMware Provider" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/) for more information.

### Adding an External Network Provider

Any network provider that implements the OpenStack Neutron REST API can be added to oVirt. The virtual interface driver needs to be provided by the implementer of the external network provider. A reference implementation of a network provider and a virtual interface driver are available at [https://github.com/mmirecki/ovirt-provider-mock](https://github.com/mmirecki/ovirt-provider-mock) and [https://github.com/mmirecki/ovirt-provider-mock/blob/master/docs/driver_instalation](https://github.com/mmirecki/ovirt-provider-mock/blob/master/docs/driver_instalation).

**Adding an External Network Provider for Network Provisioning**

1. Select the **External Providers** entry in the tree pane.

2. Click **Add**.

    **The Add Provider Window**

    ![The Add Provider Window](/images/admin-guide/externalNetworkProvider.png)

3. Enter a **Name** and **Description**.

4. From the **Type** list, select **External Network Provider**.

5. Enter the URL or fully qualified domain name of the machine on which the external network provider is installed in the **Provider URL** text field, followed by the port number. The **Read-Only** check box is selected by default. This prevents users from modifying the external network provider.

    **Important:** You must leave the **Read-Only** check box selected for your setup to be supported by Red Hat.

6. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the external network provider.

7. Test the credentials:

    1. Click **Test** to test whether you can authenticate successfully with the external network provider using the provided credentials.

    2. If the external network provider uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the external network provider provides to ensure the Engine can communicate with the instance.

You have added an external networking provider to the oVirt Engine. Before you can use the networks it provides, you need to install the virtual interface driver on the hosts and import the networks. To import networks, see [Importing Networks](Importing_Networks).

### Add Provider General Settings Explained

 The **General** tab in the **Add Provider** window allows you to register the core details of the external provider.

**Add Provider: General Settings**

<table>
 <thead>
  <tr>
   <td>Setting</td>
   <td>Explanation</td>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><b>Name</b></td>
   <td>A name to represent the provider in the Engine.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A plain text, human-readable description of the provider.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>
    <p>The type of external provider. Changing this setting alters the available fields for configuring the provider.</p>
    <p><b>Foreman</b></p>
    <ul>
     <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine that hosts the Foreman instance. You do not need to add the port number to the end of the URL or fully qualified domain name.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required for the provider. Authentication is mandatory when <b>Foreman</b> is selected.</li>
     <li><b>Username</b>: A user name for connecting to the Foreman instance. This user name must be the user name used to log in to the provisioning portal on the Foreman instance. By default, this user name is <tt>admin</tt>.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated. This password must be the password used to log in to the provisioning portal on the Foreman instance.</li>
    </ul>
    <p><b>OpenStack Image</b></p>
    <ul>
    <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine on which the OpenStack Image service is hosted. You must add the port number for the OpenStack Image service to the end of the URL or fully qualified domain name. By default, this port number is 9292.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required to access the OpenStack Image service.</li>
     <li><b>Username</b>: A user name for connecting to the OpenStack Image service. This user name must be the user name for the OpenStack Image service registered in the Keystone instance of which the OpenStack Image service is a member. By default, this user name is <tt>glance</tt>.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated. This password must be the password for the OpenStack Image service registered in the Keystone instance of which the OpenStack Image service is a member.</li>
     <li><b>Tenant Name</b>: The name of the OpenStack tenant of which the OpenStack Image service is a member. By default, this is <tt>services</tt>.</li>
     <li><b>Authentication URL</b>: The URL and port of the Keystone server with which the OpenStack Image service authenticates.</li>

    </ul>
    <p><b>OpenStack Networking</b></p>
    <ul>
     <li><b>Networking Plugin</b>: The networking plugin with which to connect to the OpenStack Networking server. <b>Open vSwitch</b> is the only option, and is selected by default.</li>
     <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine on which the OpenStack Networking instance is hosted. You must add the port number for the OpenStack Networking instance to the end of the URL or fully qualified domain name. By default, this port number is 9696.</li>
     <li><b>Read Only</b>: Allows you to specify whether the OpenStack Networking instance can be modified from the Administration Portal.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required to access the OpenStack Networking service.</li>
     <li><b>Username</b>: A user name for connecting to the OpenStack Networking instance. This user name must be the user name for OpenStack Networking registered in the Keystone instance of which the OpenStack Networking instance is a member. By default, this user name is <tt>neutron</tt>.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated. This password must be the password for OpenStack Networking registered in the Keystone instance of which the OpenStack Networking instance is a member.</li>
     <li><b>Tenant Name</b>: The name of the OpenStack tenant of which the OpenStack Networking instance is a member. By default, this is <tt>services</tt>.</li>
     <li><b>Authentication URL</b>: The URL and port of the Keystone server with which the OpenStack Networking instance authenticates.</li>
    </ul>
    <p><b>OpenStack Volume</b></p>
    <ul>
     <li><b>Data Center</b>: The data center to which OpenStack Volume storage volumes will be attached.</li>
     <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine on which the OpenStack Volume instance is hosted. You must add the port number for the OpenStack Volume instance to the end of the URL or fully qualified domain name. By default, this port number is 8776.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required to access the OpenStack Volume service.</li>
     <li><b>Username</b>: A user name for connecting to the OpenStack Volume instance. This user name must be the user name for OpenStack Volume registered in the Keystone instance of which the OpenStack Volume instance is a member. By default, this user name is <tt>cinder</tt>.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated. This password must be the password for OpenStack Volume registered in the Keystone instance of which the OpenStack Volume instance is a member.</li>
     <li><b>Tenant Name</b>: The name of the OpenStack tenant of which the OpenStack Volume instance is a member. By default, this is <tt>services</tt>.</li>
     <li><b>Authentication URL</b>: The URL and port of the Keystone server with which the OpenStack Volume instance authenticates.</li>
    </ul>
    <p><b>VMware</b></p>
    <ul>
     <li><b>Data Center</b>: Specify the data center into which VMware virtual machines will be imported, or select <b>Any Data Center</b> to instead specify the destination data center during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
     <li><b>vCenter</b>: The IP address or fully qualified domain name of the VMware vCenter instance.</li>
     <li><b>ESXi</b>: The IP address or fully qualified domain name of the host from which the virtual machines will be imported.</li>
     <li><b>Data Center</b>: The name of the data center in which the specified ESXi host resides.</li>
     <li><b>Cluster</b>: The name of the cluster in which the specified ESXi host resides.</li>
     <li><b>Verify server's SSL certificate</b>: Specify whether the ESXi host's certificate will be verified on connection.</li>
     <li><b>Proxy Host</b>: Select a host in the chosen data center with <tt>virt-v2v</tt> installed to serve as the host during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider. If you selected <b>Any Data Center</b>, you cannot choose the host here, but instead can specify a host during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
     <li><b>Username</b>: A user name for connecting to the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated.</li>
    </ul>
    <p><b>External Network Provider</b></p>
    <ul>
     <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine on which the external network provider is hosted. You must add the port number for the external network provider to the end of the URL or fully qualified domain name. By default, this port number is 9696.</li>
     <li><b>Read Only</b>: Allows you to specify whether the external network provider can be modified from the Administration Portal.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required to access the external network provider.</li>
     <li><b>Username</b>: A user name for connecting to the external network provider.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated.</li>
     <li><b>Authentication URL</b>: The URL and port of the authentication server with which the external network provider authenticates.</li>
    </ul>
   </td>
  </tr>
  <tr>
   <td><b>Test</b></td>
   <td>Allows users to test the specified credentials. This button is available to all provider types.</td>
  </tr>
 </tbody>
</table>

### Add Provider Agent Configuration Settings Explained

The **Agent Configuration** tab in the **Add Provider** window allows users to register details for networking plugins. This tab is only available for the **OpenStack Networking** provider type.

**Add Provider: General Settings**

| Setting | Explanation |
|-
| **Interface Mappings** | A comma-separated list of mappings in the format of `label:interface`. |
| **Broker Type** | The message broker type that the OpenStack Networking instance uses. Select **RabbitMQ** or **Qpid**. |
| **Host** | The URL or fully qualified domain name of the machine on which the message broker is installed. |
| **Port** | The remote port by which a connection with the above host is to be made. By default, this port is 5762 if SSL is not enabled on the host, and 5761 if SSL is enabled. |
| **Username** | A user name for authenticating the OpenStack Networking instance with the above message broker. By default, this user name is `neutron`. |
| **Password** | The password against which the above user name is to be authenticated. |

## Editing External Providers

**Editing an External Provider**

1. Select the **External Providers** entry in the tree pane.

2. Select the external provider to edit.

3. Click the **Edit** button to open the **Edit Provider** window.

4. Change the current values for the provider to the preferred values.

5. Click **OK**.

## Removing External Providers

**Removing an External Provider**

1. Select the **External Providers** entry in the tree pane.

2. Select the external provider to remove.

3. Click **Remove**.

4. Click **OK** in the **Remove Provider(s)** window to confirm the removal of this provider.

**Prev:** [Chapter 11: Virtual Machine Disks](../chap-Virtual_Machine_Disks)<br>
**Next:** [Chapter 13: Backups and Migration](../chap-Backups_and_Migration)
