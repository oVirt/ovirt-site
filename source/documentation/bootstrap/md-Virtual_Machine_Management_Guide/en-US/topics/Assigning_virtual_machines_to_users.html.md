# Assigning Virtual Machines to UsersN

If you are creating virtual machines for users other than yourself, you have to assign roles to the users before they can use the virtual machines. Note that permissions can only be assigned to existing users. See [Users and Roles](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/paged/administration-guide/chapter-14-users-and-roles) in the *Red Hat Virtualization Administration Guide* for details on creating user accounts.

The User Portal supports three default roles: User, PowerUser and UserVmManager. However, customized roles can be configured via the Administration Portal. The default roles are described below.

* A **User** can connect to and use virtual machines. This role is suitable for desktop end users performing day-to-day tasks.

* A **PowerUser** can create virtual machines and view virtual resources. This role is suitable if you are an administrator or manager who needs to provide virtual resources for your employees.

* A **UserVmManager** can edit and remove virtual machines, assign user permissions, use snapshots and use templates. It is suitable if you need to make configuration changes to your virtual environment.

When you create a virtual machine, you automatically inherit **UserVmManager** privileges. This enables you to make changes to the virtual machine and assign permissions to the users you manage, or users who are in your Identity Management (IdM) or RHDS group. See [*Administration Guide*](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/administration-guide/#Introduction_to_Directory_Servers) for more information.

**Assigning Permissions to Users**

1. Click the **Virtual Machines** tab and select a virtual machine.

2. Click the **Permissions** tab on the details pane.

3. Click **Add**.

4. Enter a name, or user name, or part thereof in the **Search** text box, and click **Go**. A list of possible matches display in the results list.

5. Select the check box of the user to be assigned the permissions.

6. Select **UserRole** from the **Role to Assign** drop-down list.

7. Click **OK**.

The user's name and role display in the list of users permitted to access this virtual machine.

**Note:** If a user is assigned permissions to only one virtual machine, single sign-on (SSO) can be configured for the virtual machine. With single sign-on enabled, when a user logs in to the User Portal, and then connects to a virtual machine through, for example, a SPICE console, users are automatically logged in to the virtual machine and do not need to type in the user name and password again. Single sign-on can be enabled or disabled on a per virtual machine basis. See [Configuring Single Sign-On for Virtual Machines](sect-Configuring_Single_Sign-On_for_Virtual_Machines) for more information on how to enable and disable single sign-on for virtual machines.
