---
title: Serial Console Setup
authors: fromani
wiki_title: Serial Console Setup
wiki_revision_count: 22
wiki_last_updated: 2015-10-12
---

# Serial Console Setup

## General

The purpose of this page is to document how to properly setup and troubleshoot the [Serial_Console](Serial_Console) feature, available in oVirt 3.6.0.

## Setup

The Serial Console can be setup either automatically, using engine-setup, or manually (not recommended). In both cases, the ovirt-vmconsole-proxy services must run on the same host on which Engine runs. This requirement will be lifted in a future release. The following sections documents fresh install of oVirt 3.6.x. For upgrading from 3.5.x, please see **upgrade notes** and **troubleshooting** below.

### Automatic Setup

1.  make sure you have all the required package installed. Alongside ovirt-engine and ovirt-engine setup, you must make sure you have the *ovirt-vmconsole-proxy* package installed in the same host on which ovirt-engine runs.
2.  to make ovirt-vmconsole-proxy host accessible, make sure the port "2223" is open. The setup procedure will setup "firewalld" accordingly.
3.  run engine-setup and follow instructions provided interactively. Please note that the vmconsole proxy setup is disabled if the *ovirt-vmconsole-proxy* package is NOT detected when the setup runs.
4.  once the setup succesfully run, and once ovirt-engine is running, you can log in and register a SSH key. (TODO: add picture)
5.  when you install an hypervisor host, the deploy procedure will automatically install and setup the "ovirt-vmconsole-host" package.
6.  make sure the user which want to use the serial console feature has permissions on the VM on which he wants to connect.
7.  make sure the relevant VM have the "Virtio Console Device" enabled
8.  congratulations! setup is now done. Please check **Connecting to consoles** below.

### Manual Setup

**This is NOT the recommended way**. The setup is a complex procedure. Use automatic setup whenever possible, and report bugs! Consider the following more like a checklist for troubleshooting rather than an HOWTO!

#### step 1: proxy and Engine setup

**TODO: verify the steps**

You need to have ovirt-engine installed. "password", below, is the ovirt-engine PKI password. As usual, "#" represents the root prompt. Since you need to leverage Engine's PKI, execute the following on the host on which Engine runs:

First, create certificates and keys for the vmconsole proxy helper:

       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=vmconsole-proxy-helper --password=password --subject="/C=COUNTRY/O=ORG/CN=FQDN" --ku=digitalSignature --eku=1.3.6.1.4.1.2312.13.1.2.1.1
       # /usr/share/ovirt-engine/bin/pki-pkcs12-extract.sh --name=vmconsole-proxy-helper --password=password
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-engine/certs/vmconsole-proxy-helper.cert
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass
       # chmod 0600 /etc/pki/ovirt-engine/keys/vmconsole-proxy-helper.key.nopass

Now configure the helper:

*   edit the helper configuration file (FIXME)
*   add content:

       --- cut here ---
       ENGINE_BASE_URL=FIXME
       TOKEN_CERTIFICATE=FIXME
       TOKEN_KEY=FIXME
       --- cut here ---

Now, configure the ovirt-vmconsole-proxy package to use the helper.

*   edit the proxy configuration file (FIXME)
*   add content:

       --- cut here ---
       [proxy]
       key_list = exec FIXME --version {version} keys
       console_list = exec FIXME --version {version} consoles --entityid {entityid}"
       --- cut here ---

#### step 2: host connection setup

Install the needed packages on the hypervisor hosts:

       ovirt-vmconsole
       ovirt-vmconsole-host

Make sure the port 2223 is open on the hypervisor hosts

You need to have ovirt-engine installed. "password", below, is the ovirt-engine PKI password. As usual, "#" represents the root prompt. Since you need to leverage Engine's PKI, execute the following on the host on which Engine runs:

       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=proxy1-host --password=password --subject="/CN=proxy1"
       # /usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name=proxy1-user --password=password --subject="/CN=proxy1"
       # /usr/share/ovirt-engine/bin/pki-enroll-openssh-cert.sh --name=proxy1-host --id=proxy1 --host --principals=@PROXY_FQDN@
       # /usr/share/ovirt-engine/bin/pki-enroll-openssh-cert.sh --name=proxy1-user --id=proxy1 --principals=ovirt-vmconsole-proxy
       # cp /etc/pki/ovirt-engine/certs/proxy1-host-cert.pub /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa-cert.pub
       # cp /etc/pki/ovirt-engine/certs/proxy1-user-cert.pub /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa-cert.pub
       # openssl pkcs12 -passin password -in /etc/pki/ovirt-engine/keys/proxy1-host.p12 -nodes -nocerts > /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa
       # openssl pkcs12 -passin password -in /etc/pki/ovirt-engine/keys/proxy1-user.p12 -nodes -nocerts > /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa
       # chown ovirt-vmconsole:ovirt-vmconsole /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa
       # chmod 0600 /etc/pki/ovirt-vmconsole/proxy-ssh_host_rsa /etc/pki/ovirt-vmconsole/proxy-ssh_user_rsa

## Connecting to consoles

Access to proxy by user is perform using the following command, a menu with the available consoles will be presented:

       $ ssh -t -p 2222 ovirt-vmconsole@proxy-host connect

Access to specify console can be done using the following command:

       $ ssh -t -p 2222 ovirt-vmconsole@proxy-host connect --vm-id=1E12DF323

List available consoles:

       $ ssh -p 2222 ovirt-vmconsole@proxy-host list

Usage:

       $ ssh -p 2222 ovirt-vmconsole@proxy-host -- --help

## Upgrade Notes

If you are upgrading fro oVirt 3.5.x, to use the serial consone feature you must perform engine-setup and key registration in Engine exactly as per fresh start. Hoever, additional care is needed.

1.  the upgrade procedure **will automatically upgrade the existing VM to use the new Serial Console Device**. Please see "Troubleshooting" below if you still need to manually connect to your consoles. Otherwise, the upgrade
2.  to use the new Serial Console Device, you must redeploy all existing host, to make sure the correct setup is performed.

Please note that installing the needed package on your hypervisor hosts (ovirt-vmconsole, ovirt-vmconsole-host), is necessary, but not sufficient to use the feature. You also must enroll keys and certificates, and this is what reinstall will do.

## Troubleshooting

### I need to access the console the old way

Starting 3.6.x. the VM console are no longer connected to PTYs, but to unix domain socket. In 3.5.x days, the way to connect to VM consoles was something like

       ssh hypervisor-host
       virsh console $VM_NAME

in 3.6.x, if you need to manually connect to console, you can connect to unix domain socket:

       ssh hypervisor-host
       minicom -D unix#$VM_SOCKET

Please note that the user which runs minicom must be part of the **ovirt-vmconsole** group the socket will have paths like

       /var/run/ovirt-vmconsole-console/$VM_UUID.sock

another option is using socat:

       socat -,raw,echo=0,escape=1 UNIX-LISTEN:/var/run/ovirt-vmconsole-console/$VM_UUID.sock,user=ovirt-vmconsole

### SELinux denials running ovirt-vmconsole-list.py

Pending u/s fix
