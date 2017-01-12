# Add Provider General Settings Explained

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
   <td>A name to represent the provider in the Manager.</td>
  </tr>
  <tr>
   <td><b>Description</b></td>
   <td>A plain text, human-readable description of the provider.</td>
  </tr>
  <tr>
   <td><b>Type</b></td>
   <td>
    <p>The type of external provider. Changing this setting alters the available fields for configuring the provider.</p>
    <p><b>Foreman/Satellite</b></p>
    <ul>
     <li><b>Provider URL</b>: The URL or fully qualified domain name of the machine that hosts the Satellite instance. You do not need to add the port number to the end of the URL or fully qualified domain name.</li>
     <li><b>Requires Authentication</b>: Allows you to specify whether authentication is required for the provider. Authentication is mandatory when <b>Foreman/Satellite</b> is selected.</li>
     <li><b>Username</b>: A user name for connecting to the Satellite instance. This user name must be the user name used to log in to the provisioning portal on the Satellite instance. By default, this user name is <tt>admin</tt>.</li>
     <li><b>Password</b>: The password against which the above user name is to be authenticated. This password must be the password used to log in to the provisioning portal on the Satellite instance.</li>
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
