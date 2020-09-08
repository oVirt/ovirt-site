---
title: PKI Renew
category: feature
authors: didib
---

# PKI Renew

For a general overview of PKI in oVirt, see [Features/PKI](/develop/release-management/features/infra/pki.html).

This page documents optional changes that can be done to PKI during upgrade.

## Expiry and RFC2459 compatibility

Since 3.5.4, engine-setup checks for certificates (close/past) expiry and for
compatibility with rfc2459, and if needed, prompts the user to renew the PKI.

If the reply is 'No', engine-setup does not renew. On a later run (e.g. next upgrade),
it checks and prompts again.

See also: [3.5.4 Release Notes](/develop/release-management/releases/3.5.4/index.html#pki)

## SubjectAltName

Recent browsers (as of 2017) require the subjectAltName extension in https certificates.

Since 4.1.2, engine-setup on clean setups creates certificates that contain
this extension.

See also: [BZ 1449084](https://bugzilla.redhat.com/1449084)

Since 4.1.4, engine-setup checks subjectAltName existence on upgrades, and if missing,
prompts, suggesting to renew the PKI. 

See also: [BZ 1450293](https://bugzilla.redhat.com/1450293)

