---
title: Support OpenStack Identity API v3
category: feature
authors: dholler
---

# Support OpenStack Identity API v3

## Summary

[OpenStack Identity API v2.0][8] is not only deprecated, it is even
removed from the current [OpenStack Identity API specification][1] and replaced
by the OpenStack Identity API v3.

oVirt Engine requires the OpenStack Identity API to access external logical
networks provided by [OpenStack Neutron][2] or [OVN][3], to access images from
[OpenStack Glance][4] and volumes from [OpenStack Cinder][5].

Support for OpenStack Identity API v3 in oVirt Engine will [enable Engine to
access services from OpenStack Neutron][13] which does
[not support Identity API v2.0 anymore][12].
To achieve this only Engine's OpenStack Network Provider will be updated,
other providers like OpenStack Image, OpenStack Block Storage, and External
Network Provider will continue with Identity API v2.0.

The [oVirt OVN Provider][6] provides the OpenStack Identity API for
[authentication][7], but will continue with OpenStack Identity API v2.0.

Related patches can be found on [gerrit topic:keystone_v3][11].

## Owner

*   Name: [Eitan Raviv](https://github.com/erav)

*   Email: <eraviv@redhat.com>

## Detailed Description

This section shows the difference between the versions v2.0 and v3 of OpenStack
Identity API and what this implies for oVirt.

The OpenStack Identity API is used in oVirt to get or provide a token, which is
required to use the other OpenStack APIs, e.g. Networking API.

### OpenStack Identity API v2.0

A typical request to get a token in OpenStack Identity API v2.0 is a HTTP `POST`
to `/v2.0/tokens` with the content:
~~~~
{
  "auth": {
    "passwordCredentials": {
      "username": "admin"
      "password": "c314d360aab94a5f"
     },
    "tenantName": "demo",
  }
}
~~~~
The `tenantName` is supported for external providers for oVirt Engine, but
ignored in oVirt Provider OVN. The most relevant part of the response is like
the following:
~~~~
{
  "access": {
    "token": {
      "id": "aaaaa-bbbbb-ccccc-dddd"
    }
  }
}
~~~~

### OpenStack Identity API v3

Most relevant changes in the data model in version v3 are:
* "Tenants" are now known as "projects"
* "Domains": a high-level container for projects, users and groups
* User, group and project names only have to be unique within their owning domain
* Tokens explicitly represent user+project or user+domain pairs
* The token is returned the X-Subject-Token response header

A typical request to get a token in OpenStack Identity API v3 is a HTTP `POST`
to `/v3/auth/tokens` with the content:
~~~~
{
  "auth" : {
    "identity" : {
      "methods" : [ "password" ],
      "password" : {
        "user" : {
          "domain" : {
            "name" : "Default"
          },
          "name" : "admin",
          "password" : "c314d360aab94a5f"
        }
      }
    },
    "scope" : {
      "project" : {
        "domain" : {
          "name" : "Default"
        },
        "name" : "admin"
      }
    }
  }
}
~~~~
The `scope` might be not required, e.g. if a default project is configured for
the user. The relevant part of the response looks like this:
~~~~
HTTP/1.1 201 Created
X-Subject-Token: gAAAAABbH3sSGLgtxvoHyYDLZd6fSuserBHG2P-3TdykaYnq-eYo7aUBdZK0I
Vary: X-Auth-Token
Content-Type: application/json

{"token": ... }
~~~~

### Implementation in oVirt Engine

To support OpenStack Identity API v3 oVirt engine has to be extended to handle
the user domain name, the project name and the domain name of the project.
This requires changes in webadmin, REST-API, the database and the
TokenProvider in the backend.

The version of the OpenStack Identity API is derived from the authentication
URL. If the authentication URL ends with "/v3" or "/v3/", OpenStack Identity
API v3 will be used, else OpenStack Identity API v2.0 to ensure backward
compatibility.

The default ovirt-provider-ovn has not be modified, because the OpenStack
Identity API v2.0 is not removed.


## Prerequisites

oVirt Engine requires an updated version of [OpenStack Java SDK 3.2.x][9] to
accessing OpenStack Identity API v3.

## Limitations

OpenStack Identity API provides a catalog of multiple endpoints, which
provides the URL to access the OpenStack service. This feature does change
the current implementation in oVirt Engine, which requires the user to specify
this URL manually.

## Benefit to oVirt

Support for OpenStack Identity API v3 in oVirt Engine is required to enable 
access to services from [OpenStack instances which does not support Identity
API v2.0, especially the OpenStack releases since Qeens.][12]

## User Experience

### Webadmin

The "Add Provider" popup has to provide inputs for the new properties user
domain name, the project name and the domain name of the project.
To avoid inconsistency between the authentication URL and the API version, the
authentication URL is built from the protocol, host name, API port and version.

![add a new provider](/images/features/network/openstack_idendity_api-add-dialog-provider.png)

Please note, that the OpenStack user requires permissions to create ports on the
network.

### Engine-Setup

The ovirt-provider-ovn external provider which is configured by engine-setup is
not modified and continues to use OpenStack Identity API v2.0, because of the
Engine and the OVN provider has to support OpenStack Identity API v2.0 for the
sake of backward compatibility anyway and switching to OpenStack Identity API
v3 would be no improvement but introduce the risk of new implementation bugs.

## REST-API
The REST-API is extended to handle the user domain name, the project name and
the domain name of the project like the following:
~~~~xml
<openstack_network_provider href="/ovirt-engine/api/openstacknetworkproviders/123" id="123">
  <actions>
    <link 
      href="/ovirt-engine/api/openstacknetworkproviders/123/testconnectivity"
      rel="testconnectivity" />
    <link
      href="/ovirt-engine/api/openstacknetworkproviders/123/importcertificates"
      rel="importcertificates"/>
  </actions>
  <name>OpenStack Neutron</name>
  <description>network provider for OpenStack</description>
  <link
    href="/ovirt-engine/api/openstacknetworkproviders/123/networks"
    rel="networks"/>
  <link
    href="/ovirt-engine/api/openstacknetworkproviders/123/certificates"
    rel="certificates"/>
  <url>http://192.168.122.104:9696</url>
  <auto_sync>true</auto_sync>
  <read_only>false</read_only>
  <type>external</type>
  <unmanaged>false</unmanaged>
  <requires_authentication>true</requires_authentication>
  <authentication_url>http://192.168.122.104:5000/v3</authentication_url>
  <username>admin@internal</username>
  <project_name>admin</project_name><!-- Added -->
  <user_domain_name>Default</user_domain_name><!-- Added -->
  <project_domain_name>Default</project_domain_name><!-- Added -->
</openstack_network_provider>
~~~~

## Installation/Upgrade

No effect on new installations of oVirt Engine.
On upgrade, it has to be ensured that the authentication URL has the expected
format to be splitted like proposed in [Webadmin](#webadmin).

## Follow-Up Features

### Implementation in oVirt Provider OVN
To support OpenStack Identity API v3 the oVirt Provider OVN to be extended to
handle requests to `/v3/auth/tokens`. The `scope` can be ignored, like the
`tenantName`.
In oVirt Provider OVN's OpenStack Identity API v2.0 implementation the
user name has to match the following format:
`<admin_username>[@<fqdn>]@<ovirt_profile>`, while the optional `<fqdn>` is
the Active Directory or LDAP domain. For the reason of consistency, this format
is kept in the OpenStack Identity API v3 implementation and the `user.domain`
is ignored.

## Documentation & External references

[OpenStack Identity API Specification](https://developer.openstack.org/api-ref/identity/)

[oVirt OpenStack Neutron Integration](/develop/release-management/features/network/osn-integration.html)

[oVirt OVN Integration](/develop/release-management/features/network/external-network-provider.html)

[oVirt Glance Integration](/develop/release-management/features/storage/glance-integration.html)

[oVirt Cinder Integration](/develop/release-management/features/storage/cinder-integration.html)

[oVirt Provider OVN](/develop/release-management/features/network/ovirt-ovn-provider.html)

[Authentication and Authorization at the oVirt Provider OVN](/develop/release-management/features/network/ovirt-ovn-provider.html#authentication-and-authorization-at-the-provider)

[OpenStack Identity API v2.0](https://web.archive.org/web/20170127173135/http://developer.openstack.org/api-ref/identity/v2/)

[OpenStack Java SDK](https://github.com/woorea/openstack-java-sdk)


[Trello](https://trello.com/c/3LN6xSIT/257-engine-support-keystone-v3)

[Related patches](https://gerrit.ovirt.org/#/q/topic:keystone_v3)

[Blueprint for tracking things being removed in the Queens release](https://blueprints.launchpad.net/keystone/+spec/removed-as-of-queens)

[RFE - Certify OVN from OSP 13 via Neutron API with external OSP provider.](https://bugzilla.redhat.com/show_bug.cgi?id=1598391)

## Testing

### oVirt Engine

It has to be ensured, that all already available OpenStack related tests of
oVirt Engine are still succeeding, to ensure that already available OpenStack
Identity API v2.0 has no regressions. This might be the case because a new
minor version of [OpenStack Java SDK][9] is used.

To test the OpenStack Identity API v3, all already available tests of OpenStack
network provider can be duplicated to use OpenStack Qeens (keystone 13).

## Release Notes

      == Support OpenStack Identity API v3 ==
      oVirt Engine is able to access external Networks provided by OpenStack
      Qeens Neutron
