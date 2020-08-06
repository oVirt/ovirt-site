---
title: HostDeployProtocol
category: feature
authors: alonbl
---

# Host Deploy Protocol

HTTP based protocol, using GET method and query parameters.

URL

      /ovirt-engine/services/host-register

## Common

#### Input

*   version
    -   0: Legacy is missing version field, version is 0.
    -   1: Current version.

## VERSION 0

Obsoleted, should not be used.

### Register

#### Input

*   vds_ip - Host address to register.
*   port - VDSM port within host.
*   vds_name - Host name.
*   vds_unique_id - Unique id of host.

#### Output

*   Timestamp.

== VERSION 1 (>=3.4) ==

Recommended sequence:

*   get-version in protocol version 1, make sure version >= what we support.
*   get-pki-trust - use HTTP/HTTPS insecure, allow user to confirm fingerprint, from this point use HTTPS allow only this trust.
*   get-ssh-trust - get ssh key and install at administrative user.
*   register

=== command==get-version === Get most up to date interface version.

#### Output

*   Content-Type: text-plain
*   Content: version

=== command==get-pki-trust ===

#### Output

*   Internal PEM encoded CA certificate.

=== command==get-ssh-trust ===

#### Output

Engine ssh public key.

=== command==register ===

#### Input

*   address - Host address to register, default request origin.
*   sshPort - SSH port within host, default 22.
*   sshKeyFingerprint - Host's SSH key fingerprint, default insecure.
*   sshUser - SSH user to use, default root.
*   vdsPort - VDSM port within host, default 54321.
*   name - Host name, default address.
*   uniqueId - Unique id of host.

#### Output

'OK'

== VERSION 2 (>=4.0) ==

Recommended sequence:

*   get-version in protocol version 1, make sure version >= what we support.
*   get-pki-trust - use HTTP/HTTPS insecure, allow user to confirm fingerprint, from this point use HTTPS allow only this trust.
*   get-ssh-trust - get ssh key and install at administrative user.
*   register

=== command==get-version === Get most up to date interface version.

#### Output

*   Content-Type: text-plain
*   Content: version

=== command==get-pki-trust ===

#### Output

*   Internal PEM encoded CA certificate.

=== command==get-ssh-trust ===

#### Output

Engine ssh public key.

=== command==register ===

#### Input

*   address - Host address to register, default request origin.
*   sshPort - SSH port within host, default 22.
*   sshPublicKey - Host's SSH public key, default insecure.
*   sshUser - SSH user to use, default root.
*   vdsPort - VDSM port within host, default 54321.
*   name - Host name, default address.
*   uniqueId - Unique id of host.

#### Output

'OK'

Author: Alon Bar-Lev
