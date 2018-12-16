---
title: External Providers
---

# Chapter 11: External Providers

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
: Virtual machines created in VMware can be converted using V2V (`virt-v2v`) and imported into an oVirt environment. After you add a VMware provider to the Engine, you can import the virtual machines it provides. V2V conversion is performed on a designated proxy host as part of the import operation.

Xen for Virtual Machine Provisioning
: Virtual machines created in Xen can be converted using V2V (`virt-v2v`) and imported into an oVirt environment. After you add a Xen host to the Engine, you can import the virtual machines it provides. V2V conversion is performed on a designated proxy host as part of the import operation.

KVM for Virtual Machine Provisioning
: Virtual machines created in KVM can be imported into an oVirt environment. After you add a KVM host to the Engine, you can import the virtual machines it provides.

Open Virtual Network (OVN) for Network Provisioning
: Open Virtual Network (OVN) is an Open vSwitch (OVS) extension that provides software-defined networks. After you add OVN to the Manager, you can import existing OVN networks, and create new OVN networks from the Engine. You can also automatically install OVN on the Engine using `engine-setup`.

External Network Provider for Network Provisioning
: Supported external sofware-defined network providers include any provider that implements the OpenStack Neutron REST API. Unlike OpenStack Networking (Neutron), the Neutron agent is not used as the virtual interface driver implementation on the host. Instead, the virtual interface driver needs to be provided by the implementer of the external network provider.

All external resource providers are added using a single window that adapts to your input. You must add the resource provider before you can use the resources it provides in your oVirt environment.

## Adding External Providers

### Adding a Foreman Instance for Host Provisioning

Add a Foreman instance for host provisioning to the oVirt Engine. oVirt 4.2 is supported with Foreman 6.1.

**Adding a Foreman Instance for Host Provisioning**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **Foreman/Satellite** from the **Type** drop-down list.

5. Enter the URL or fully qualified domain name of the machine on which the Foreman instance is installed in the **Provider URL** text field. You do not need to specify a port number.

    **Important:** IP addresses cannot be used to add a Foreman instance.

6. Select the **Requires Authentication** check box.

7. Enter the **Username** and **Password** for the Foreman instance. You must use the same user name and password as you would use to log in to the Foreman provisioning portal.

8. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with the Foreman instance using the provided credentials.

    ii. If the Foreman instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the Foreman instance provides.

9. Click **OK**.

You have added the Foreman instance to the oVirt Engine, and can work with the hosts it provides.

### Adding an OpenStack Image (Glance) Instance for Image Management

Add an OpenStack Image (Glance) instance for image management to the oVirt Engine.

**Adding an OpenStack Image (Glance) Instance for Image Management**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **OpenStack Image** from the **Type** drop-down list.

5. Enter the URL or fully qualified domain name of the machine on which the OpenStack Image instance is installed in the **Provider URL** text field.

6. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Image instance. You must use the user name and password for the OpenStack Image user registered in Keystone, the tenant of which the OpenStack Image instance is a member, and the URL and port of the Keystone server.

7. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with the OpenStack Image instance using the provided credentials.

    ii. If the OpenStack Image instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the OpenStack Image instance provides.

        **Important:** You must import the certificate that the OpenStack Image instance provides to ensure the Engine can communicate with the instance.

8. Click **OK**.

You have added the OpenStack Image instance to the oVirt Engine, and can work with the images it provides.

### Adding an OpenStack Networking (Neutron) Instance for Network Provisioning

Add an OpenStack Networking (Neutron) instance for network provisioning to the oVirt Engine. To add other third-party network providers that implement the OpenStack Neutron REST API, see [Adding an External Network Provider](Adding_an_External_Network_Provider).

    **Important:** oVirt supports RDO versions 8, 9, 10, 11, and 12 as external network providers.

To use neutron networks, hosts must have the neutron agents configured. You can configure the agents manually, or use the RDO director to deploy the Networker role, before adding the network node to the Engine as a host. Using the director is recommended. Automatic deployment of the neutron agents through the **Network Provider** tab in the **New Host** window is not supported.

Although network nodes and regular hosts can be used in the same cluster, virtual machines using neutron networks can only run on network nodes.

**Adding a Network Node as a Host**

1. Use the RDO director to deploy the Networker role on the network node.

2. Enable the oVirt repositories.

3. Install the Openstack Networking hook:

        # yum install vdsm-hook-openstacknet

4. Add the network node to the Engine as a host.

    **Important:** Do not select the OpenStack Networking provider from the **Network Provider** tab. This is currently not supported.

5. Remove the firewall rule that rejects ICMP traffic:

        # iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited

**Adding an OpenStack Networking (Neutron) Instance for Network Provisioning**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **OpenStack Networking** from the **Type** drop-down list.

5. Ensure that **Open vSwitch** is selected in the **Networking Plugin** field.

6. Enter the URL or fully qualified domain name of the machine on which the OpenStack Networking instance is installed in the **Provider URL** text field, followed by the port number. The **Read-Only** check box is selected by default. This prevents users from modifying the OpenStack Networking instance.

    **Important:** You must leave the **Read-Only** check box selected for your setup to be supported by Red Hat.

7. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Networking instance. You must use the user name and password for the OpenStack Networking user registered in Keystone, the tenant of which the OpenStack Networking instance is a member, and the URL and port of the Keystone server.

8. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with the OpenStack Networking instance using the provided credentials.

    ii. If the OpenStack Networking instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the OpenStack Networking instance provides to ensure the Engine can communicate with the instance.

9. Click the **Agent Configuration** tab.

10. Enter a comma-separated list of interface mappings for the Open vSwitch agent in the **Interface Mappings** field.

11. Select the message broker type that the OpenStack Networking instance uses from the **Broker Type** list.

12. Enter the URL or fully qualified domain name of the host on which the message broker is hosted in the **Host** field.

13. Enter the **Port** by which to connect to the message broker. This port number will be 5762 by default if the message broker is not configured to use SSL, and 5761 if it is configured to use SSL.

14. Enter the **Username** and **Password** of the OpenStack Networking user registered in the message broker instance.

15. Click **OK**.

You have added the OpenStack Networking instance to the oVirt Engine. Before you can use the networks it provides, import the networks into the Engine. See [Importing Networks](Importing_Networks).

### Adding an OpenStack Volume (Cinder) Instance for Storage Management

Add an OpenStack Volume (Cinder) instance for storage management to the oVirt Engine. The OpenStack Cinder volumes are provisioned by Ceph Storage.

**Adding an OpenStack Block Storage (Cinder) Instance for Storage Management**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **OpenStack Block Storage** from the **Type** drop-down list.

5. Select the **Data Center** to which OpenStack Volume Block Storage volumes will be attached.

6. Enter the URL or fully qualified domain name of the machine on which the OpenStack Block Storage instance is installed, followed by the port number, in the **Provider URL** text field.

7. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OpenStack Block Storage instance. You must use the user name and password for the OpenStack Block Storage user registered in Keystone, the tenant of which the OpenStack Block Storage instance is a member, and the URL, port, and API version of the Keystone server.

8. Click **Test** to test whether you can authenticate successfully with the OpenStack Block Storage instance using the provided credentials.

9. Click **OK**.

10. If client Ceph authentication (`cephx`) is enabled, you must also complete the following steps. The `cephx` protocol is enabled by default.

    i. On your Ceph server, create a new secret key for the `client.cinder` user using the `ceph auth get-or-create` command. If a key already exists for the `client.cinder` user, retrieve it using the same command.

    ii. In the Administration Portal, select the newly-created Cinder external provider from the **Providers** list.

    iii. Click the **Authentication Keys** tab.

    iv. Click **New**.

    v. Enter the secret key in the **Value** field.

    vi. Copy the automatically-generated **UUID**, or enter an existing UUID in the text field.

    vii. On your Cinder server, add the UUID from the previous step and the `cinder` user to `/etc/cinder/cinder.conf`:

            rbd_secret_uuid = UUID
            rbd_user = cinder

See [Creating Unassociated Virtual Machine Hard Disks](Creating_Unassociated_Virtual_Machine_Hard_Disks) for more information about creating a OpenStack Volume (Cinder) disk.

### Adding a VMware Instance as a Virtual Machine Provider

Add a VMware vCenter instance to import virtual machines from VMware to the oVirt Engine.

oVirt uses V2V to convert VMware virtual machines to the correct format before they are imported. The `virt-v2v` package must be installed on at least one host. The `virt-v2v` package is available by default on oVirt Nodes and is installed on Enterprise Linux hosts as a dependency of VDSM when added to the oVirt environment. Enterprise Linux hosts must be Enterprise Linux 7.2 or later.

    **Note:** The `virt-v2v` package is not available on ppc64le architecture; these hosts cannot be used as proxy hosts.

**Adding a VMware vCenter Instance as a Virtual Machine Provider**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **VMware** from the **Type** drop-down list.

5. Select the **Data Center** into which VMware virtual machines will be imported, or select **Any Data Center** to instead specify the destination data center during individual import operations.

6. Enter the IP address or fully qualified domain name of the VMware vCenter instance in the **vCenter** field.

7. Enter the IP address or fully qualified domain name of the host from which the virtual machines will be imported in the **ESXi** field.

8. Enter the name of the data center in which the specified ESXi host resides in the **Data Center** field.

9. If you have exchanged the SSL certificate between the ESXi host and the Engine, leave **Verify server's SSL certificate** checked to verify the ESXi host's certificate. If not, clear the check box.

10. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the VMware vCenter external provider. If you selected **Any Data Center** above, you cannot choose the host here, but instead can specify a host during individual import operations.

11. Enter the **Username** and **Password** for the VMware vCenter instance. The user must have access to the VMware data center and ESXi host on which the virtual machines reside.

12. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with the VMware vCenter instance using the provided credentials.

    ii. If the VMware vCenter instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the VMware vCenter instance provides.

        **Important:** You must import the certificate that the VMware vCenter instance provides to ensure the Engine can communicate with the instance.

13. Click **OK**.

To import virtual machines from the VMware external provider, see "Importing a Virtual Machine from a VMware Provider" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

### 11.2.6. Adding a Xen Host as a Virtual Machine Provider

Add a Xen host to import virtual machines from Xen to Red Hat Virtualization Manager.

oVirt uses V2V to convert Xen virtual machines to the correct format before they are imported. The `virt-v2v` package must be installed on at least one host. The `virt-v2v` package is available by default on oVirt Nodes and is installed on Enterprise Linux hosts as a dependency of VDSM when added to the oVirt environment. Enterprise Linux hosts must be Red Hat Enterprise Linux 7.2 or later.

    **Note:** The `virt-v2v` package is not available on ppc64le architecture; these hosts cannot be used as proxy hosts.

**Adding a Xen Instance as a Virtual Machine Provider**

1. Enable public key authentication between the proxy host and the Xen host:

    i. Log in to the proxy host and generate SSH keys for the **vdsm** user.

            # sudo -u vdsm ssh-keygen

    ii. Copy the **vdsm** user’s public key to the Xen host. The proxy host’s **known_hosts** file will also be updated to include the host key of the Xen host.

            # sudo -u vdsm ssh-copy-id root@xenhost.example.com

   iii. Log in to the Xen host to verify that the login works correctly.

            # sudo -u vdsm ssh root@xenhost.example.com

2. Click **Administration** &rarr; **Providers**.

3. Click **Add**.

4. Enter a **Name** and **Description**.

5. Select **XEN** from the **Type** drop-down list.

6. Select the **Data Center** into which Xen virtual machines will be imported, or select **Any Data Center** to specify the destination data center during individual import operations.

7. Enter the URI of the Xen host in the **URI** field.

8. Select a host in the chosen data center with `virt-v2v` installed to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the Xen external provider. If you selected **Any Data Center** above, you cannot choose the host here, but instead can specify a host during individual import operations.

9. Click **Test** to test whether you can authenticate successfully with the Xen host.

10. Click **OK**.

To import virtual machines from a Xen external provider, see "Importing a Virtual Machine from a Xen Host" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

### Adding a KVM Host as a Virtual Machine Provider

Add a KVM host to import virtual machines from KVM to oVirt Engine.

**Adding a KVM Host as a Virtual Machine Provider**

1. Enable public key authentication between the proxy host and the Xen host:

    i. Log in to the proxy host and generate SSH keys for the **vdsm** user.

            # sudo -u vdsm ssh-keygen

    ii. Copy the **vdsm** user’s public key to the KVM host. The proxy host’s **known_hosts** file will also be updated to include the host key of the KVM host.

            # sudo -u vdsm ssh-copy-id root@kvmhost.example.com

   iii. Log in to the KVM host to verify that the login works correctly.

            # sudo -u vdsm ssh root@kvmhost.example.com

2. Click **Administration** &rarr; **Providers**.

3. Click **Add**.

4. Enter a **Name** and **Description**.

5. Select **KVM** from the **Type** drop-down list.

6. Select the **Data Center** into which KVM virtual machines will be imported, or select **Any Data Center** to specify the destination data center during individual import operations.

7. Enter the URI of the KVM host in the **URI** field.

8. Select a host in the chosen data center to serve as the **Proxy Host** during virtual machine import operations. This host must also be able to connect to the network of the KVM external provider. If you selected **Any Data Center** in the Data Center field above, you cannot choose the host here. The field is greyed out and shows **Any Host in Data Center**. Instead you can specify a host during individual import operations.

9. Optionally, select the **Requires Authentication** check box and enter the **Username** and **Password** for the KVM host. The user must have access to the KVM host on which the virtual machines reside.

10. Click **Test** to test whether you can authenticate successfully with the KVM host using the provided credentials.

11. Click **OK**.

To import virtual machines from a KVM external provider, see "Importing a Virtual Machine from a KVM Host" in the [Virtual Machine Management Guide](/documentation/vmm-guide/Virtual_Machine_Management_Guide/).

### Adding Open Virtual Network (OVN) as an External Network Provider

Open Virtual Network (OVN) enables you to create networks without adding VLANs or changing the infrastructure. OVN is an Open vSwitch (OVS) extension that enables support for virtual networks by adding native OVS support for virtual L2 and L3 overlays.

You can either install a new OVN network provider or add an existing one.

You can also connect an OVN network to a native Red Hat Virtualization network. See the “Connecting an OVN Network to a Physical Network” section for more information.

A Neutron-like REST API is exposed by ovirt-provider-ovn, enabling you to create networks, subnets, ports, and routers. These overlay networks enable communication among the virtual machines.

    **Note:** OVN is supported as an external provider by ManageIQ, using the OpenStack (Neutron) API.

For more information on OVS and OVN, see the OVS documentation at http://docs.openvswitch.org/en/latest/ and http://openvswitch.org/support/dist-docs/.

#### Installing a New OVN Network Provider

    **Warning:** If the openvswitch package is already installed and if the version is 1:2.6.1 (version 2.6.1, epoch 1), the OVN installation will fail when it tries to install the latest openvswitch package. See the Doc Text in BZ#1505398 for the details and a workaround.

When you install OVN using engine-setup, the following steps are automated:

* Setting up an OVN central server on the Manager machine.

* Adding OVN to oVirt as an external network provider.

* Setting the **Default** cluster’s default network provider to `ovirt-provider-ovn`.

* Configuring hosts to communicate with OVN when added to the cluster.

If you use a preconfigured answer file with `engine-setup`, you can add the following entry to install OVN:

    OVESETUP_OVN/ovirtProviderOvn=bool:True
I
**Installing a New OVN Network Provider**

1. Install OVN on the Engine using `engine-setup`. During the installation, engine-setup asks the following questions:

        # Install ovirt-provider-ovn(Yes, No) [Yes]?:

  * If `Yes`, `engine-setup` installs `ovirt-provider-ovn`. If `engine-setup` is updating a system, this prompt only appears if `ovirt-provider-ovn` has not been installed previously.

  * If `No`, you will not be asked again on the next run of `engine-setup`. If you want to see this option, run `engine-setup --reconfigure-optional-components`.

          # Use default credentials (admin@internal) for ovirt-provider-ovn(Yes, No) [Yes]?:

    If `Yes`, `engine-setup` uses the default engine user and password specified earlier in the setup process. This option is only available during new installations.

          # oVirt OVN provider user[admin]:
          # oVirt OVN provider password[empty]:

    You can use the default values or specify the oVirt OVN provider user and password.

        **Note:** To change the authentication method later, you can edit the `/etc/ovirt-provider-ovn/conf.d/10_engine_setup.conf` file, or create a new `/etc/ovirt-provider-ovn/conf.d/20_engine_setup.conf` file. Restart the` ovirt-provider-ovn` service for the change to take effect. See https://github.com/oVirt/ovirt-provider-ovn/blob/master/README.adoc for more information about OVN authentication.

2. Add hosts to the **Default** cluster. Hosts added to this cluster are automatically configured to communicate with OVN. To add new hosts, “Adding a Host to the Red Hat Virtualization Manager” in Chapter 7.

   To configure your hosts to use an existing, non-default network, see the “Configuring Hosts for an OVN Tunnel Network” section.

3. Add networks to the **Default** cluster; see Section 6.1.2, “Creating a New Logical Network in a Data Center or Cluster” and select the **Create on external provider** check box. `ovirt-provider-ovn` is selected by default.

   To connect the OVN network to a native oVirt network, select the **Connect to physical network** check box and specify the Red Hat Virtualization network to use. See the “Connecting an OVN Network to a Physical Network” section for more information and prerequisites.

You can now create virtual machines that use OVN networks.

#### Adding an Existing OVN Network Provider

Adding an existing OVN central server as an external network provider in Red Hat Virtualization involves the following key steps:

* Install the OVN provider, a proxy used by the Manager to interact with OVN. The OVN provider can be installed on any machine, but must be able to communicate with the OVN central server and the Manager.

* Add the OVN provider to Red Hat Virtualization as an external network provider.

* Create a new cluster that uses OVN as its default network provider. Hosts added to this cluster are automatically configured to communicate with OVN.

**Prerequisites**

The following packages are required by the OVN provider and must be available on the provider machine:

* openvswitch-ovn-central

* openvswitch

* openvswitch-ovn-common

* python-openvswitch

If these packages are not available from the repositories already enabled on the provider machine, they can be downloaded from the OVS website: http://openvswitch.org/download/.

**Adding an Existing OVN Network Provider**

1. Install and configure the OVN provider.

    i. Install the provider on the provider machine:

        # yum install ovirt-provider-ovn

    ii. If you are not installing the provider on the same machine as the Engine, add the following entry to the `/etc/ovirt-provider-ovn/conf.d/10_engine_setup.conf` file (create this file if it does not already exist):

        [OVIRT]
        ovirt-host=https://Manager_host_name

       This is used for authentication, if authentication is enabled.

   iii. If you are not installing the provider on the same machine as the OVN central server, add the following entry to the `/etc/ovirt-provider-ovn/conf.d/10_engine_setup.conf` file (create this file if it does not already exist):

        [OVN REMOTE]
        ovn-remote=tcp:OVN_central_server_IP:6641

    iv. Open ports 9696, 6641, and 6642 in the firewall to allow communication between the OVN provider, the OVN central server, and the Manager. This can be done either manually or by adding the ovirt-provider-ovn and ovirt-provider-ovn-central services to the appropriate zone:

        # firewall-cmd --zone=ZoneName --add-service=ovirt-provider-ovn --permanent
        # firewall-cmd --zone=ZoneName --add-service=ovirt-provider-ovn-central --permanent
        # firewall-cmd --reload

    v. Start and enable the service:

        # systemctl start ovirt-provider-ovn
        # systemctl enable ovirt-provider-ovn

    vi. Configure the OVN central server to listen to requests from ports 6642 and 6641:

        # ovn-sbctl set-connection ptcp:6642
        # ovn-nbctl set-connection ptcp:6641

2. Click **Administration** &rarr; **Providers**.

3. Click **Add**.

4. Enter a **Name** and **Description**.

5. Select **External Network Provider** from the **Type** drop-down list.

6. Click the **Networking Plugin** text box and select **oVirt Network Provider for OVN** from the drop-down menu.

7. Enter the URL or fully qualified domain name of the OVN provider in the **Provider URL** text field, followed by the port number. If the OVN provider and the OVN central server are on separate machines, this is the URL of the provider machine, not the central server. If the OVN provider is on the same machine as the Manager, the URL can remain the default http://localhost:9696.

8. Clear the **Read-Only** check box to allow creating new OVN networks from the oVrt Engine.

9. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the OVN instance.

   The authentication method must be configured in the `/etc/ovirt-provider-ovn/conf.d/10_engine_setup.conf` file (create this file if it does not already exist). Restart the `ovirt-provider-ovn` service for the change to take effect. See https://github.com/oVirt/ovirt-provider-ovn/blob/master/README.adoc for more information about OVN authentication.

10. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with OVN using the provided credentials.

    ii. If the OVN instance uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the OVN instance provides to ensure the Engine can communicate with the instance.

11. Click **OK**.

12. Create a new cluster that uses OVN as its default network provider. See “Creating a New Cluster” in [Chapter 5: Clusters](chap-Clusters) and select the OVN network provider from the **Default Network Provider** drop-down list.

13. Add hosts to the cluster. Hosts added to this cluster are automatically configured to communicate with OVN. To add new hosts, see “Adding a Host to the oVirt Engine” in [Chapter 7: Hosts](chap-Hosts).

14. Import or add OVN networks to the new cluster. To import networks, see Section 6.3.1, “Importing Networks From External Providers”. To create new networks using OVN, see “Creating a New Logical Network in a Data Center or Cluster” in [Chapter 6: Logical Networks](chap-Logical_Networks)], and select the **Create on external provider** check box. `ovirt-provider-ovn` is selected by default.

   To configure your hosts to use an existing, non-default network, see the “Configuring Hosts for an OVN Tunnel Network” section.

   To connect the OVN network to a native oVirt network, select the **Connect to physical network** check box and specify the oVirt network to use. See the “Connecting an OVN Network to a Physical Network” section for more information and prerequisites.

You can now create virtual machines that use OVN networks.

#### Configuring Hosts for an OVN Tunnel Network

You can configure your hosts to use an existing network, other than the default `ovirtmgmt` network, with the `ovirt-provider-ovn-driver` Ansible playbook. The network must be accessible to all the hosts in the cluster.

    **Note:** The `ovirt-provider-ovn-driver` Ansible playbook updates existing hosts. If you add new hosts to the cluster, you must run the playbook again.

**Configuring Hosts for an OVN Tunnel Network**

1. On the Engine machine, go to the **playbooks** directory:

        # cd /usr/share/ovirt-engine/playbooks

2. Run the `ansible-playbook` command with the following parameters:

        # ansible-playbook --private-key=/etc/pki/ovirt-engine/keys/engine_id_rsa -i /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory --extra-vars " cluster_name=_Cluster_Name_ ovn_central=_OVN_Central_IP_ ovn_tunneling_interface=_VDSM_Network_Name_" ovirt-provider-ovn-driver.yml

   **Updating Hosts with `ansible-playbook`**

        # ansible-playbook --private-key=/etc/pki/ovirt-engine/keys/engine_id_rsa -i /usr/share/ovirt-engine-metrics/bin/ovirt-engine-hosts-ansible-inventory --extra-vars " cluster_name=MyCluster ovn_central=192.168.0.1 ovn_tunneling_interface=MyNetwork" ovirt-provider-ovn-driver.yml

  **Note:** The `OVN_Central_IP` can be on the new network, but this is not a requirement. The `OVN_Central_IP` must be accessible to all hosts.

  The `VDSM_Network_Name` is limited to 15 characters.

**Updating the OVN Tunnel Network on a Single Host**

You can update the OVN tunnel network on a single host with `vdsm-tool`:

    # vdsm-tool ovn-config OVN_Central_IP Tunneling_IP_or_Network_Name

**Updating a Host with vdsm-tool**

    # vdsm-tool ovn-config 192.168.0.1 MyNetwork

#### Connecting an OVN Network to a Physical Network

You can create an external provider network that overlays a native oVirt network so that the virtual machines on each appear to be sharing the same subnet.

**Important:** If you created a subnet for the OVN network, a virtual machine using that network will receive an IP address from there. If you want the physical network to allocate the IP address, do not create a subnet for the OVN network.

**Prerequisites**

* The cluster must have OVS selected as the **Switch Type**. Hosts added to this cluster must not have any pre-existing oVirt networks configured, such as the **ovirtmgmt** bridge.

* The physical network must be available on the hosts. You can enforce this by setting the physical network as required for the cluster (in the **Manage Networks** window, or the **Cluster** tab of the **New Logical Network** window).

**Creating a New External Network Connected to a Physical Network**

1. Click **Compute** &rarr; **Clusters**.

2. Click the cluster’s name to open the details view.

3. Click the **Logical Networks** tab and click **Add Network**.

4. Enter a **Name** for the network.

5. Select the **Create on external provider** check box. `ovirt-provider-ovn` is selected by default.

6. Select the **Connect to physical network** check box if it is not already selected by default.

7. Choose the physical network to connect the new network to:

    * Click the **Data Center Network** radio button and select the physical network from the drop-down list. This is the recommended option.

    * Click the **Custom** radio button and enter the name of the physical network. If the physical network has VLAN tagging enabled, you must also select the **Enable VLAN tagging** check box and enter the physical network’s VLAN tag.

        **Important:** The physical network’s name must not be longer than 15 characters, or contain special characters.

8. Click **OK**.

### Adding an External Network Provider

Any network provider that implements the OpenStack Neutron REST API can be added to oVirt. The virtual interface driver needs to be provided by the implementer of the external network provider. A reference implementation of a network provider and a virtual interface driver are available at [https://github.com/mmirecki/ovirt-provider-mock](https://github.com/mmirecki/ovirt-provider-mock) and [https://github.com/mmirecki/ovirt-provider-mock/blob/master/docs/driver_instalation](https://github.com/mmirecki/ovirt-provider-mock/blob/master/docs/driver_instalation).

**Adding an External Network Provider for Network Provisioning**

1. Click **Administration** &rarr; **Providers**.

2. Click **Add**.

3. Enter a **Name** and **Description**.

4. Select **External Network Provider** from the **Type** drop-down list.

5. Optionally click the **Networking Plugin** text box and select the appropriate driver from the drop-down menu.

6. Enter the URL or fully qualified domain name of the machine on which the external network provider is installed in the **Provider URL** text field, followed by the port number. The **Read-Only** check box is selected by default. This prevents users from modifying the external network provider.

7. Optionally, select the **Requires Authentication** check box and enter the **Username**, **Password**, **Tenant Name**, and **Authentication URL** for the external network provider.

8. Optionally, select the **Automatic Synchronization** check box. This enables automatic synchronization of the external network provider with existing networks. This feature is disabled by default when adding external network providers.

9. Test the credentials:

    i. Click **Test** to test whether you can authenticate successfully with the external network provider using the provided credentials.

    ii. If the external network provider uses SSL, the **Import provider certificates** window opens; click **OK** to import the certificate that the external network provider provides to ensure the Engine can communicate with the instance.

10. Click **OK**.

Before you can use the networks it provides, you need to install the virtual interface driver on the hosts and import the networks. To import networks, see [Importing Networks](Importing_Networks).

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
    <p><b>Foreman/Satellite</b></p>
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
    <p><b>Xen</b></p>
    <ul>
     <li><b>Data Center</b>: Specify the data center into which Xen virtual machines will be imported, or select <b>Any Data Center</b> to instead specify the destination data center during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
     <li><b>URI</b>: The URI of the Xen host.</li>
     <li><b>Proxy Host</b>: Select a host in the chosen data center with <tt>virt-v2v</tt> installed to serve as the host during virtual machine import operations. This host must also be able to connect to the network of the Xen external provider. If you selected <b>Any Data Center</b>, you cannot choose the host here, but instead can specify a host during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
    </ul>
    <p><b>KVM</b></p>
    <ul>
     <li><b>Data Center</b>: Specify the data center into which KVM virtual machines will be imported, or select <b>Any Data Center</b> to instead specify the destination data center during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
     <li><b>URI</b>: The URI of the KVM host.</li>
     <li><b>Proxy Host</b>: Select a host in the chosen data center with <tt>virt-v2v</tt> installed to serve as the host during virtual machine import operations. This host must also be able to connect to the network of the KVM external provider. If you selected <b>Any Data Center</b>, you cannot choose the host here, but instead can specify a host during individual import operations (using the <b>Import</b> function in the <b>Virtual Machines</b> tab).</li>
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

## Editing an External Provider

**Editing an External Provider**

1. Click **Administration** &rarr; **Providers**.

2. Click **Edit**.

3. Change the current values for the provider to the preferred values.

4. Click **OK**.

## Removing External Providers

**Removing an External Provider**

1. Click **Administration** &rarr; **Providers**.

2. Click **Remove**.

3. Click **OK**.

**Prev:** [Chapter 10: Virtual Disks](chap-Virtual_Machine_Disks)<br>
**Next:** [Chapter 12: Backups and Migration](chap-Backups_and_Migration)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-external_providers)
