# Disabling the Internal Administrative User

You can disable users on the local domains including the `admin@internal` user created during `engine-setup`. Make sure you have at least one user in the envrionment with full administrative permissions before disabling the default `admin` user.

**Disabling the Internal Administrative User**

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Make sure another user with the `SuperUser` role has been added to the environment. See [Adding users](Adding_users) for more information.

3. Disable the default `admin` user:

        # ovirt-aaa-jdbc-tool user edit admin --flag=+disabled

    **Note:** To enable a disabled user, run `ovirt-aaa-jdbc-tool user edit `username` --flag=-disabled`
