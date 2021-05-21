---
title: DomainInfrastructure
category: infra
authors:
  - ovedo
  - yair zaslavsky
---

# Domain Infrastructure in the oVirt Engine

This document describes the different components in the oVirt engine domain infrastructure, for authenticating and querying to LDAP servers. The infrastructure supports:

1.  Authenticating Active Directory, IPA and RHDS using GSSAPI authentication
2.  Querying the directory using the LDAP protocol
3.  Easily adding new LDAP provider types
4.  Easily adding new query types

This infrastructure is in the package: org.ovirt.engine.core.bll.adbroker, and it consists of the following main components:

1.  Domain - Entity that represents domain related properties:
    -   name // domain name
    -   RootDSE rootDSE // rootDSE for domain
    -   ldapServers // LDAP servers that match the domain
    -   ldapProviderType // (Active-Directory/IPA/RHDS)
    -   ldapSecurityAuthentication // set the authentication mode. Currently only GSSAPI is allowed

2.  LdapTemplateWrapper - This class is responsible for the basic actions we do with Ldap servers:
    -   initializing context for searches
    -   searching the directory

3.  org.springframework.ldap.core.support.DirContextAuthenticationStrategy - interface for authentication strategy (we implement it in GSSAPIDirContextAuthenticationStrategy for gssapi authentication, and use the basic from spring ldap - SimpleDirContextAuthenticationStrategy, for simple authentication (simple authentication isn't supported anymore).
4.  LdapQueryMetadata - interface that contains metadata about a query. Such as:
    -   filter - the filter we use for the query. For example: (objectGUID=%1$s)
    -   baseDN - we set this if we want to query using a specific base dn
    -   contextMapper - context mapper is an object that takes the context returned from the ldap server, and maps it into the object we wish to return. For example, we have context mappers for user object, ADUserContextMapper and IPAUserContextMapper, that support constructing the user object from active directory and IPA respectively.
    -   searchScope - SUBTREE_SCOPE, ONE_LEVEL_SCOPE or OBJECT_SCOPE
    -   ldapGuidEncoder - used for encoding the guid (useful in cases the guid is not just an ordinary string, like in active directory)
    -   formatter - used for formatting the filter (we have SimpleLdapQueryExecutionFormatter for simple formatting of the filter, or MultipleLdapQueryExecutionFormatter for more composed queries).
    -   queryData - the data of the query. it is set when running it
    -   returningAttributes - array of strings with attribute names we wish the ldap server to return

5.  LdapQueryType - enum with query types
6.  LdapQueryData - contains the data for the query:
    -   ldapQueryType - the query type (for example: getUserByGuid, getGroupByGuid, getGroupByDN...)
    -   filterParameters - parameters for the filter (for example, the guid of the user, the name of the user, etc.)
    -   baseDNParameters - parameters for the basedn, in case we wish to change it
    -   domain - the name of the domain we wish to query

7.  UsersDomainsCacheManagerService - a Service that implements UsersDomainsCacheManager, which supports adding/getting/removing domain objects, and associating user with a domain. The caching in the DB is used for searches and showing updated information in the UI on an hourly basis. It is always updated at login time for authorization decisions
8.  KerberosManager - a Service that initializes the kerberos configuration
9.  DirectorySearcher - a class that is responsible for querying the ldap server. It uses an instance of LdapQueryData in order to preform the query
    -   The directory searcher gets the domain object from the UsersDomainsCacheManagerService, and it preforms a root DSE query in order to deduce the ldap provider type (Active-Directory or IPA)
    -   According to the result it performs the query suitable for the specific ldap provider type

# Some samples

*   Querying user properties by principal name:

        // Create query data object
        LdapQueryData queryData = new LdapQueryDataImpl();

        // We wish to get the user by its principal name
        queryData.setLdapQueryType(LdapQueryType.getUserByPrincipalName);

        // The input of the query
        queryData.setFilterParameters(new Object[] { krbPrincipalName });

        // The domain we wish to query
        queryData.setDomain(domain);

        // Setting the credentials for the query
        LdapCredentials credentials = new LdapCredentials(username, password);

        // Creating the directory searcher
        DirectorySearcher searcher = new DirectorySearcher(credentials);

        // Running the query
        List<AdUser> resultByUpn = searcher.FindAll(queryData);
       

*   Querying group properties by group name:

        LdapQueryData queryData = new LdapQueryDataImpl();
        queryData.setLdapQueryType(LdapQueryType.getGroupByName);
        queryData.setFilterParameters(new Object[] { "dev" });
        queryData.setDomain(domain);

        LdapCredentials credentials = new LdapCredentials(username, password);

        DirectorySearcher searcher = new DirectorySearcher(credentials);

        List<AdUser> resultByname = searcher.FindAll(queryData);
       
