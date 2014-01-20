---
title: Authentication-Rewrite
authors: alonbl, amureini, wdennis, yair zaslavsky
wiki_title: Features/Authentication-Rewrite
wiki_revision_count: 16
wiki_last_updated: 2014-12-07
---

# Authentication & Directory rewrite

### Summary

The feature deals with reimplementation of the Authenticating and Directory support at oVirt, which is currently based on Kerberos and "internal" user for authentication, and on LDAP and the DB (for internal domain). The work is dividied into two phases -

*   Phase 1 - Redesign the implementation, introducing support for Authenticators and Directories and Implmenetation of Internal Authenticator and Directory

to support the internal domain, and the Provisional Authenticator and Directory to support . The Provisional directory gets the required configuration from the oVirt database, as it serves as a "bridge" to the existing implementation.

*   Phase 2 - Implementing Kerberos Authenticator and a new LDAP Directory. Supporting developing of new modules that contain authentication and directory code , not necessarily Kerberos and LDAP based. The configuration for the Authenticators and Directories will be read from a configuration file and will include query structure.

#### Owners

*   Name: [Yair Zaslavsky](User:Yair Zaslavsky)
*   Email: <yzaslavs@redhat.com>
*   Name: [Juan Hernandez](User:Juan Hernandez)
*   Email: <jhernand@redhat.com>

#### Current status

*   status: Phase 1 - done. Phase 2 - in progress
*   Last updated: January 19, 2014

### Benefits to oVirt

*   Allows to introduce new types of Authenticators(not just password based) and Directories - not necessarily Kerberos based and LDAP based - this can be done in external modules and does not require recompilation of ovirt Engine and delivery of a new RPM for it.
*   Allows change of configuration to support new LDAP prvoiders or changes in LDAP schema (no code change is required).

#### Terminology

*   Authenticator - Responsible for performing the authencation (given a set of credentials, the Authenticator performs authentication and returns a result object indicating whether authentication has succeeded or not) to oVirt engine.
*   Directory - responsible for querying information on users and groups.
*   Profile - a combination of Authenticator and Directory. Each profile has a name that identifies it uniquely. At Phase 2 - each configuration file must contain configuration for a profile (configuration for Authenticator and a Directory).

Webadmin and UserPortal present the list of available profiles at the login screen under the domains list.

*   ExternalId - Not all Directories my contain users and groups that have a UUID identifier. ExternalId is an abstraction representing an ID of an external entity.
