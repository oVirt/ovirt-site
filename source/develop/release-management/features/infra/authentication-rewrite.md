---
title: Authentication-Rewrite
authors: alonbl, amureini, wdennis, yair zaslavsky
---

# Authentication & Directory rewrite

<span class="label label-warning"><big>ATTENTION: This page is obsoleted for >=ovirt-engine-3.5 by [Features/AAA](/develop/release-management/features/infra/aaa.html)</big></span>

## Summary

The feature deals with reimplementation of the Authentication and Directory support at oVirt, which is currently based on Kerberos and "internal" user for authentication, and on LDAP and the DB (for internal domain). The work is dividied into two phases -

*   Phase 1 - Redesign the implementation, introducing support for Authenticators and Directories, and implementation of Internal Authenticator and Directory to support the internal domain, and the Provisional Authenticator and Directory to support external. The Provisional directory gets the required configuration from the oVirt database, as it serves as a "bridge" to the existing implementation.

<!-- -->

*   Phase 2 - Implementing Kerberos Authenticator and a new LDAP Directory. Supporting developing of new modules that contain authentication and directory code , not necessarily Kerberos and LDAP based. The configuration for the Authenticators and Directories will be read from a configuration file and will include query structure.

### Owners

*   Name: Yair Zaslavsky (Yair Zaslavsky)
*   Name: Juan Hernandez (Juan Hernandez)
*   Email: <jhernand@redhat.com>

### Current status

*   status: Phase 1 - done. Phase 2 - in progress
*   Last updated: January 19, 2014

## Benefits to oVirt

*   Allows to introduce new types of Authenticators(not just password based) and Directories - not necessarily Kerberos based and LDAP based - this can be done in external modules(using JBoss modules) and does not require recompilation of ovirt Engine and delivery of a new RPM for it.
*   Allows change of configuration to support new LDAP prvoiders or changes in LDAP schema (no code change is required).

### Terminology

*   Authenticator - Responsible for performing the authentication (given a set of credentials, the Authenticator performs authentication and returns a result object indicating whether authentication has succeeded or not) to oVirt engine.
*   AuthenticatorFactory - Responsible for creating an Authenticator. Each type of Authenticator should have its own factory.
*   Directory - responsible for querying information on users and groups.
*   DirectoryFactory - Responsible for creating a Directory. Each type of Directory should have its own factory.
*   Profile - a combination of Authenticator and Directory. Each profile has a name that identifies it uniquely. At Phase 2 - each configuration file must contain configuration for a profile (configuration for Authenticator and a Directory). Webadmin and UserPortal present the list of available profiles at the login screen under the domains list.
*   ExternalId - Not all Directories my contain users and groups that have a UUID identifier. ExternalId is an abstraction representing an ID of an external entity.

## Detailed description of flows

1. Engine restart

At oVirt Engine restart engine gets the list of domains from DB, and creates for each one of them a profile based on Provisional Directory and Authenticator. The profiles are then registered to later usage (the profile will be identified by the domain name). Engine scans a directory that holds configuration files, and for each one of them the configuration file is loaded and creates a profile for them. At Phase 1 the directory is empty and it's still under a debate the location under the filesystem that will hold the directory.

2. Login

The login commands get the the profile by the domain name supplied by the parameters. The associated Authenticator is used to authenticate. The Authenticators have a mechanism to resolve error messages to allow oVirt Engine return the UI detailed information on why the authentication failed (for example - for a password based Authenticator such message may be that the password of the user has expired). The associated Directory will be used to query the user by its name. The returned user information will be used to get the user information from the database, and run the MLA check if the login action is authorized.

3. Search users & groups

Each Directory should contain in its configuration the required information in order to perform a search of users. For example, an LDAP directory may need to define the user (currently known as "domain user") to perform the search queries with, the authentication method for the user (may be SIMPLE, SASL or others). Bare in mind that this configuration, even if contains authentication details (for example -user, encrypted password, usage of SASL with GSSAPI as mechanism) is unrelated to the configuration of the Authenticator. The search queries for users and groups will be run against query methods at the Directory object.

4. Support different LDAP vendors via configuration (Phase-2)

In order to achieve support for different LDAP vendors, the configuration should include the following information:

*   Root DSE handling -

As ROOT DSE queries are used to collect information on the directory ("metadata") some vendors might hold different attributes in the ROOT DSE which may later on be utilized for further directory queries. It is required to add an ability to provide a custom handler if needed, and a default implementation. As the base DN under which the users and the groups will be queried for is also provided by the Root DSE, it is required to provide a mapping between an abstracted name of the attribute (for example - "namingContexts") to a vendor-specific name of the attribute (for example "defaultNamingContexts" in Active Directory.)

*   Queries templates - Each query (i.e - "GetUserByName") should have a "template" that defines the query structure and allows to include parameters in it.

Before a query is executed, the proper template should be resolved into a query string, by substituting the parameter place holders to parameter values. Such a template may be - ((objectClass=Person)(uid=%1$s)) the parameter place holder in this example is the "%1$s" sub string.

*   Users and groups returning attributes mapping -

Users and groups attributes may be defined differently in different LDAP vendors. A mapping between the vendor attribute name (for example - "sn" in Active Directory) to an abstracted attribute name used by the code (for example - "lastName" ) should be included.

*   Search attributes mapping -

The generated query by the search mechanism is an abstract LDAP query in a sense it does not contain vendor specific attributes, but placeholders , for example - $ACCOUNTTYPE these attributes should be replaced to vendor specific ones.

The following is an example (still work in progress) for the mapping part in configuration file for IPA - [ODT](http://resources.ovirt.org/old-site-files/wiki/Ipa_configuration.odt)

## Open issues

1. Phase 2 - location of directory to hold configuration files - See BZ1049876

2. Phase-2 - Configuration structure for LDAP - patches are still under review, configuration structure may change

## Testing

As currently only Phase-1 is implemented , the tests should be done to see no regression were introduced -

1.  Use manage-domains, add a domain with addPermissions option and perform a login
2.  Use-manage-domain, add another domain with addPermissioons option and perform login (positive fow - check support for multiple domains)
3.  Give permissions to a group to perform a login, login using a user from that group
4.  Give permissions to a user , and login with that user
5.  Try to login with a user that does not exist in the domain
6.  Try to login with a user that does not have permissions to login
7.  Try to login with an account that is either locked/disabled or that the user has expired password - see that a proper message appears at UI
8.  Remove a domain , check that you cannot log in with users from that domain.
