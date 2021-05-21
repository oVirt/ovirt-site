---
title: Phoenix Lab Ssh Spice Tunnel
category: infra
authors:
  - dcaroest
  - rbarry
---

# Phoenix Lab Ssh Spice Tunnel

**NOTE**: for the latest version of this doc, see <http://ovirt-infra-docs.readthedocs.org/en/latest/>

Heres a *hacky* way to setup the tunnel for spice to be used when clicking the engine spice button on fedora based machines.

## Requirements

You'll need the following extra packages:

    $ sudo yum install -y tsocks ssh remote-viewer

*tsocks currently segfaults any application which requires encryption (ssh, ssl). You can also use proxychains*

    git clone https://github.com/rofl0r/proxychains-ng
    cd proxychains-ng
    ./configure && make && sudo make install && sudo make install-config

## Tunnel Configuration

Then you must setup the stunnel configuration like this:

    $ cat /etc/tsocks.conf
    server = 127.0.0.1
    server_port = 8181

Or, if using proxychains, edit /usr/local/etc/proxychains.conf and make sure the following stanza is set

    [ProxyList]
    socks4 127.0.0.1 8181

## Getting the Engine Certificate

Download the engine ssl certificate:

    $ openssl s_client -connect monitoring.ovirt.org:443 \
          2>/dev/null </dev/null \
      | openssl x509 > engine.cert

## Replace the remote-viewer

Now replace the remote-viewer binary by the following custom script, substituting "proxychains4" for tsocks if you're using proxychains:

    $ remote_viewer_path="$(which remote-viewer)"
    $ mv "${remote_viewer_path}"{,.orig}
    $ cat >>"$remote_viewer_path" <<EOS
    #!/bin/bash
    tsocks \
        "${remote_viewer_path}".orig \
        --spice-ca-file=engine.cert \
        "$@"
    EOS

Make sure that the certificate points to the certificate you downloaded previously.

## Starting the Tunnel

Once done that, you'll have to start the ssh tunnel (you can do it automatically form bashrc or similar):

    $ ssh -fND 8181 youruser@foreman.ovirt.org

That will start the SSH tunnel in the background with a SOCKS proxy listening on 127.0.0.1:8181, where the tsocks connections will connect to.

## Bussines as Usual

So after all this hacky setup, you'll be able to connect to any vm in the phx engine using the spice link in the UI. Hopefully that will not be needed i the future once we have a better solution (vpn?).

[oVirt Infrastructure](/develop/infra/infrastructure.html)
