---
title: Squid Reverse Proxy
authors: jhernand
---

<!-- TODO: Content review -->

# Squid Reverse Proxy

## Introduction

This documents describes how to configure a Squid reverse proxy server for the user portal.

## Steps

### Obtain a key pair and certificate for the HTTPS port of the Squid proxy server

You can obtain this keypair as you are used to for other SSL/TLS services, the end result should be a couple of PEM files containing the private key and the signed certificate. In this document we assume that they are named `proxy.key` and `proxy.cer`.

The key pair and certificate can also optionally be generated using the certificate authority of the oVirt engine. If you already have the private key and certificate for the proxy and don't wish to generate it with the oVirt engine certificate authority then you can skip to the next step.

If you wish to use the oVirt engine then first you need to decide what will be the host name of the proxy as seen by users. Lets assume that it will be `proxy.example.com`.

Next you will need to decide what will be the rest of the distinguished name of the certificate for the proxy. The really important part here is the *common name*, it shold contain the host name of the proxy, as the browsers of the users will use it to verify the validity of the connection. The rest is not critical, but it is good idea to use the same country and organization name used by the oVirt engine itself, you can find this loging to the oVirt engine machine and running the following command:

    [root@engine ~]# openssl x509 \
      -in /etc/pki/ovirt-engine/ca.pem \
      -noout \
      -subject

This command will output something like this:

    subject= /C=US/O=Example Inc./CN=engine.example.com.81108

The interesting part here is `/C=us/O=Example Inc.`, you can use it to build the complete distinguished name for the certificate for the proxy:

    /C=US/O=Example Inc./CN=proxy.example.com

Now that you have the distinguised name you can login to the proxy machine and generate a certificate signing request:

    [root@proxy ~]# openssl req \
      -newkey rsa:2048 \
      -subj '/C=US/O=Example Inc./CN=proxy.example.com' \
      -nodes \
      -keyout proxy.key \
      -out proxy.req

Note that the quotes around the distinguised name for the certificate are very important, as it may contain spaces, don't skip them.

The command will generate the key pair. It is very importnat that the private key isn't encrypted (that is the effect of the `-nodes` option) because otherwise you would need to type the password to start the proxy server.

The output of the command should be something like this:

    Generating a 2048 bit RSA private key
    ......................................................+++
    .................................................................................+++
    writing new private key to 'proxy.key'
    -----

If successful the command will generate two files: `proxy.key` and `proxy.req`. The first one is the private key, it is very important to keep this file safe, so make sure that it has the minium persions needed and if possible don't move it out of the proxy machine, unless you want to make backup in a really safe place. The second one is the certificate signing request, this doesn't need any special protection.

Now, in order to generate the signed certificate you will need to copy the private.csr file to the oVirt engine machine, using the `scp` command or any other tool:

    [root@proxy ~]# scp \
      proxy.req \
      engine.example.com:/etc/pki/ovirt-engine/requests/.

Login to the oVirt engine machine and run the following command to sign the certificate:

    [root@engine ~]# /usr/share/ovirt-engine/bin/pki-enroll-request.sh \
      --name=proxy \
      --days=3650 \
      --subject='/C=US/O=Example Inc./CN=proxy.example.com'

This will sign the certificate and make it valid for 10 years (3650 days), you may want to make the certificate expire earlier.

The output of the command should be something like this:

    Using configuration from openssl.conf
    Check that the request matches the signature
    Signature ok
    The Subject's Distinguished Name is as follows
    countryName           :PRINTABLE:'US'
    organizationName      :PRINTABLE:'Example Inc.'
    commonName            :PRINTABLE:'proxy.example.com'
    Certificate is to be certified until Jul 10 10:05:24 2023 GMT (3650
    days)

    Write out database with 1 new entries
    Data Base Updated

The generated certificate file is available in the directory `/etc/pki/ovirt-engine/certs` and should be named `proxy.cer`. You need now to copy this file to the proxy machine:

    [root@proxy ~]# scp \
      engine.example.com:/etc/pki/ovirt-engine/certs/proxy.cer \
      .

Make sure that after all this process you have both the `proxy.key` and `proxy.cer` files in the proxy machine:

    [root@proxy ~]# ls -l proxy.key proxy.cer

Should print something like this:

    -rw-r--r--. 1 root root 4902 Jul 12 12:11 proxy.cer
    -rw-r--r--. 1 root root 1834 Jul 12 11:58 proxy.key

You are now ready to install and configure the proxy server.

### Install the Squid proxy server package

Assuming a RPM/YUM based system this can be installed as follows:

    [root@proxy ~]# yum -y install squid

### Configure the Squid proxy server

First step is to copy/move the private key and signed certificate to a place where the proxy can access them, for example to the `/etc/squid` directory:

    [root@proxy ~]# cp proxy.key proxy.cer /etc/squid/.

If you have SELinux in enforcing mode then you will need to change the context of port 443 using the semanage tool, otherwise Squid won't be able to use that port:

    [root@proxy ~]# yum install -y policycoreutils-python
    [root@proxy ~]# semanage port -m -p tcp -t http_cache_port_t 443

Replace the existing Squid configuration file with the following:

    https_port 443 key=/etc/squid/proxy.key cert=/etc/squid/proxy.cer ssl-bump defaultsite=engine.example.com
    cache_peer engine.example.com parent 443 0 no-query originserver ssl sslflags=DONT_VERIFY_PEER name=engine
    cache_peer_access engine allow all
    ssl_bump allow all
    http_access allow all

### Restart the Squid proxy server

Run the following command in the proxy machine:

    [root@proxy ~]# service squid restart

### Connect to the user portal using the complete URL

To access the portal using the proxy use the following URL:

    https://proxy.example.com/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html

Note that shorter URLs, for example `https://proxy.example.com/UserPortal`, will not work. The reason is that these shorter URLs are redirected to the long URL by the application server, using the 302 response code and the Location header, and unfortunatelly the version of Squid in RHEL and Fedora (version 3.1) doesn't support rewriting these headers.
