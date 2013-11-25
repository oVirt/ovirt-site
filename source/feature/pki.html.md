---
title: PKI
category: feature
authors: alonbl, sven
wiki_category: Feature
wiki_title: Features/PKI
wiki_revision_count: 11
wiki_last_updated: 2014-08-14
---

# PKI

oVirt project uses PKI for various of tasks, this article outlines the PKI usage and is correct for versions 3.2, 3.3.

### Channels

#### ovirt-engine--SSL-->vdsm

During the deployment of a host as hypervisor a certificate is enrolled using engine's internal CA.

The communication between ovirt-engine and host is performed using mutually authenticated SSL session based on engine certificate and vdsm certificate.

Due to legacy issue, the protocol that is being used is SSLv3 and not TLS.

#### ovirt-engine--SSH-->hosts

ovirt-engine is capable of authenticating using its certificate public key to hosts using SSH protocol. This feature is optional for generic hosts, and mandatory during deploy post registration and upgrade of ovirt-node distribution.

#### ovirt-engine<---->database

Sensitive fields are encrypted using engine certificate, it should have used own certificate but due to legacy reasons it remained the same.

#### User--SSL-->apache--AJP-->ovirt-engine

User access ovirt-engine via web browser using TLS/SSL via apache web server. By default the certificate enrolled is issued by the internal engine CA, but this certificate can be replaced by any 3rd party certificate without limiting the functionality.

Replacing certificate can be done using manually configuration of the mod_ssl, or by replacing the following files within /etc/pki/ovirt-engine:

      apache-ca.pem
      keys/apache.p12
      keys/apache.key.nopass
      certs/apache.cer

#### User--SSL-->spice(qemu)

qemu is configured to use the same certificate as vdsm, which is due to legacy design and is somewhat incorrect as unlike vdsm this certificate is exposed to end users.

During session initiation the internal engine certificate authority is sent to the spice client as trusted root so session can be established.

#### libvirt--SSL-->libvirt or qemu--SSL-->qemu

Used for migration, mutual authentication using vdsm certificate.

#### ovirt-node--SSL-->ovirt-engine

Used for registration protocol, the web certificate is pulled out of the SSL handshake and trusted based on fingerprint. Then SSH public key (engine certificate public key) is retrieved and installed for root user.

#### log-collector--SSH-->hosts

Uses the same method and keys of ovirt-engine to access hosts.

### File locations

#### ovirt-engine

All files are relative to /etc/pki/ovirt-engine.

| Component                 | File                            | Description                                                                                                 |
|---------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------------|
| Engine internal CA        | ca.pem                          | Certificate pem encoded.                                                                                    |
|                           | private/ca.pem                  | Internal CA private key **SENSITIVE!**                                                                      |
| Apache artifacts          | apache-ca.pem                   | Apache trusted CA, by default same as ca.pem                                                                |
|                           | keys/apache.p12                 | Key bundle                                                                                                  |
|                           | keys/apache.key.nopass          | Extracted from keys/apache.p12 used by mod_ssl                                                             |
|                           | certs/apache.cer                | Extracted from keys/apache.p12 used by mod_ssl                                                             |
| Engine artifacts          | keys/engine.p12                 | used by engine for ssh and ssl authentication against hosts and vdsm, also used to encrypt database fields. |
|                           | keys/engine_id_rsa            | Extracted from keys/engine.p12 used by various components that should not access private key.               |
|                           | certs/engine.cer                | Extracted from keys/engine.p12 used by log-collector.                                                       |
|                           | .truststore                     | JKS containing trusted certificate authorities for engine.                                                  |
| Jboss artifacts           | keys/jboss.p12                  | Used for jboss ssl in ovirt-engine-3.2, for debug only at ovirt-engine-3.3                                  |
| websocket-proxy artifacts | keys/websocket-proxy.p12        | Key bundle                                                                                                  |
| websocket-proxy artifacts | keys/websocket-proxy.key.nopass | Extracted from keys/websocket-proxy.p12 as python does not know how to work with PKCS#12.                  |
| websocket-proxy artifacts | certs/websocket-proxy.cer       | Extracted from keys/websocket-proxy.p12 as python does not know how to work with PKCS#12.                  |

#### vdsm

| Component    | File                                        | Description                                     |
|--------------|---------------------------------------------|-------------------------------------------------|
| vdsm         | /etc/pki/vdsm/certs/cacert.pem              | trusted engine certificate, engine internal CA  |
|              | /etc/pki/vdsm/certs/vdsmcert.pem            | vdsm certificate                                |
|              | /etc/pki/vdsm/keys/vdsmkey.pem              | vdsm key.                                       |
| qemu/libvirt | /etc/pki/vdsm/libvirt-spice/ca-cert.pem     | qemu spice pki store, same as vdsm ca.          |
|              | /etc/pki/vdsm/libvirt-spice/server-key.pem  | qemu spice pki store, same as vdsm key.         |
|              | /etc/pki/vdsm/libvirt-spice/server-cert.pem | qemu spice pki store, same as vdsm certificate. |
| libvirt      | /etc/pki/libvirt/clientcert.pem             | libvirt certificate, same as vdsm certificate.  |
|              | /etc/pki/libvirt/private/clientkey.pem      | libvirt key, same as vdsm key.                  |
|              | /etc/pki/CA/cacert.pem                      | libvirt trust store.                            |

### Caveats

*   Internal engine CA does not support revocation.
*   Engine does not allow certificate management, for example revocation of hosts that are removed.
*   Engine/vdsm do not support renewal protocol of certificates.
*   vdsm does not support revocation protocol (crl, ocsp), engine (java) support is not enabled.
*   Unsupported installation of internal CA on separate computer.
*   No protocol for CA interaction to allow using different CA implementations.
*   Certificate of database encryption should be separate certificate.
*   Certificate of spice SSL should be separate certificate.

<Category:Feature> <Category:Security>
