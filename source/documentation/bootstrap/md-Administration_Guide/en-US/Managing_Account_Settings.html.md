# Managing Account Settings

To change the default account settings, use the `ovirt-aaa-jdbc-tool` `settings` module.

**Updating Account Settings**

This procedure shows you how to update the default account settings.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Run the following command to show all the settings available:

        # ovirt-aaa-jdbc-tool setting show

3. Change the desired settings: 

    * This example updates the default log in session time to 60 minutes for all user accounts. The default value is 10080 minutes.

            # ovirt-aaa-jdbc-tool setting set --name=MAX_LOGIN_MINUTES --value=60

    * This example updates the number of failed login attempts a user can perform before the user account is locked. The default value is 5.

            # ovirt-aaa-jdbc-tool setting set --name=MAX_FAILURES_SINCE_SUCCESS --value=3

        **Note:** To unlock a locked user account, run `ovirt-aaa-jdbc-tool user unlock test1`.
