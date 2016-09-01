---
title: AllowExplicitDnsConfiguration
category: feature
authors: mmucha
wiki_category: Feature
wiki_title: Features/AllowExplicitDnsConfiguration
wiki_revision_count: 12
wiki_last_updated: 2015-10-14
feature_name: Allow Explicit Dns Configuration
feature_modules: Networking
feature_status: Design
rfe: https://bugzilla.redhat.com/show_bug.cgi?id=1160667

---

# Allow Explicit Dns Configuration

### Owner

*   Name: [ Martin Mucha](User:mmucha)
*   Email: mmucha@redhat.com

## Summary
When new host is added to the system, management network will be created for it. Dns configuration for such network will be obtained from resolv.conf file. However admin should be able to specify overriding configuration in WebAdmin. He can do that at several places:

* During creation new host
* By updating management network of given host (in backend terms — via its NetworkAttachment)
* By updating management network of given DC (or later of given Cluster) 

## Detailed Description

So DNS configuration can be stored in multiple places. If DNS configuration is not specified in either of them, no DNS configuration data will be passed to VDSM during SetupNetworks command and default values from resolv.conf will be used. If either of them is used, it will be passed to VDSM overriding configuration from resolv.conf. For example we can set DNS configuration in Network related to certain DC (or later to certain Cluster) and this configuration will override configuration in resolv.conf. If we now setup configuration in NetworkAttachment, attaching ManagementNetwork of given DataCenter (or later of given Cluster) to specific Host, this configuration is more specific than one in Network of DC (or later Cluster) scope and will be used instead.  

### DB
Database needs to be updated so it can accommodate dns configuration. Two places will be altered:

* network_attachments table
* network table

both this tables must accommodate multiple DNS records. Naive solution would be to store them comma separated into single column. Better solution would be creating separate table for that. That's subject of further discussion.

### REST

As mentioned, you can specify DNS Configuration at three places. Corresponding REST areas will be altered. But first we need to add new element 'dns_configuration' as: 

```
<xs:element name="dns_configuration" type="DnsConfiguration"/>

<xs:complexType name="DnsConfiguration">
  <xs:complexContent>
    <xs:extension base="BaseResource">
      <xs:sequence>
        <xs:element maxOccurs="1" minOccurs="0" name="ips" type="Ips"/>
      </xs:sequence>
    </xs:extension>
  </xs:complexContent>
</xs:complexType>
```

#### Creating new Host
```
POST /ovirt-engine/api/hosts HTTP/1.1
Content-Type: application/xml

<host>
    <name>$NAME</name>
    <address>$ADDRESS</address>
    <port>$PORT</port>>
    <root_password>$PASSWORD</root_password>
    <cluster>
        <name>$CLUSTERNAME</name>
    </cluster>
    <dns_configuration>
        <ips>
          <ip>
            <address>8.8.8.8</address>
          </ip>
        </ips>
      </dns_configuration>
</host>
```

#### Updating Management Network
only management network can be updated with dns configuration.

```
PUT /ovirt-engine/api/networks/{network:id} HTTP/1.1
Content-Type: application/xml

<network>
  <dns_configuration>
    <ips>
      <ip>
        <address>8.8.8.8</address>
      </ip>
    </ips>
  </dns_configuration>
</network>
```

#### Updating 'network attachment' of Management Network on specific Host 
only network attachment of management network can be updated with dns configuration.

```
PUT ovirt-engine/api/hosts/{host:id}/networkattachments/{networkattachment:id} HTTP/1.1
Content-type: application/xml

<network_attachment>
  <dns_configuration>
    <ips>
      <ip>
        <address>8.8.8.8</address>
      </ip>
    </ips>
  </dns_configuration>
</network_attachment>

```

### GUI

As mentioned, you can specify DNS Configuration at three places:

#### Creating new Host
![New Host Dialog with DNS Configuration](newHostDialogWithDnsConfiguration.png "New Host Dialog with DNS Configuration")

#### Updating Management Network
(note — when editing other network this option won't be available)
![Edit Logical Network Dialog with DNS Configuration](editLogicalNetworkDialogWithDnsConfiguration.png "Edit Logical Network Dialog with DNS Configuration")

#### Updating 'attachment' of Management Network on specific Host 
![Editing Network Attachment Dialog with DNS configuration](editNetworkAttachmentDialogWithDnsConfiguration.png "Editing Network Attachment Dialog with DNS configuration")
