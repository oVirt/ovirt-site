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

[Building_Ovirt_Engine](Building_Ovirt_Engine)

## Start the engine

        ${JBOSS_HOME}/bin/run.sh -b 0.0.0.0
       

## Install VDSM

        $>sudo yum install fence-agents libvirt libvirt-python nfs-utils qemu-img qemu-kvm
       

Download and install all of the rpms found in <http://fsimonce.fedorapeople.org/vdsm/fedora-16/x86_64>

create /etc/vdsm/vdsm.conf with the following:

        [vars]
        ssl = False
       

        $> sudo chkconfig vdsmd on
        $> sudo systemctl start vdsmd.service
       

## Create the network Bridge

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

## Register The Host

        curl -X POST -d "<host><name>${hostname}</name><address>${ipaddress}</address><root_password>${password}</root_password></host>" --header "Content-Type: application/xml" -u 'admin@internal:letmein!' http://${server}:${port}/api/hosts
       

## Associate the Host with A Data Center

## Create NFS Storage

## Register the storage

[Category:Draft documentation](Category:Draft documentation) <Category:Installation> [Category:How to](Category:How to)
