---
title: External Providers API Examples
category: api
authors: jhernand
---

# External host providers

This page contains information and examples of the external providers API.

The representation of the resource will look like this:

```xml
GET /externalhostproviders
<external_host_providers>
  <external_host_provider id="{provider:id}">...</external_host_provider>
  ...
</external_host_providers>
```

```xml
GET /externalhostproviders/{provider:id}
<external_host_provider id="{provider:id}">
  <name>myprovider</name>
  <description>My provider</description>
  <url>http://provider.example.com</url>
  <requires_authentication>true</requires_authentication>
  <username>myuser</username>
  <password>mypass</password>
</external_host_provider>
```

The providers collection will support listing, getting, adding, and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operation. The first is used to check the connectivity with the external provider:

```xml
 POST /externalhostproviders/{provider:id}/testconnectivity
 <action/>
```


The second is used to import the chain of certificates of the external provider:

```xml
 POST /externalhostproviders/{provider:id}/importcertificates
 <action/>
```


The provider resource includes subcollections for certificates, provisioned hosts, discovered hosts, host groups and compute resources, all of them read only. For certificates it will look like this:

```xml
GET /externalhostproviders/{provider:id}/certificates
<certificates>
  <certificate id="{host:id}">...</certificate>
  ...
</certificates>
```

```xml
GET /externalhostproviders/{provider:id}/certificates/{certificate:id}
<certificate id="{certificate:id}">
  <subject>CN=provider.example.com</subject>
<content>...</content>
</certificate>
```

For provisioned hosts:

```xml
GET /externalhostproviders/{provider:id}/hosts
<external_hosts>
  <external_host id="{host:id}">...</external_host>
  ...
</external_hosts>
```

```xml
GET /externalhostproviders/{provider:id}/hosts/{host:id}
<external_host id="{host:id}">
  <name>myhost</name>
  <address>mhost.example.com</address>
</external_host>
```


For discovered hosts:

```xml
GET /externalhostproviders/{provider:id}/discoveredhosts
<external_discovered_hosts>
  <external_discovered_host id="{host:id}">...</external_discovered_host>
  ...
</external_discovered_hosts>
```

```xml
GET /externalhostproviders/{provider:id}/discoveredhosts/{discoveredhost:id}
<external_discovered_host id="{discoveredhost:id}">
  <name>myhost</name>
  <ip>192.168.122.23</ip>
  <mac>52:54:00:1a:65:40</mac>
  <subnet_name>...</subnet_name>
  <last_report>...</last_report>
</external_discovered_host>
```

For host groups:

```xml
GET /externalhostproviders/{provider:id}/hostgroups
<external_host_groups>
  <external_host_group id="{group:id}">...</external_host_group>
  ...
</external_host_groups>
```

```xml
GET /externalhostproviders/{provider:id}/hostgroups/{group:id}
<external_host_group id="{group:id}">
  <name>mygroup</name>
  <architecture_name>...</architecture_name>
  <operating_system_name>...</operating_system_name>
  <subnet_name>...</subnet_name>
  <domain_name>...</domain_name>
</external_host_group>
```

For compute resources:

```xml
GET /externalhostproviders/{provider:id}/computeresources
<external_compute_resources>
  <external_compute_resource id="{resource:id}">...</external_compute_resource>
  ...
</external_compute_resources>
```

```xml
GET /externalhostproviders/{provider:id}/computeresources/{resource:id}
<external_compute_resource id="{resource:id}">
  <name>myresource</name>
  <provider>...</provider>
  <user>...</user>
  <url>...</url>
</external_compute_resource>
```


# OpenStack image providers

The representation of the resource will look like this:

```xml
GET /openstackimageproviders
<openstack_image_providers>
  <openstack_image_provider id="{provider:id}">...</openstack_image_provider>
  ...
</openstack_image_providers>
```

```xml
GET /openstackimageproviders/{provider:id}
<openstack_image_provider id="{provider:id}">
  <name>myprovider</name>
  <description>My provider</description>
  <url>http://glance.example.com</url>
  <requires_authentication>true</requires_authentication>
  <username>myuser</username>
  <password>mypass</password>
  <tenant_name>mytenant</tenant_name>
  <properties>
    <property>
      <name>prop1</name>
      <value>value1</myvalue>
    </property>
    <property>
      <name>prop2</name>
      <value>value2</myvalue>
    </property>
  </properties>
</openstack_image_provider>
```

The providers collection will support listing, getting, adding, and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operations. The first is used to check the connectivity with the external provider:

```xml
POST /openstackimageproviders/{provider:id}/testconnectivity
<action/>
```

The second is used to import the chain of certificates of the external provider:

```xml
POST /openstackimageproviders/{provider:id}/importcertificates
<action/>
```

The third is used to import the image:

```xml
POST /openstackimageproviders/{provider:id}/importcertificates
<action/>
```

The provider resource includes subcollections for certificates and images. For certificates it will look like this:

```xml
GET /openstackimageproviders/{provider:id}/certificates
<certificates>
  <certificate id="{host:id}">...</certificate>
  ...
</certificates>
```

```xml
GET /openstackimageproviders/{provider:id}/certificates/{certificate:id}
<certificate id="{certificate:id}">
  <subject>CN=glance.example.com</subject>
  <content>...</content>
</certificate>
```

For images:

```xml
GET /openstackimageproviders/{provider:id}/images
<openstack_images>
  <openstack_image id="{image:id}">...</openstack_image>
  ...
</openstack_images>
```

```xml
GET /openstackimageproviders/{provider:id}/images/{image:id}
<openstack_image id="{image:id}">
  <name>myimage</name>
</openstack_image>
```

The image resource supports the `import` operation:

```xml
POST /openstackimageproviders/{provider:id}/images/{image:id}/import
<action>
  <storagedomain>
    <name>mysd</name>
  </storagedomain>
  <cluster>
    <name>mycluster</name>
  </cluster>
  <import_as_template>false</import_as_template>
</action>
```

# OpenStack network providers

The representation of the resource will look like this:

```xml
GET /openstackneetworkproviders
<openstack_network_providers>
  <openstack_network_provider id="{provider:id}">...</openstack_network_provider>
  ...
</openstack_network_providers>
```

```xml
GET /openstacknetworkproviders/{provider:id}
<openstack_network_provider id="{provider:id}">
  <name>myprovider</name>
  <description>My provider</description>
  <url>http://neutron.example.com</url>
  <username>myuser</username>
  <password>mypass</password>
  <tenant_name>mytenant</tenant_name>
  <plugin_type>open_vswitch<plugin_type>
  <agent_configuration>
    <network_mappings>...</network_mappings>
    <broker_type>qpid|rabbit_mq<broker_type>
    <address>...</address>
    <port>...</port>
    <username>...</username>
    <password>...</password>
  </agent_configuration>
  <properties>
    <property>
      <name>prop1</name>
      <value>value1</myvalue>
    </property>
    <property>
      <name>prop2</name>
      <value>value2</myvalue>
    </property>
  </properties>
</openstack_network_provider>
```


The providers collection will support listing, getting, adding and removing providers, with the usual methods.

The provider resource will support getting, deleting and updating the provider, with the usual methods. In addition it will support the `testconnectivity` and `importcertificates` operations. The first used to check the connectivity with the external provider:

```xml
POST /openstacknetworkproviders/{provider:id}/testconnectivity
<action/>
```

The second is used to import the chain of certificates of the external provider:

```xml
POST /openstacknetworkproviders/{provider:id}/importcertificates
<action/>
```

The provider resource includes sub-collections for certificates and networks. For certificates it will look like this:

```xml
GET /openstacknetworkproviders/{provider:id}/certificates
<certificates>
  <certificate id="{host:id}">...</certificate>
  ...
</certificates>
```

```xml
GET /openstacknetworkproviders/{provider:id}/certificates/{certificate:id}
<certificate id="{certificate:id}">
  <subject>CN=neutron.example.com</subject>
  <content>...</content>
</certificate>
```

For networks:

```xml
GET /openstacknetworkproviders/{provider:id}/networks
<openstack_networks>
  <openstack_network id="{network:id}">...</openstack_network>
  ...
</openstack_networks>
```

```xml
GET /openstacknetworkproviders/{provider:id}/networks/{network:id}
<openstack_network id="{networkd:id}">
  <name>mynetwork</name>
</openstack_network>
```

The network resource will in turn include a sub-collection for sub-networks:

```xml
GET /openstacknetworproviders/{provider:id}/networks/{network:id}/subnets
<openstack_subnets>
  <openstack_subnet id="{subnet:id}">...<openstack_subnet>
  ...
</openstack_subnets>
```

```xml
GET /openstacknetworproviders/{provider:id}/networks/{network:id}/subnets/{subnet:id}
<openstack_subnet id="{subnet:id}">
  <cidr>...</cidr>
  <ip_version>v4|v6<ip_version>
  <gateway>192.168.122.1</gateway>
  <dns_servers>
    <dns_server>192.168.122.1</dns_server>
    <dns_server>192.168.122.2</dns_server>
    ...
  </dns_servers>
</openstack_subnet>
```
