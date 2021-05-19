---
title: AllowExplicitDnsConfiguration
category: feature
authors: mmucha
---

# Allow Explicit DNS Configuration

rfe: https://bugzilla.redhat.com/show_bug.cgi?id=1160667

### Owner

*   Name: Martin Mucha (mmucha)
*   Email: mmucha@redhat.com

## Summary
When a new host is added to the system, it is attached to the 
management network. As of ovirt-4.0.3, DNS configuration for such network
will be obtained from resolv.conf file. With this feature implemented,
an admins should be able to specify overriding configuration in
WebAdmin. They can do that at several places:

* By updating management network of given host (in backend terms — via
its NetworkAttachment)
* By updating management network of given DC (or later of given Cluster) 

## Detailed Description

So DNS configuration can be stored in multiple places. If DNS
configuration is not specified in either of them, no DNS configuration
data will be passed to VDSM during SetupNetworks command and default
values from resolv.conf will be used. If either of them is used, it
will be passed to VDSM overriding configuration from resolv.conf. For
example we can set DNS configuration in a Network related to certain DC
(or later to certain Cluster) and this configuration will override
configuration in resolv.conf. 

When a Network is being attached in 
certain host, NetworkAttachment record is created for this, 
and DNS configuration defined on Network is used. If we want to 
override it only for certain NetworkAttachment, we can do so.
If we now setup configuration in NetworkAttachment, attaching 
ManagementNetwork of given DataCenter (or
later of given Cluster) to specific Host, this configuration is more
specific than one in Network of DC (or later Cluster) scope and will
be used instead. 

If certain management network is attached to multiple hosts, then any 
change to this management network DNS configuration will cause update 
of DNS configuration on all such hosts, except for ones, which have DNS 
configuration overridden in NetworkAttachment related to that 
management network.
  
If admins setup DNS configuration in engine, and then update
/etc/resolv.conf manually on host, it will make configuration on host
and configuration stored in NetworkAttachment out of sync. 
Tackling this issue might not be done in first increment, but we
should implement checking, whether required value (one stored in
NetworkAttachment) matches one actually set on host. Without it users
might get confused — they see some value in engine, while altogether
different one is being actually used. Once done, imparity will be in
UI rendered as NetworkAttachment being out of sync. Of course, this
can happen only with management network. Users then can sync network
as usual to reapply DNS configuration stored in NetworkAttachment, or
update DNS configuration to get rid of this warning.

Based on IP configuration and whether DNS is specified in engine, 
there are four usecases:

* DHCP is not enabled in IP configuration and DNS is unset. 
In that case DNS configuration won't be sent in SetupNetworks verb, and 
existing DNS settings on host will be preserved.

* DHCP is not enabled in IP configuration and DNS is set. 
In that case DNS configuration will be sent in SetupNetworks verb, and 
existing DNS settings on host will be overwritten.

* DHCP is enabled in IP configuration and DNS is unset. 
In that case DNS configuration won't be sent in SetupNetworks verb, and 
existing DNS settings on host will be overwritten by DHCP provided 
settings, if those are available.

* DHCP is enabled in IP configuration and DNS is set.
In that case DNS configuration will be sent in SetupNetworks verb, and 
existing DNS settings on host will be overwritten by DNS settings, 
specified in engine.

### DB
Database needs to be updated so it can accommodate DNS configuration.
Two places will be altered:

* `network_attachments` table
* `network` table

both these tables must accommodate multiple DNS records. Naive
solution would be to store them comma separated into single column.
Better solution would be creating separate table for that. That's
subject of further discussion. VDSM supports 0 to 3 DNS entries, so
engine needs to comply to this limitation as well.

### REST

As mentioned, you can specify DNS Configuration at two places.
Corresponding REST areas will be altered. But first we need to add new
element 'dns_configuration' as:
 
```
@Type
public interface DnsResolverConfiguration {
 String[] nameServers();
}
```

…, which will be translated into following XSchema definition during
engine build.


```
<xs:element name="dns_resolver_configuration" type="DnsResolverConfiguration"/>

  <xs:complexType name="DnsResolverConfiguration">
    <xs:sequence>
      <xs:element maxOccurs="1" minOccurs="0" name="name_servers">
        <xs:complexType>
          <xs:annotation>
            <xs:appinfo>
              <jaxb:class name="NameServersList"/>
            </xs:appinfo>
          </xs:annotation>
          <xs:sequence>
            <xs:element maxOccurs="unbounded" minOccurs="0" name="name_server" type="xs:string">
              <xs:annotation>
                <xs:appinfo>
                  <jaxb:property name="NameServers"/>
                </xs:appinfo>
              </xs:annotation>
            </xs:element>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
    </xs:sequence>
  </xs:complexType>
```

After doing so, we're prepared to use following xml fragment defining
DNS configuration in several places (read on):

```
<dns_resolver_configuration>
  <name_servers>
    <name_server>1.1.1.1</name_server>
    <name_server>2.2.2.2</name_server>
  </name_servers>
</dns_resolver_configuration>
```

#### Updating (Management) Network
You can update any network with DNS Configuration, however all such DNS
Configurations will be simply ignored during creation of new host except 
for the DNS configuration defined on the network, which happens to be 
management network at time of creating new host.

```
PUT /ovirt-engine/api/networks/{network:id} HTTP/1.1
Content-Type: application/xml

<network>
  <dns_resolver_configuration>
    <name_servers>
      <name_server>1.1.1.1</name_server>
      <name_server>2.2.2.2</name_server>
    </name_servers>
  </dns_resolver_configuration>
</network>
```

#### Updating 'network attachment' of Management Network on specific Host 
Only the network attachment of the management network can be updated
with DNS configuration.

```
PUT ovirt-engine/api/hosts/{host:id}/networkattachments/{networkattachment:id} HTTP/1.1
Content-type: application/xml

<network_attachment>
  <dns_resolver_configuration>
    <name_servers>
      <name_server>1.1.1.1</name_server>
      <name_server>2.2.2.2</name_server>
    </name_servers>
  </dns_resolver_configuration>
</network_attachment>

```

### GUI

As mentioned, you can specify DNS Configuration at two places:

#### Updating (Management) Network
You can update any network with DNS Configuration, however all such DNS
Configurations will be simply ignored during creation of new host except 
for the DNS configuration defined on the network, which happens to be 
management network at time of creating new host.
![Edit Logical Network Dialog with DNS Configuration](/images/editLogicalNetworkDialogWithDnsConfiguration.png "Edit Logical Network Dialog with DNS Configuration")

#### Updating 'attachment' of Management Network on specific Host 
![Editing Network Attachment Dialog with DNS configuration](/images/editNetworkAttachmentDialogWithDnsConfiguration.png "Editing Network Attachment Dialog with DNS configuration")

### Testing

* When no DNS is defined, the host predefined one remains configured.
This is the case upon upgrade to ovirt-4.1 or fresh installation.
* When adding a host, its DNS is taken from the logical management
network, and this can be later overridden by updating network 
attachment.
