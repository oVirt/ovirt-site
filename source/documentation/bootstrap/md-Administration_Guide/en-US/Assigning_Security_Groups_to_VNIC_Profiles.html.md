# Assigning Security Groups to vNIC Profiles

**Note:** This feature is only available for users who are integrating with OpenStack Neutron. Security groups cannot be created with Red Hat Virtualization Manager. You must create security groups within OpenStack. For more information, see [https://access.redhat.com/documentation/en/red-hat-openstack-platform/9/single/users-and-identity-management-guide#project-security](https://access.redhat.com/documentation/en/red-hat-openstack-platform/9/single/users-and-identity-management-guide#project-security) in the *Red Hat OpenStack Platform Users and Identity Management Guide*.

You can assign security groups to the vNIC profile of networks that have been imported from an OpenStack Networking instance and that use the Open vSwitch plug-in. A security group is a collection of strictly enforced rules that allow you to filter inbound and outbound traffic over a network interface. The following procedure outlines how to attach a security group to a vNIC profile.

**Note:** A security group is identified using the ID of that security group as registered in the OpenStack Networking instance. You can find the IDs of security groups for a given tenant by running the following command on the system on which OpenStack Networking is installed: 

    # neutron security-group-list

**Assigning Security Groups to vNIC Profiles**

1. Click the **Networks** tab and select a logical network from the results list.

2. Click the **vNIC Profiles** tab in the details pane.

3. Click **New**, or select an existing vNIC profile and click **Edit**, to open the **VM Interface Profile** window.

4. From the custom properties drop-down list, select **SecurityGroups**. Leaving the custom property drop-down blank applies the default security settings, which permit all outbound traffic and intercommunication but deny all inbound traffic from outside of the default security group. Note that removing the **SecurityGroups** property later will not affect the applied security group.

5. In the text field, enter the ID of the security group to attach to the vNIC profile.

6. Click **OK**.

You have attached a security group to the vNIC profile. All traffic through the logical network to which that profile is attached will be filtered in accordance with the rules defined for that security group.
