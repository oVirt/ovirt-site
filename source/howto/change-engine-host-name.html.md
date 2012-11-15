---
title: How to change engine host name
category: howto
authors: adrian15, daejohnson, jbrooks, jhernand, sven
wiki_title: How to change engine host name
wiki_revision_count: 8
wiki_last_updated: 2014-01-29
---

# How to change engine host name

**Manual procedure to change the host name of the machine where the engine runs (in release 3.1):**

*copied from ovirt user list thread at:* <http://lists.ovirt.org/pipermail/users/2012-October/004167.html>

0. Make a backup copy of the /etc/pki/ovirt-engine directory.

1. Regenerate the engine certificate signing request preserving the existing private key (this is very important in order to avoid having to decrypt/encrypt passwords stored in the database):

    openssl req \
    -new \
    -subj '/C=US/O=Example Inc./CN=f17.example.com' \
    -key /etc/pki/ovirt-engine/keys/engine_id_rsa \
    -out /etc/pki/ovirt-engine/requests/engine.req

Replace "Example Inc." with the value that you provided during the installation. If you don't forgot them they can be extracted from the current engine certificate:

    openssl x509 \
    -in /etc/pki/ovirt-engine/certs/engine.cer \
    -noout \
    -subject

And \*VERY IMPORTANT\*, replace "f17.example.com" with the new fully qualified host name.

2. Sign again the engine certificate, to simplify this the SignReq.sh script should be used:

    cd /etc/pki/ovirt-engine
    ./SignReq.sh \
    engine.req \
    engine.cer \
    1800 \
    /etc/pki/ovirt-engine \
    `date -d yesterday +%y%m%d%H%M%S+0000` \
    NoSoup4U

Double check that the generated certificate is correct, visually and with the following command:

    openssl verify \
    -CAfile /etc/pki/ovirt-engine/ca.pem \
    /etc/pki/ovirt-engine/certs/engine.cer

3. Generate also a DER encoded version of the certificate:

    openssl x509 \
    -in /etc/pki/ovirt-engine/certs/engine.cer \
    -out /etc/pki/ovirt-engine/certs/engine.der \
    -outform der

4. Export the engine private key and certificate to a PKCS12 file:

    openssl pkcs12 \
    -export \
    -name engine \
    -inkey /etc/pki/ovirt-engine/keys/engine_id_rsa \
    -in /etc/pki/ovirt-engine/certs/engine.cer \
    -out /etc/pki/ovirt-engine/keys/engine.p12 \
    -passout pass:NoSoup4U

5. Regenerate the keystore used by the engine, importing the old CA certificate and the new engine certificate:

    rm -f /etc/pki/ovirt-engine/.keystore

    keytool \
    -keystore /etc/pki/ovirt-engine/.keystore \
    -import \
    -alias cacert \
    -storepass mypass \
    -noprompt \
    -file /etc/pki/ovirt-engine/ca.pem

    keytool \
    -keystore /etc/pki/ovirt-engine/.keystore \
    -importkeystore \
    -srckeystore /etc/pki/ovirt-engine/keys/engine.p12 \
    -srcalias engine \
    -srcstoretype PKCS12 \
    -srcstorepass NoSoup4U \
    -srckeypass NoSoup4U \
    -destalias engine \
    -deststorepass mypass \
    -destkeypass mypass

6. Restart the httpd and ovirt-engine services:

    service ovirt-engine restart
    service httpd restart

7. If using ovirt-node as the hypervisors then for each of then check and fix the "vdc_host_name" parameter in the "/etc/vdsm-reg/vdsm-reg.conf" file.

Note that this procedure will leave a small trace: the CA certificate will still contain the URL of the old host. That is a minor inconvenience, but to solve it \*all\* certificates would need to be replaced.

8. Edit the "/etc/ovirt-engine/web-conf.js" file and replace the old host name with the new one. This is used to generate the links in the landing page.

9. You may find some references to the old domain name in entries in the option_id table. Particularly, VdcBootStrapUrl and VirtualMachineDomainName. *I do not know the implications, but it can't not hurt to clean them up. Can it? --[user:daejohnon:daej]*

10. You may find references to the old domain name in the storage_server_connections table if you had, for example, a ISO storage domain setup on the engine. Editing such entries manually and restarting the engine will clear things up and stop any related warnings when activating hosts that are trying to access the old domain name.
