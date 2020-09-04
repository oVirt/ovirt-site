---
title: PKIReduce
category: feature
authors: alonbl
---

# PKI Reduce

## Current Implementation

[Features/PKI](/develop/release-management/features/infra/pki/)

## Problems in Current Implementation

[Features/PKI#Caveats](/develop/release-management/features/infra/pki/#caveats)

## Mission

Remove PKI usage from Engine<-->VDSM communications.

1.  Simpler implementation -- No need to manage expiration/revocation, there is no point in doing so since as long as host is added to engine it is active.
2.  Easier to rational the reason not to use 3rd party CA for communications.

The mutual authentication method between engine<-->VDSM is internal implementation decision as no other component should access vdsm directly.

## Trying to solve

1.  Remove the term PKI from engine->vdsm communication to avoid these kind of discussions in future, as we are not really need 3rd party trust for manager->agent communication.
2.  Avoid implementing missing PKI feature into vdsm/engine, at least CRL, OCSP, name validation, expiration, key usage, enhanced key usage.
3.  Do not need to manage host life cycle - renew, revocation when removed.
4.  Do not abuse CRL - adding host to CRL each time it is removed.
5.  Allow re-enroll external components' certificate post host-deploy using internal CA or 3rd party, without losing connectivity to our agents.

## Solution #1

As JSSE (Java) and Python SSL are only capable of using X.509 certificate for SSL key exchange, and due to export regulations implication of introducing a new encryption protocol, solution should not use own encryption algorithm nor encryption protocol.

Instead of using PKI, the engine and vdsm will use self signed certificates. Instead of using PKI (Public Key Infrastructure), the trust will be established using PK (no Infrastructure). This means that each party holds the public key of the other party, and use it to validate the authenticity of the connection.

The host-deployment is performed using SSH session, in which the engine initiate the connection and optionally check the SSH public key fingerprint of remote host. Once deployed the engine will store its public key within host and retrieve the public key of the host into the database.

When SSL connection is established, each party will acquire other party's self signed certificate and validate it against the expected one.

Implementation should support several keys at each side to allow flexibility of several managers / fail over.

During migrationCreate engine will send the public key of the other side to each of the nodes, to enable status exchange.

### Optional Enhancement

In order to support SSL termination proxy [Not supported right now, and unlikely that it will], another layer of authentication is required.

One alternative is to use PK signature using both party's private keys.

Another alternative is to use symmetric key authentication, a key that is generated and stored at host side and at engine database, by using symmetric key authentication sequence to authenticate, example Augmented PAKE.

## Solution #2

Have vdsm to connect using HTTPS to engine, and authenticate using PAKE based on symmetric key that is generated during host-deploy. This will remove the need to enroll certificate to all vdsms, and will enable us to issue engine certificate using 3rd party certificate with no complexity.

### Prerequisites

Move migrationCreate to engine, once sanlock is used all over, so that vdsm will not need to send migrationCreate to the other vdsm. Or File RFE against libvirt to allow sending generic messages between libvirt and libvirtd for vdsm to be able to communicate with other vdsm during migrationCreate.

Complete vdsm PKI implementation - support CRL, OCSP, name validation etc..

## vdsClient

Will be used only locally (remotely via ssh).

## PKI

The following component will will keep using PKI:

1.  libvirt
2.  spice/vnc

Engine will be modified to be able to re-enroll these certificate without having to re-deploy vdsm, to allow renewal or transition between internal CA to 3rd party CA.

## TODO

Consider using libvirt with self-signed certificates as well, it should be possible as the migrationCreate can send the certificate for both side for vdsm to feed libvirt when communicating to the other party. Maybe it requires small change in libvirtd to be configured with certificate per connection, or have connection certificate validation callback.

Author: --Alon Bar-Lev (Alonbl)  02:24, 1 July 2014 (GMT)

