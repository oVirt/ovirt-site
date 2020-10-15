---
title: AddingKeystoneURLToExternalProviders
category: feature
authors: emesika, moti
---

# Adding Keystone URL to OpenStack External Providers

## Summary

Enable to add keystone URL for OpenStack external providers that require authentication.

## Owner

*   Name: Eli Mesika

<!-- -->

*   Email: emesika@redhat.com

<!-- -->

*   Last updated date: OCT 7, 2014

## Current status

Currently, all OpenStack external providers like Neutron and Glance are using the same Keystone authentication URL stored in the KeystoneAuthUrl configuration value. The requirement is to add a URL field per such provider for setting that URL and enable diffrent OpenStack providers using diffrent Keystone authentication URLs

![](/images/wiki/ExternalProviderDialog.png)

## Detailed Description

In order to support multiple OpenStack external providers that use different Keystone URLs we should:

       * Add a auth_url field to the providers table
       * Add a new Authentication URL field to the New/Edit External Provider dialog under the Requires Authentication 
          checkbox, this field will be visible only for OpenStack providers.
       * Change code to take provider's Keystone URL from the auth_url column in he providers table rather than
          from the configuration KeystoneAuthUrl value
       * Provide upgrade script that populates auth_url for OpenStack external providers that have auth_required set
          to true from  the configuration KeystoneAuthUrl value
       * Remove configuration KeystoneAuthUrl key from  vdc_options 
       * Remove KeystoneAuthUrl from engine-config

## Benefit to oVirt

Support multiple OpenStack external providers that use different Keystone URLs for authentication.

## Documentation / External references

[RFE](https://bugzilla.redhat.com/show_bug.cgi?id=1157999)




