---
title: Changing Engine Hostname
authors: didi
---

# Changing Engine Hostname

## Are you sure you need this?

Since version 4.0.4, it is possible to add more names to access the engine web interface,
see [BZ 1325746](https://bugzilla.redhat.com/1325746).

Make sure the name or names you want resolve to an IP address of the engine machine, by adding
relevant records to the DNS or to /etc/hosts, and then:

         # echo 'SSO_ALTERNATE_ENGINE_FQDNS="alias1.example.com alias2.example.com"' \
         > /etc/ovirt-engine/engine.conf.d/99-custom-sso-setup.conf
         # systemctl restart ovirt-engine.service

The list of alternate names has to be listed separated by spaces.

It's possible to add also IP addresses of engine host, but using IP addresses instead of DNS names is not considered to be a good practise.

## Changing the hostname of an oVirt Manager/engine

### How to

1.  Prepare relevant DNS and/or /etc/hosts records for the new name.
2.  If using DHCP, update the DHCP server's configuration.
3.  Change the hostname. This is usually done by editing /etc/hostname and rebooting. There are other options and details which are not in the scope of this document.
4.  Run the script ovirt-engine-rename:

         # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename

It's otopi-based. This means, among other things, that it looks similar engine-setup/cleanup, and provides similar logging, options, etc.

Options specific to it:

`   --newname=`<newname>

An example run, which does everything in batch and does not ask questions, if possible:

         # /usr/share/ovirt-engine/setup/bin/ovirt-engine-rename \
         --newname=ovirte1n.home.local \
         --otopi-environment="OSETUP_RENAME/forceIgnoreAIAInCA=bool:'True' \
         OVESETUP_CORE/engineStop=bool:'True' \
         OSETUP_RENAME/confirmForceOverwrite=bool:'False'"

### Discussion

When running engine-setup on a clean system, one of the things it does is create the following set of keys and certs:

1.  A CA (certificate authority) key and a self-signed cert for it
2.  A key for httpd, the admin web server, and a CA-signed certificate for it. This is used for https access to the admin site.
3.  A key for the engine, the jboss application managing the oVirt database and system, and a CA-signed certificate for it.

All three certificates (CA, httpd, engine) are for the Common Name (CN) whose value is the hostname entered during engine-setup, which is supposed to be the hostname of the engine's machine, exist in the dns (forward and reverse records), and point to an IP address of the engine's machine.

Later, when adding hosts to oVirt, these hosts also get certificates signed by the CA. The engine and VDSM can thus verify each others' identity.

Currently, the script ovirt-engine-rename does not touch the CA's or the engine's certificate. It does create a new certificate for the httpd web server. This means that when you rename the host using this script, and then login using the admin interface to the new hostname, you'll get in your browser a certificate for the new hostname, signed by the CA, accompanied by the certificate of the CA, which is for the old hostname.

This means that if/when the old hostname is gone, it will not be possible anymore to try and verify the entire "trust path" from the root (CA) to the services - httpd and the engine. Is this a concern? For the web server, it's not too big of a concern. At most, you'll get some extra warnings from your web browser when trying to connect to the admin interface, which you can ignore.

The bigger concern is with the engine's certificate. Currently, to the best of our knowledge, there is no component that actually checks this trust. But it's possible, that in some future version of one of the relevant tools - vdsm, libvirt, etc. - such a check will actually be made, and even prevent connections. If this happens, the engine might not be able to connect to the hosts, and the worst case is that they will have to be reinstalled, thus loosing all the configuration and data accumulated by then.

Certificates can include an optional extension called Authority Information Access. In oVirt releases up to and including 3.2, the CA certificate included this extension, pointing at the engine hostname. In 3.3 and later, this extension is no longer included. Systems installed with 3.2 or before, and upgraded to 3.3, will still include this extension. That's why it's safer to rename such systems by running cleanup and setup again if possible.

See also [Features/PKI](/develop/release-management/features/infra/pki.html).
