# Managing Users

You can use the `ovirt-aaa-jdbc-tool` tool to manage user accounts on the internal domain. Changes made using the tool take effect immediately and do not require you to restart the `ovirt-engine` service. For a full list of user options, run `ovirt-aaa-jdbc-tool user --help`. Common examples are provided in this section.

**Creating a User**

This procedure shows you how to create a user, set the user password, and add it to your Red Hat Virtualization environment.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Create a new user account. Optionally use `--attribute` to specify account details. For a full list of options, run `ovirt-aaa-jdbc-tool user add --help`.

        # ovirt-aaa-jdbc-tool user add test1 --attribute=firstName=John --attribute=lastName=Doe 
        adding user test1...
        user added successfully

3. Set a password. You must set a value for `--password-valid-to`, otherwise the password expiry time defaults to the current time. The date format is `yyyy-MM-dd HH:mm:ssX`. In this example, `-0800` stands for GMT minus 8 hours. For more options, run `ovirt-aaa-jdbc-tool user password-reset --help`.

        # ovirt-aaa-jdbc-tool user password-reset test1 --password-valid-to="2025-08-01 12:00:00-0800"
        Password:
        updating user test1...
        user updated successfully

    **Note:** By default, the password policy for user accounts on the internal domain has the following restrictions:

    * A minimum of 6 characters.

    * Three previous passwords used cannot be set again during the password change.

    For more information on the password policy and other default settings, run `ovirt-aaa-jdbc-tool settings show`.

4. Add the newly created user in the Administration Portal and assign the user appropriate roles and permissions. See [Adding users](Adding_users) for more information.

**Viewing User Information**

This procedure shows you how to view user account information. More information is displayed than in the Administration Portal, **Users** tab.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Run the following command:

        # ovirt-aaa-jdbc-tool user show test1

**Editing User Information**

This procedure shows you how to update user account information.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Run the following command to edit user information. This example updates the email address.

        # ovirt-aaa-jdbc-tool user edit test1 --attribute=email=jdoe@example.com

**Removing a User**

This procedure shows you how to delete a user account

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Delete the user:

        # ovirt-aaa-jdbc-tool user delete test1

3. Remove the user from the Administration Portal. See [Removing Users](Removing_Users1) for more information.
