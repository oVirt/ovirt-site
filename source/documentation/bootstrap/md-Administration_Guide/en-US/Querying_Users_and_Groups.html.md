# Querying Users and Groups

The `query` module allows you to query user and group information. For a full list of options, run `ovirt-aaa-jdbc-tool query --help`.

**Listing All User or Group Account Details**

This procedure shows you how to list all account information.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. 

    * List all user account details:

            # ovirt-aaa-jdbc-tool query --what=user

    * List all group account details:

            # ovirt-aaa-jdbc-tool query --what=group

**Listing Filtered Account Details**

This procedure shows you how to apply filters when listing account information.

1. Log in to the machine on which the Red Hat Virtualization Manager is installed.

2. 
    * List user account details with names that start with the character j.

            # ovirt-aaa-jdbc-tool query --what=user --pattern="name=j*"

    * List groups that have the department attribute set to marketing:

            # ovirt-aaa-jdbc-tool query --what=group --pattern="department=marketing"

