---
title: OVirt 3.5.3 Release Notes
category: documentation
authors: alonbl, sandrobonazzola
wiki_category: Documentation
wiki_title: OVirt 3.5.3 Release Notes
wiki_revision_count: 22
wiki_last_updated: 2015-06-15
---

# OVirt 3.5.3 Release Notes

## Install / Upgrade from previous versions

## What's New in 3.5.3?

## Known issues

### PKI

Due to certificate incompatibility issue with rfc2459[1](https://bugzilla.redhat.com/show_bug.cgi?id=1210486) and potential of certificate expiration [2](https://bugzilla.redhat.com/show_bug.cgi?id=1214860) since first release, the CA, Engine, Apache and Websocket proxy certificates may be renewed during upgrade.

The renew process should introduce no downtime for the engine and hosts communications, however users' browsers may require acceptance of the new CA certificate. The new CA certificate which is located at /etc/pki/ovirt-engine/ca.pem should be distributed to all remote components that require PKI trust.

## Bugs fixed

### oVirt Engine

### VDSM

<Category:Documentation> <Category:Releases>
