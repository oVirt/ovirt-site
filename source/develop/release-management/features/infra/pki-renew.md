---
title: PKI Renew
category: feature
authors: didi
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

See also: [BZ 1449084](https://bugzilla.redhat.com/show_bug.cgi?id=1449084)

Since 4.1.4, engine-setup checks subjectAltName existence on upgrades, and if missing,
prompts, suggesting to renew the PKI. 

See also: [BZ 1450293](https://bugzilla.redhat.com/show_bug.cgi?id=1450293)

## lifespan

Since 4.4.3, certificates are generated with a lifespan of 398 days.

See also: [BZ 1824103](https://bugzilla.redhat.com/show_bug.cgi?id=1824103)

Since 4.4.5, engine-setup prompts, suggesting to renew certificates, if any certificate
has a lifespan of more than 398 days. Also, the time-to-expire causing a prompt was
lowered from one year to 60 days.

See also: [BZ 1906320](https://bugzilla.redhat.com/show_bug.cgi?id=1906320)

Since 4.4.7, engine-setup prompts, suggesting to renew the certificate, with the same
conditions, also when ran on a machine with grafana configured, separately from the engine.

See also: [BZ 1849685](https://bugzilla.redhat.com/show_bug.cgi?id=1849685)
