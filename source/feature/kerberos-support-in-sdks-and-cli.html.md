---
title: Kerberos Support in SDKs and CLI
authors: jhernand
wiki_title: Features/Kerberos Support in SDKs and CLI
wiki_revision_count: 3
wiki_last_updated: 2014-09-29
---

# Kerberos support in the SDKs and the CLI

### Summary

This page describes the Kerberos support that will be added to the Python SDK, the Java SDK and the CLI in version 3.6.

### Owner

*   Name: [Juan Hernández](User:Jhernand)
    -   Email:<jhernand@redhat.com>

### Current status

Status: implementation

### Benefit to oVirt

*   Support isntallations where Kerberos has been selected as the authentication mechanism for the engine.

### Description

#### Python SDK

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
