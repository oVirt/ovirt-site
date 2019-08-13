---
title: Kerberos Support in SDKs and CLI
authors: jhernand
---

# Kerberos support in the SDKs and the CLI

## Summary

This page describes the Kerberos support that will be added to the Python SDK, the Java SDK and the CLI in version 3.6.

## Owner

*   Name: Juan Hernández (Jhernand)
    -   Email:<jhernand@redhat.com>

## Current status

Status: implementation

## Benefit to oVirt

*   Support isntallations where Kerberos has been selected as the authentication mechanism for the engine.

## Description

### Python SDK

The Kerberos support for the Python SDK will be implemented in two steps:

*   Replace the standard HTTP library with pycurl: <http://gerrit.ovirt.org/33064>
*   Add the Kerberos support: <http://gerrit.ovirt.org/33221>

Once this is implemented the user will be able to specify the use of Kerberos authentication with a new `kerberos` parameter in the constructor of the `API` object:

     api = ovirtsdk.api.API(
      url="https://ovirt.example.com/ovirt-engine/api",
      kerberos=True,
      ...
     )

For this to work the Kerberos client has to be correctly configured (the `/etc/krb5.conf` file has to exist) and the credentials cache has to be already populated (using the `kinit` command, for example).

### Java SDK

The Kerberos support in the Java SDK will be implemented in one step, as the `httpcomponents` library that we currently use already supports Kerberos authentication. However, to simplify things for users, we will also introduce a new `ApiBuilder` class to make construction of the API object easier:

*   Introduce the new `ApiBuilder` class: <http://gerrit.ovirt.org/33503>
*   Add the Kerberos support: <http://gerrit.ovirt.org/33504>

Once these two changes are done, the user will use the SDK as follows:

     Api api = new ApiBuilder()
      .url("https://ovirt.example.com/ovirt-engine/api")
      .kerberos(true)
      .build();

For this to work the Kerberos of the Java virtual machine has to be configured correctly. This means that the `/etc/krb5.conf` file has to exist. This isn't usually a problem, as it is required by almost any Kerberos client. But it also means that a JAAS configuration file has to be created to configure the Java virtual machine. The location of this JAAS configuration file isn't important, it just has to be readable by the Java virtual machine. The content should be like this:

    com.sun.security.jgss.login {
      com.sun.security.auth.module.Krb5LoginModule required client=true useTicketCache=true;
    };

    com.sun.security.jgss.initiate {
      com.sun.security.auth.module.Krb5LoginModule required client=true useTicketCache=true;
    };

    com.sun.security.jgss.accept {
      com.sun.security.auth.module.Krb5LoginModule required client=true useTicketCache=true;
    };

In addition the following system properties need to be present, either adding command line options to the `java` command or using the `System.setProperty(...)` method:

    -Djava.security.auth.login.config=/etc/jaas.conf
    -Djava.security.krb5.conf=/etc/krb5.conf
    -Djavax.security.auth.useSubjectCredsOnly=false

The Java SDK will not populate the credentials cache, it has to be populated before calling it, using the `kinit` command, for example.

### CLI

As the CLI uses the Python SDK for all its network communication the only change required is a new `--kerberos` option that will be translated into the new `kerberos=True` parameter of the constructor of the API object:

*   Add the `--kerberos` option: <http://gerrit.ovirt.org/33417>

After this modification the user will be able to use Kerberos authentication adding the `--kerberos` option to the `ovirt-shell` command or adding the `kerberos = True` option to the `.ovirtshellrc` file.
