---
title: PKI
category: feature
authors: alonbl, sven
---

# PKI

oVirt project uses PKI for various of tasks, this article outlines the PKI usage and is correct for versions 3.2, 3.3.

## Channels

### ovirt-engine--SSL-->vdsm

During the deployment of a host as hypervisor a certificate is enrolled using engine's internal CA.

The communication between ovirt-engine and host is performed using mutually authenticated SSL session based on engine certificate and vdsm certificate.

Due to legacy issue, the protocol that is being used is SSLv3 and not TLS.

Caveats: vdsm does not perform revocation check, current setup does not support intermediate certificates.

### ovirt-engine--SSH-->hosts

ovirt-engine is capable of authenticating using its certificate public key to hosts using SSH protocol. This feature is optional for generic hosts, and mandatory during deploy post registration and upgrade of ovirt-node distribution.

Caveats: ovirt-engine does not perform revocation check, current setup does not support intermediate certificates.

### ovirt-engine--SSL-->database

Based on connection setting, the database connection can use SSL, the trusted certificate authority are the jre trusted certificate authorities at $JAVA_HOME/lib/security/cacerts.

### ovirt-engine database fields

Sensitive database fields are encrypted using engine certificate, it should have used own certificate but due to legacy reasons it remained the same.

### User--SSL-->apache--AJP-->ovirt-engine

User access ovirt-engine via web browser using TLS/SSL via apache web server. By default the certificate enrolled is issued by the internal engine CA, but this certificate can be replaced by any 3rd party certificate without limiting the functionality.

Replacing certificate can be done using manually configuration of the mod_ssl, or by replacing the following files within /etc/pki/ovirt-engine:

      apache-ca.pem
      keys/apache.p12
      keys/apache.key.nopass
      certs/apache.cer

### User--SSL-->spice(qemu)

qemu is configured to use the same certificate as vdsm, which is due to legacy design and is somewhat incorrect as unlike vdsm this certificate is exposed to end users.

During session initiation the internal engine certificate authority is sent to the spice client as trusted root so session can be established.

Caveats: current setup does not support intermediate certificates.

### libvirt--SSL-->libvirt or qemu--SSL-->qemu

Used for migration, mutual authentication using vdsm certificate.

Caveats: current setup does not support intermediate certificates.

### ovirt-node--SSL-->ovirt-engine

Used for registration protocol, the web certificate is pulled out of the SSL handshake and trusted based on fingerprint. Then SSH public key (engine certificate public key) is retrieved and installed for root user.

Caveats:ovirt-node does not perform revocation check.

### log-collector--SSH-->hosts

Uses the same method and keys of ovirt-engine to access hosts.

## Expiration

| Component           | Default  | Configuration                                  |
|---------------------|----------|------------------------------------------------|
| Engine internal CA  | 15 years |                                                |
| Engine Certificates | 15 years |                                                |
| VDSM Certificates   | 5 years  | VdsCertificateValidityInYears at engine config |

## File locations

### ovirt-engine

All files are relative to /etc/pki/ovirt-engine.

| Component                 | File                            | Description                                                                                                 | Notes                                                                                                                                                     |
|---------------------------|---------------------------------|-------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Engine internal CA        | ca.pem                          | Certificate pem encoded.                                                                                    |
|                           | private/ca.pem                  | Internal CA private key **SENSITIVE!**                                                                      |
| Apache artifacts          | apache-ca.pem                   | Apache trusted CA, by default same as ca.pem                                                                |
|                           | keys/apache.p12                 | Key bundle                                                                                                  |
|                           | keys/apache.key.nopass          | Extracted from keys/apache.p12 used by mod_ssl                                                             | Can be replaced by 3rd party certificate by apache configuration, do not override this file.                                                              |
|                           | certs/apache.cer                | Extracted from keys/apache.p12 used by mod_ssl                                                             | Can be replaced by 3rd party certificate by apache configuration, do not override this file.                                                              |
| Engine artifacts          | keys/engine.p12                 | used by engine for ssh and ssl authentication against hosts and vdsm, also used to encrypt database fields. |
|                           | keys/engine_id_rsa            | Extracted from keys/engine.p12 used by various components that should not access private key.               |
|                           | certs/engine.cer                | Extracted from keys/engine.p12 used by log-collector.                                                       |
|                           | .truststore                     | JKS containing trusted certificate authorities for engine.                                                  |
| Jboss artifacts           | keys/jboss.p12                  | Used for jboss ssl in ovirt-engine-3.2, for debug only at ovirt-engine-3.3                                  |
| websocket-proxy artifacts | keys/websocket-proxy.p12        | Key bundle                                                                                                  |
| websocket-proxy artifacts | keys/websocket-proxy.key.nopass | Extracted from keys/websocket-proxy.p12 as python does not know how to work with PKCS#12.                  | Can be overridden by 3rd party certificate key by /etc/ovirt-engine/ovirt-websocket-proxy.conf.d/20-pki.conf::SSL_KEY.                                   |
| websocket-proxy artifacts | certs/websocket-proxy.cer       | Extracted from keys/websocket-proxy.p12 as python does not know how to work with PKCS#12.                  | Can be overridden by 3rd party certificate chain (end certificate first) by /etc/ovirt-engine/ovirt-websocket-proxy.conf.d/20-pki.conf::SSL_CERTIFICATE. |

### vdsm

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

## Services

### ovirt-engine

Servlet:

      /ovirt-engine/services/pki-resource?resource=RESOURCE&format=FORMAT

#### RESOURCE

*   ca-certificate
*   engine-certificate

#### FORMAT

*   X509-PEM
*   X509-PEM-CA
*   OPENSSH-PUBKEY

## Caveats

*   Internal engine CA does not support revocation.
*   Engine does not allow certificate management, for example revocation of hosts that are removed.
*   Engine/vdsm do not support renewal protocol of certificates.
*   vdsm does not support revocation protocol (crl, ocsp), engine (java) support is not enabled.
*   Unsupported installation of internal CA on separate computer.
*   No protocol for CA interaction to allow using different CA implementations.
*   Certificate of database encryption should be separate certificate.
*   Certificate of spice SSL should be separate certificate.
*   Engine does not validate vdsm's certificate's name to match remote address.
*   vdsm does not validate peer certificate name, nor revocation.
*   vdsClient does not validate peer certificate name nor revocation.

## See Also

*   [Features/PKIReduce](/develop/release-management/features/infra/pkireduce/)

Author: --Alon Bar-Lev (Alonbl)  02:24, 1 July 2014 (GMT)

