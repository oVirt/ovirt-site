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

## Group management

## Searching users/groups

## Settings

## Configuration of additional domains

<Category:Feature> [Category:oVirt 3.6 Proposed Feature](Category:oVirt 3.6 Proposed Feature)
