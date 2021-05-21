---
title: AAA
category: feature
authors:
  - alonbl
  - yair zaslavsky
---

# AAA

## ovirt-engine Authentication, Authorization and Accounting

### Outline

Since ovirt-engine-3.5 a stable extensible interface for AAA (Authentication, Authorization and Accounting) was established to support various solutions.

### Available extensions

For most people, extension specific documentation should be sufficient, the following extensions are available. These extensions are provided as independent packages, install if required.

*   ovirt-engine-extension-aaa-ldap - an LDAP based authentication and authorization, obsoletes the legacy Kerberos/LDAP implementation, [ovirt-3.5](https://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=ovirt-engine-extension-aaa-ldap-1.0), [ovirt-3.6](https://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-ldap.git;a=blob;f=README;hb=HEAD).
*   [AAA_JDBC ovirt-engine-extension-aaa-jdbc](/develop/release-management/features/infra/aaa-jdbc.html) - a JDBC based authentication and authorization, provided as default local provider in 3.6 and up.
*   [ovirt-engine-extension-aaa-misc HTTP Autnentication](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.http;hb=HEAD) - an SSO helper authentication.
*   [ovirt-engine-extension-aaa-misc RegExp Mapper](http://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-aaa-misc.git;a=blob;f=README.mapping;hb=HEAD) - a mapper implementation to transform user and principal names.

### API

*   ovirt-engine-extensions-api - artifacts to build against.
*   ovirt-engine-extensions-api-javadoc - javadocs.

### Concepts

#### Authentication (Authn)

A process to resolve and validate user credentials. It supports two modes:

*   Credentials based authentication, can be used to validate user and password.
*   Negotiation based authentication, can be used to negotiate authenticity based on HTTP negotiation.

Output of the process is AuthRecord which contains the user principal name and optionally other information.

Extension interface is org.ovirt.engine.api.extensions.aaa.Authn.

#### Authorization (Authz)

A process to retrieve principal name information such as unique id, group membership, attributes.

Output of the process is PrincipalRecord or various search results.

Extension interface is org.ovirt.engine.api.extensions.aaa.Authz.

Authentication extension refer to mapping and authorization extensions, once user is authenticated using a specific profile he is to be resolved using specific authorization extension.

#### Mapping

A user name and/or principal name transformation. Helpful when authn and authz needs different inputs than provided.

Extension interface is org.ovirt.engine.api.extensions.aaa.Mapping.

#### Accounting (Acct)

Accounting statistics and events.

Extension interface is org.ovirt.engine.api.extensions.aaa.Acct.

### Configuration

#### Common

For each extension create /etc/ovirt-engine/extension.d/XXX.properties we have the following attributes:

      ovirt.engine.extension.name = @NAME@
      ovirt.engine.extension.bindings.method = jbossmodule
      ovirt.engine.extension.binding.jbossmodule.module = @MODULE@
      ovirt.engine.extension.binding.jbossmodule.class = @CLASS@

@MODULE, @CLASS@ should be replaced by values taken from extension documentation.

@NAME@ is unique name given by sysadmin to an extension instance.

#### Authz

In addition to common:

      ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authz

Extension specific fields may also be specified.

#### Mapper

In addition to common:

      ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Mapping

Extension specific fields may also be specified.

#### Authn

In addition to common:

      ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Authn
      ovirt.engine.aaa.authn.profile.name = profile1    # user visible name for this authn profile.
      ovirt.engine.aaa.authn.authz.plugin = authz1      # refers to the authz extension to be used.
      ovirt.engine.aaa.authn.mapping.plugin = mapping1  # optional mapper extension to be used.

Extension specific fields may also be specified.

#### Acct

In addition to common:

      ovirt.engine.extension.provides = org.ovirt.engine.api.extensions.aaa.Acct

Extension specific fields may also be specified.

