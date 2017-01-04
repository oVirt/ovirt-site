# Managing Groups

You can use the `ovirt-aaa-jdbc-tool` tool to manage group accounts on your internal domain. Managing group accounts is similar to managing user accounts. For a full list of group options, run `ovirt-aaa-jdbc-tool group --help`. Common examples are provided in this section. 

**Creating a Group**

This procedure shows you how to create a group account, add users to the group, and view the details of the group.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Create a new group:

        # ovirt-aaa-jdbc-tool group add group1

3. Add users to the group. The users must be created already.

        # ovirt-aaa-jdbc-tool group-manage useradd group1 --user=test1

    **Note:** For a full list of the group-manage options, run `ovirt-aaa-jdbc-tool group-manage --help`.

4. View group account details:

        # ovirt-aaa-jdbc-tool group show group1

5. Add the newly created group in the Administration Portal and assign the group appropriate roles and permissions. The users in the group inherit the roles and permissions of the group. See [Adding users](Adding_users) for more information.

**Creating Nested Groups**

This procedure shows you how to create groups within groups.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. Create the first group:

        # ovirt-aaa-jdbc-tool group add group1

3. Create the second group:

        # ovirt-aaa-jdbc-tool group add group1-1

4. Add the second group to the first group:

        # ovirt-aaa-jdbc-tool group-manage groupadd group1 --group=group1-1

5. Add the first group in the Administration Portal and assign the group appropriate roles and permissions. See [Adding users](Adding_users) for more information.
