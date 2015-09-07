---
title: AAA JDBC
category: feature
authors: alonbl, moolit, mperina, rmohr
wiki_category: Feature
wiki_title: Features/AAA JDBC
wiki_revision_count: 35
wiki_last_updated: 2015-10-20
feature_name: AAA_JDBC
feature_modules: engine, extension
feature_status: In progress
---

# AAA JDBC

## Summary

AAA-JDBC is an extension which allows to store authentication and authorization data in relational database and provides these data using standardized oVirt AAA API similarly to already existing AAA-LDAP extension.

## Owner

*   Martin Peřina <mperina@redhat.com>
*   Alon Bar Lev <alonbl@redhat.com>
*   Mooli Tayer <mtayer@redhat.com>

## Detailed Description

*   Provides complete users/groups/passwords management
*   Stores users/groups/passwords in PostgreSQL database
*   Provides management command line tool ovirt-aaa-jdbc-tool
*   Provides thous users/groups/passwords data in oVirt using standard AAA Extension API
*   Updated users/groups/passwords are immediately visible in oVirt withtout the need to restart engine service
*   Allows to provided multiple domains stored in local or remote database
*   By default in oVirt 3.6 **internal** domain is provided using AAA-JDBC extension

## User management

### Creating a user

    ovirt-aaa-jdbc-tool user add jdoe \
        --attribute=firstName=John \
        --attribute=lastName=Doe \
        --attribute=email=jdoe@unknown.com

Only username is mandatory, other attributes are optional. Following attributes can be specified for user:

*   department
*   description
*   displayName
*   email
*   firstName
*   lastName
*   title

**ATTENTION:** Newly created users are unable to login until [ password-reset](#Password_management) command is executed on them.

### Showing details about existing user

    ovirt-aaa-jdbc-tool user show jdoe

Here are details of specified user:

    -- User jdoe(fc5b1c8b-d668-4a2c-98c8-a176c093a242) --
    namespace: *
    name: jdoe
    id: fc5b1c8b-d668-4a2c-98c8-a176c093a242
    display name: 
    email: jdoe@unknown.com
    first name: John
    last name: Doe
    department: 
    title: 
    description:

### Updating existing user

Following command updates display name:

    ovirt-aaa-jdbc-tool user edit jdoe \
        --attribute="displayName=John Doe"

### Removing existing user

    ovirt-aaa-jdbc-tool user delete jdoe

### Unlocking locked user

User can be locked for example if there are too many unsuccessful logins. Following command unlocks user:

    ovirt-aaa-jdbc-tool user unlock jdoe

## Password management

Following command sets new password for user jdoe interactively:

    ovirt-aaa-jdbc-tool user password-reset jdoe

Following types of entering password are supported using **--password** option:

*   **interactive** - tool prompts to enter password
*   **pass:STRING** - password is specified on command line
*   **env:KEY** - password is specified in **ENV** environment variable
*   **<file:FILE>** - password is read from specified file
*   **none:** - sets empty password

**ATTENTION**: By default password expires at the same moment as it's specified. Following command sets new password and password expiration date to August 15th 2025 10:30:00 UTC:

    ovirt-aaa-jdbc-tool user password-reset jdoe --password-valid-to="2025-08-15 10:30:00Z"

## Group management

### Creating a group

    ovirt-aaa-jdbc-tool group add group1 \
        --attribute="description=First group"

Only groupname is mandatory, other attributes are optional. Following attributes can be specified for group:

*   description
*   displayName

### Showing details about existing group

    ovirt-aaa-jdbc-tool group show group1

Here are details of specified group:

    -- Group group1(061a2ec0-9204-43a1-affe-ba717004c0f5) --
    namespace: *
    name: group1
    id: 061a2ec0-9204-43a1-affe-ba717004c0f5
    display name: 
    description: First group

### Updating existing group

Following command updates display name:

    ovirt-aaa-jdbc-tool group edit group1 \
        --attribute="displayName=Group 1"

### Removing existing group

    ovirt-aaa-jdbc-tool group delete group1

## Group membership management

### Adding user to group

Following command add user **jdoe** into group **group1**:

    ovirt-aaa-jdbc-tool group-manage useradd group1 --user=jdoe

### Showing members of group

    ovirt-aaa-jdbc-tool group-manage show group1

### Removing user from group

Following command removes user **jdoe** from group **group1**:

    ovirt-aaa-jdbc-tool group-manage userdel group1 --user=jdoe

### Adding group to group

Following command add group **group2** into group **group1**:

    ovirt-aaa-jdbc-tool group-manage groupadd group1 --group=group2

### Removing group from group

Following command removes group **group2** from group **group1**:

    ovirt-aaa-jdbc-tool group-manage groupdel group1 --group=group2

## Searching users/groups

### Seraching users

Following command displays all existing users:

    ovirt-aaa-jdbc-tool query --what=user

To narrow results following user attributes can be used:

*   department
*   description
*   displayName
*   email
*   firstName
*   id
*   lastName
*   name
*   title

For example following command searches for users which username starts with **j**:

    ovirt-aaa-jdbc-tool query --what=user --pattern="name=j*"

### Seraching groups

Following command displays all existing groups:

    ovirt-aaa-jdbc-tool query --what=group

To narrow results following group attributes can be used:

*   description
*   displayName
*   name

For example following command searches for groups which name starts with **gr**:

    ovirt-aaa-jdbc-tool query --what=group --pattern="name=gr*"

## Settings

AAA-JDBC extension settings can be displayed using:

    ovirt-aaa-jdbc-tool settings show

Following command updates setting PASSWORD_EXPIRATION_DAYS:

    ovirt-aaa-jdbc-tool settings set --name=PASSWORD_EXPIRATION_DAYS --value=365

## Configuration of additional domains

<Category:Feature> [Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature)
