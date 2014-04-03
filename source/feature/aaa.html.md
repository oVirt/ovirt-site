---
title: AAA
category: feature
authors: alonbl, yair zaslavsky
wiki_category: Feature
wiki_title: Features/AAA
wiki_revision_count: 40
wiki_last_updated: 2015-02-12
---

# AAA

## Authentication, Authorization and Accounting at oVirt (3.5)

### Summary

Introducing a new architecture to AAA.

### Owner

*   Name: [Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>
*   Name: [Alon Bar Lev](User:alonbl)
*   Email: <alonbl@redhat.com>

### Current status

*   Target Release: 3.5
*   Status: work in progress
*   Last updated: ,

### Main Benefit to oVirt

*   Clear separation of authentication from authorization.
*   Providing a developer API to develop custom extensions for authentication and authorization
    -   Introducing of other authentication mechanisms - it will be possible to authenticate not using kerberos
    -   Introducing non ldap providers for directories - for example, a JDBC provider can ease the definition of internal users
    -   Usage of configuration files and not the database for configuration of providers

### Detailed Description

Currently the authentication and authorization mechanisms in engine are:

*   a. based on DB configuration (entries at vdc_options table).
*   b. We have only internal mechanism based on single user defined in db, and a Kerberos/Ldap mechanaism.
*   c. Tighltly coupled in BLL code

In order to change that we suggest to provide a mechanism that is based on the following:

#### Extensions

Extensions are software plugins that conform to the extensions API. Each extension has a configuration file. When engine starts it scans filesystem directories defined by the entry of ENGINE_EXTENSION_PATH at the configuration file ovirt-engine.cof

For example:

ovirt-engine.conf:ENGINE_EXTENSION_PATH="${ENGINE_USR}/extensions.d:${ENGINE_ETC}/extensions.d"

Each configuration file will contain the following entries:

ovirt.engine.extension.name - the name of the extension ovirt.engine.extension.class - the class implementing the extension ovirt.engine.extension.module - jboss module name containing the extension ovirt.engine.extension.enabled - whether the extension is enabled or not ovirt.engine.extension.sensitiveKeys - list of sensitive keys not to be logged. ovirt.engine.extension.provides - type of service that the extension provides (For example, in case of AAA - org.ovirt.engine.authentication, or org.ovirt.engine.authorization)

In addition, specific entries per extension may be included. For authenticatos (extensions dealing with authentication) the following keys also must be presented -

ovirt.engine.aaa.authn.profile.name - A profile is a combination of authenticaton and authorizaton(directory) extensions ovirt.engine.aaa.authn.authz.plugin - Name of the authorization extension to which the authentication is associated with.

A developer of the extensions should work with the API defined at : <link to Alon's API> And pack the extensions developed as a jboss module.

Once engine starts, the directories containing configuration files are scanned, the extensions are created, and profiles are created for matching authenticaton and authorization extensions.

#### UI

The getDomainsList query that populates the "domains" in the login screen now receives a list of profiles.

#### REST-API

The following changes are introcued:

For a domain user - the ID is now a hex representation of the ID of the user within the directory (as the directory may be a non LDAP now, it may not always be GUID). The domain users can be retrieved from /api/domains/<DOMAIN_IDENTIFIER>/users

When a domain user is being added to the DB , by sending a POST reques to /api/users , Based on the user name and the domain provided, a query is run against the directory, and the user is retrieved from it, and added to the DB. When observing users in the DB, by issuing GET /api/users , the ID of the user in the directory is represented by <domain_entry_id><HEX_VALUE></domain_entry_id>

All of the above is correct for domain groups as well, with the relevant changes to URLs.

### Backend and extensions work

*   Changing existing (built-in) extensions to support the Extensions API
    -   The current LdapKerberos Authenticator/Directory code, and the Internal Authenticator/Code should be aligned with the new API.

This will also require changes at Engine code to call the extensions API properly.

*   Introducing a generic LDAP provider
    -   A generic LDAP provider conforming to the new API is being developed.
        -   The code of the generic LDAP provider will be based on JNDI java SDK (not on spring ldap)
        -   For each ldap provider (OpenLdap, ActiveDirectory, RHDS, IPA) there will be a a "template" file which will contain information such as query/search mapping and mapping of

attributes to users/groups

### Tools

*   engine-manage-domains

engine-manage-domains will be kept to support the "built-in" (AKA "legacy") providers.

*   ovirt-engine-role

This tool will be used in order to assign role to an entry of a user from an authorization provider (AKA directory). In order to run the tool, the user of the tool will have to provide the following parameters:

*   -   a. user name
    -   b. provider
    -   c. id of user within the provider
    -   d. role (for example "SuperUser")

The tool will create the user in the database and allocate a system permissions based on the role and the user .

### Open Issues

*   Correctness of Extensions API
*   Format for generic ldap configuraton
    -   To be determined soon
*   Format of generic ldap template file.
    -   To be determined soon, the queries will look similar to the ones at org.ovirt.engine.extensions.aaa.builtin.kerberosldap.LdapQueryMetadataFactoryImpl

### Testing

*   Verify that after upgrade from 3.4 no regressions are introduced: It is possible to query users,groups in the already added domains, the permissions mechanism is working as expected

(users can perform same operations as they did in 3.4), it is possible to add new users/groups from the already added domains.

*   Manage-domains utility should still work and be able to add new domains.
*   Add the generic ldap provider , restart engine, have the ability to query for users/groups from the generic provider , add them to the system, assign them permissions , etc...

### Comments and Discussion

### Future Work
