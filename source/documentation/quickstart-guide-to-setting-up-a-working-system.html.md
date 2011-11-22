---
title: Quickstart guide to setting up a working oVirt system
category: documentation
authors: jumper45, quaid, sandrobonazzola
wiki_category: Draft documentation
wiki_title: Quickstart guide to setting up a working oVirt system
wiki_revision_count: 14
wiki_last_updated: 2014-09-26
---

# Quickstart guide to setting up a working oVirt system

| DRAFT                                           |
|-------------------------------------------------|
| This is a draft and contains many inaccuracies. |

## Install FC16 x86_64

<http://download.fedoraproject.org/pub/fedora/linux/releases/16/Live/x86_64/Fedora-16-x86_64-Live-Desktop.iso>

## Install oVirt-engine

[Installing_ovirt-engine_from_rpm](Installing_ovirt-engine_from_rpm)

## Start the engine

        ${JBOSS_HOME}/bin/run.sh -b 0.0.0.0
       

## Host Installation

### Fedora 16

#### Install VDSM

        $>sudo yum install fence-agents libvirt libvirt-python nfs-utils qemu-img qemu-kvm
       

Download and install all of the rpms found in <http://fsimonce.fedorapeople.org/vdsm/fedora-16/x86_64>

create /etc/vdsm/vdsm.conf with the following:

        [vars]
        ssl = False
       

        $> sudo chkconfig vdsmd on
        $> sudo systemctl start vdsmd.service
       

#### Create the network Bridge

ovirt-engine will expect the host to have a bridge named 'engine'. Messing with network setting can sometimes result in complete loss of connectivity. Ensure that you have direct console access before starting this. To create the bridge do the following:

Add the bridge for your network interface. if your interface is named em1, edit the file /etc/sysconfig/network-scripts/ifcfg-em1 It should look like this:

        DEVICE=em1
        ONBOOT=yes
        HWADDR=<your mac address>
        BRIDGE=engine
        BOOTPROTO=none
       

Next create the file /etc/sysconfig/network-scripts/ifcfg-engine with the following contents:

        DEVICE=engine
        TYPE=Bridge
        BOOTPROTO=dhcp
        ONBOOT=yes
        DELAY=0
        NM_CONTROLLED=no
        MTU=1500 
       

Once this is done, restart networking and ensure that the bridge exists.

#### Register The Host

        curl -X POST -d "<host><name>${hostname}</name><address>${ipaddress}</address><root_password>${password}</root_password></host>" --header "Content-Type: application/xml" -u 'admin@internal:letmein!' http://${server}:${port}/api/hosts
       

You should receive a response that looks like:

      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <host id="8c357b14-0bf2-11e1-be5c-bf378750dd6e" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e">
          <name>pollux</name>
          <actions>
              <link rel="install" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/install"/>
              <link rel="fence" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/fence"/>
              <link rel="activate" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/activate"/>
              <link rel="deactivate" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/deactivate"/>
              <link rel="approve" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/approve"/>
              <link rel="iscsilogin" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/iscsilogin"/>
              <link rel="iscsidiscover" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/iscsidiscover"/>
              <link rel="commitnetconfig" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/commitnetconfig"/>
          </actions>
          <link rel="storage" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/storage"/>
          <link rel="nics" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/nics"/>
          <link rel="tags" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/tags"/>
          <link rel="permissions" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/permissions"/>
          <link rel="statistics" href="/api/hosts/8c357b14-0bf2-11e1-be5c-bf378750dd6e/statistics"/>
          <address>10.16.19.85</address>
          <status>
              <state>unassigned</state>
          </status>
          <cluster id="99408929-82cf-4dc7-a532-9d998063fa95" href="/api/clusters/99408929-82cf-4dc7-a532-9d998063fa95"/>
          <port>54321</port>
          <type>rhel</type>
          <storage_manager>false</storage_manager>
          <power_management>
              <enabled>false</enabled>
              <options/>
          </power_management>
          <ksm>
              <enabled>false</enabled>
          </ksm>
          <transparent_hugepages>
              <enabled>false</enabled>
          </transparent_hugepages>
          <cpu>
              <speed>0</speed>
          </cpu>
          <summary>
              <total>0</total>
          </summary>
      </host>
       

The response contains the host Id. You will need this for performing actions upon the host.

#### Create NFS Storage

VDSM will not work with NFS v4 so ensure that you are configured to prevent the use of NFS v4. You should create three nfs shares, one for each type of storage domain: data, iso and import/export.

Information on how to create nfs shares can be found at <http://fedoraproject.org/wiki/Administration_Guide_Draft/NFS>

#### Register the storage

### oVirt-node

[Category:Draft documentation](Category:Draft documentation) <Category:Installation> [Category:How to](Category:How to)
