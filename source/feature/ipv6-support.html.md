---
title: IPv6 support
category: feature
authors: amuller, danken, osvoboda, psebek
wiki_category: Feature
wiki_title: Features/IPv6 support
wiki_revision_count: 70
wiki_last_updated: 2014-11-06
---

# IPv6 support

### Summary

This feature enable to connect to vdsm and ovirt-engine via IPv6 protocol.

### Owner

*   Name: [ Petr Šebek](User:Psebek)
*   Email: <psebek@redhat.com>
*   IRC: psebek at #ovirt (irc.oftc.net)

### Current status

*   Status: Design
*   Last updated: ,

### Detailed Description

With growing importance of protocol IPv6 there is need to provide this functionality in Ovirt. This feature enable IPv6 at the Vdsm and Ovirt-engine side, so the users won't need to use IPv4 anymore.

### Changes in code

#### Vdsm

*   New class 'netmodels.IPv6'. Similar like netmodels.IPv4, for address validation and representation
    -   This brings changes in class netmodels.IpConfig, configNetwork.objectivizeNetwork,

#### Ovirt-Engine GUI

In the GUI of engine there will be need to change this items:

*   ipAddressValidation - add recognition of IPv6 address
*   hosAddressValidation - same as ip

Fields that can contain IPv6 address:

*   Host address in adding new host
*   network address in Setup Host Network -> edit network -> boot protocol: static :
    -   IP
    -   subnet mask - in IPv4 subnet mask has form of doted decimal number, same as IPv4 address. In IPv6 subnet is made of single number from 0-128 that depicts the number of bits from start that belongs to site. Mostly here will be number 64.
    -   gateway - regular IPv6 address
*   address of nics in network interfaces - this should be just basic content of cell of table, so arbitrary string
*   add/import storage address

#### Pending patches

On the Vdsm side there are this pending patches <http://gerrit.ovirt.org/#/q/status:open+project:vdsm+branch:master+topic:ipv6_support,n,z> .

### Benefit to oVirt

By implementing this feature oVirt will be prepared for users that are using IPv6 protocol.

### Dependencies / Related Features

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Testing

#### Vdsm

Currently there is need to specify management_ip in config file to be in IPv6 format, so after build and installation of Vdsm update file /etc/vdsm/vdsm.conf, and change management_ip under address section to:

       management_ip = ::

After start of vdsmd service there should be record in netstat like this:

       $ netstat -tanp | grep 54321
        tcp6 0 0 :::54321 :::* LISTEN 21545/python

Now you should be able to control vdsmd with vdsClient using IPv6 addresses:

       vdsClient -s [::1] getVdsCaps
       vdsClient -s [::1]:54321 getVdsCaps
       vdsClient -s localhost6 getVdsCaps
       vdsClient -s localhost6:54321 getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt] getVdsCaps
       vdsClient -s ['IPv6 link-local addr'%ovirtmgmt]:54321 getVdsCaps

Where 'IPv6 link-local addr' is address of IPv6 link local address of bridge ovirtmgmt (e.g. [fe80::5054:ff:fe05:25f3%ovirtmgmt]). Each of this command should work as in normal manner.

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to [Talk:IPv6 support](Talk:IPv6 support)

<Category:Feature>
