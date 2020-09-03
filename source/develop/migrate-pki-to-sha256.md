---
title: Migrate PKI to SHA256 signatures Howto
category: howto
toc: true
---

# Migrate PKI to SHA256 signatures Howto

## Summary

oVirt 4.1, on new setups, creates PKI infrastructure that uses SHA256 signatures.

Existing setups upgraded to 4.1 do not currently have PKI migrated.

This Howto explains how to manually migrate the PKI of such setups
to use SHA256 signatures.

## Background

Previous versions of oVirt used SHA-1 for signatures of SSL certificates
created by the internal CA. This is no longer considered secure, see e.g.
[Firefox](https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/)
[Chrom](https://security.googleblog.com/2016/11/sha-1-certificates-in-chrome.html)
[Edge/IE](https://blogs.windows.com/msedgedev/2016/11/18/countdown-to-sha-1-deprecation/)
or [shattered.io](https://shattered.io/).

See [Features/PKI](/develop/release-management/features/infra/pki.html) for general
details about PKI in oVirt.

If you are worried only by a recent browser warning about or rejecting your
SHA-1-signed certificate, it might be enough to only re-sign the apache certificate,
or only the CA+apache certificates. This procedure was only tested currently in
its entirety.

## Change the default

This step is not needed on >= 4.1.

On < 4.1, upgrading to a newer < 4.1 version (e.g. 4.0.6 to 4.0.7) might revert
this change, so you need to repeat it per each upgrade until 4.1.

On the engine machine, run these commands:

```sh
# Backup exiting conf
cp -p /etc/pki/ovirt-engine/openssl.conf /etc/pki/ovirt-engine/openssl.conf."$(date +"%Y%m%d%H%M%S")"

# Edit it to default to SHA256
sed -i 's/^default_md = sha1/default_md = sha256/' /etc/pki/ovirt-engine/openssl.conf
```

## Re-sign CA cert

If you only use this procedure because your browser warns/rejects, then it
might be enough to skip this part. If your browser requires both the CA cert
and the https cert to have SHA256 signatures, you have to complete it.

On the engine machine, run these commands:

```sh
# Backup CA cert
cp -p /etc/pki/ovirt-engine/private/ca.pem /etc/pki/ovirt-engine/private/ca.pem."$(date +"%Y%m%d%H%M%S")"

# Create a new cert into ca.pem.new
openssl x509 -signkey /etc/pki/ovirt-engine/private/ca.pem -in /etc/pki/ovirt-engine/ca.pem -out /etc/pki/ovirt-engine/ca.pem.new -days 3650 -sha256

# Replace the existing with the new one
/bin/mv /etc/pki/ovirt-engine/ca.pem.new /etc/pki/ovirt-engine/ca.pem
```

## Re-sign certs for engine side entities

### Choose entities to re-sign

Decide what you want, among the options below:

If only apache httpd (for browsers that reject SHA1 signatures), run:

```sh
names="apache"
```

If also the engine cert:

```sh
names="apache engine"
```

If all normally-existing entities:

```sh
names="engine apache websocket-proxy jboss imageio-proxy"
```

If you [replaced the https cert](/documentation/administration_guide/#Replace)
with a cert signed by a 3rd party, you should not include "apache" in above - e.g.
use one of:

```sh
names="engine"
# or
names="engine websocket-proxy jboss imageio-proxy"
```

### Enter Maintenance

If this is a self-hosted-engine, move it to global maintenance.

### Re-sign

Run this (in the same terminal of previous subsection above):

```sh
for name in $names; do
	subject="$(openssl x509 -in /etc/pki/ovirt-engine/certs/"${name}".cer -noout -subject | sed 's;subject= \(.*\);\1;')"
	/usr/share/ovirt-engine/bin/pki-enroll-pkcs12.sh --name="${name}" --password=mypass --subject="${subject}" --keep-key
done
```

### Restart services

If you included apache:

```sh
systemctl restart httpd
```

If you included engine:

```sh
systemctl restart ovirt-engine
```

If you included ovirt-websocket-proxy/ovirt-imageio-proxy:

```sh
systemctl restart ovirt-websocket-proxy

systemctl restart ovirt-imageio-proxy
```

### Exit maintenance

If this is a self-hosted-engine, exit global maintenance.

### Reconnect to web admin

Your browser will likely refuse to continue working with the web admin ui.
You might need to restart it and/or remove the engine cert and/or engine ca cert.

In my own case I unchecked "Permanently store this exception" when I first
logged in, and after restarting httpd the browser showed an error about using
the same serial number. Restarting the browser was enough to login again.

## Enroll Certificates for hosts

For all of your hosts, one host at a time, using the web admin ui:

* Set it to Maintenance

* Choose "Enroll Certificates"

* Activate

## Verify

You can do this step at any time, also before starting this procedure.

Certs that use SHA1 will show as having 'sha1WithRSAEncryption'.
Certs that use SHA256 will show as having 'sha256WithRSAEncryption'.

On engine machine:

```sh
openssl x509 -in /etc/pki/ovirt-engine/ca.pem -text | grep Signature
for name in engine apache websocket-proxy jboss imageio-proxy; do echo $name:; openssl x509 -in /etc/pki/ovirt-engine/certs/"${name}".cer -text | grep Signature; done
```

On hosts:

```sh
openssl x509 -in /etc/pki/vdsm/certs/vdsmcert.pem -text | grep Signature
openssl x509 -in /etc/pki/vdsm/certs/cacert.pem -text | grep Signature
```

