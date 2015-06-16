---
title: External Providers API Examples
category: api
authors: jhernand
wiki_title: External Providers API Examples
wiki_revision_count: 1
wiki_last_updated: 2015-01-28
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

This page contains information and examples of the external providers API.

# External host providers

The representation of the resource will look like this:

    GET /externalhostproviders

      ...
      ...

    GET /externalhostproviders/{provider:id}

      myprovider
      My provider
      http://provider.example.com
      true
      myuser
      mypass

The providers collection will support listing, getting, adding, and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operation. The first is used to check the connectivity with the external provider:

     POST /externalhostproviders/{provider:id}/testconnectivity

The second is used to import the chain of certificates of the external provider:

     POST /externalhostproviders/{provider:id}/importcertificates

The provider resource includes subcollections for certificates, provisioned hosts, discovered hosts, host groups and compute resources, all of them read only. For certificates it will look like this:

    GET /externalhostproviders/{provider:id}/certificates

      ...
      ...

    GET /externalhostproviders/{provider:id}/certificates/{certificate:id}

      CN=provider.example.com
    ...

For provisioned hosts:

    GET /externalhostproviders/{provider:id}/hosts

      ...
      ...

    GET /externalhostproviders/{provider:id}/hosts/{host:id}

      myhost
      mhost.example.com

For discovered hosts:

    GET /externalhostproviders/{provider:id}/discoveredhosts

      ...
      ...

    GET /externalhostproviders/{provider:id}/discoveredhosts/{discoveredhost:id}

      myhost
      192.168.122.23
      52:54:00:1a:65:40
      ...
      ...

For host groups:

    GET /externalhostproviders/{provider:id}/hostgroups

      ...
      ...

    GET /externalhostproviders/{provider:id}/hostgroups/{group:id}

      mygroup
      ...
      ...
      ...
      ...

For compute resources:

    GET /externalhostproviders/{provider:id}/computeresources

      ...
      ...

    GET /externalhostproviders/{provider:id}/computeresources/{resource:id}

      myresource
      ...
      ...
      ...

# OpenStack image providers

The representation of the resource will look like this:

    GET /openstackimageproviders

      ...
      ...

    GET /openstackimageproviders/{provider:id}

      myprovider
      My provider
      http://glance.example.com
      true
      myuser
      mypass
      mytenant

          prop1
          value1

          prop2
          value2

The providers collection will support listing, getting, adding, and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operations. The first is used to check the connectivity with the external provider:

    POST /openstackimageproviders/{provider:id}/testconnectivity

The second is used to import the chain of certificates of the external provider:

    POST /openstackimageproviders/{provider:id}/importcertificates

The third is used to import the image:

    POST /openstackimageproviders/{provider:id}/importcertificates

The provider resource includes subcollections for certificates and images. For certificates it will look like this:

    GET /openstackimageproviders/{provider:id}/certificates

      ...
      ...

    GET /openstackimageproviders/{provider:id}/certificates/{certificate:id}

      CN=glance.example.com
      ...

For images:

    GET /openstackimageproviders/{provider:id}/images

      ...
      ...

    GET /openstackimageproviders/{provider:id}/images/{image:id}

      myimage

The image resource supports the `import` operation:

    POST /openstackimageproviders/{provider:id}/images/{image:id}/import

        mysd

        mycluster

      false

# OpenStack network providers

The representation of the resource will look like this:

    GET /openstackneetworkproviders

      ...
      ...

    GET /openstacknetworkproviders/{provider:id}

      myprovider
      My provider
      http://neutron.example.com
      myuser
      mypass
      mytenant
      open_vswitch

        ...
        qpid|rabbit_mq
        ...
        ...
        ...
        ...

          prop1
          value1

          prop2
          value2

The providers collection will support listing, getting, adding and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operations. The first used to check the connectivity with the external provider:

    POST /openstacknetworkproviders/{provider:id}/testconnectivity

The second is used to import the chain of certificates of the external provider:

    POST /openstacknetworkproviders/{provider:id}/importcertificates

The provider resource includes sub-collections for certificates and networks. For certificates it will look like this:

    GET /openstacknetworkproviders/{provider:id}/certificates

      ...
      ...

    GET /openstacknetworkproviders/{provider:id}/certificates/{certificate:id}

      CN=neutron.example.com
      ...

For networks:

    GET /openstacknetworkproviders/{provider:id}/networks

      ...
      ...

    GET /openstacknetworkproviders/{provider:id}/networks/{network:id}

      mynetwork

The network resource will in turn include a sub-collection for sub-networks:

    GET /openstacknetworproviders/{provider:id}/networks/{network:id}/subnets

      ...
      ...

    GET /openstacknetworproviders/{provider:id}/networks/{network:id}/subnets/{subnet:id}

      ...
      v4|v6
      192.168.122.1

        192.168.122.1
        192.168.122.2
        ...
