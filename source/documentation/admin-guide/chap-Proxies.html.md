---
title: Proxies
---

# Chapter 20: Proxies

## SPICE Proxy Overview

The SPICE Proxy is a tool used to connect SPICE Clients to virtual machines when the SPICE Clients are outside the network that connects the hypervisors. Setting up a SPICE Proxy consists of installing Squid on a machine and configuring `iptables` to allow proxy traffic through the firewall. Turning a SPICE Proxy on consists of using `engine-config` on the Engine to set the key `SpiceProxyDefault` to a value consisting of the name and port of the proxy. Turning a SPICE Proxy off consists of using `engine-config` on the Engine to remove the value to which the key `SpiceProxyDefault` has been set.

    **Important:** The SPICE Proxy can only be used in conjunction with the standalone SPICE client, and cannot be used to connect to virtual machines using SPICE HTML5 or noVNC.

### SPICE Proxy Machine Setup

This procedure explains how to set up a machine as a SPICE Proxy. A SPICE Proxy makes it possible to connect to the oVirt network from outside the network. We use Squid in this procedure to provide proxy services.

**Installing Squid on Enterprise Linux**

1. Install `Squid` on the Proxy machine:

        # yum install squid

2. Open **/etc/squid/squid.conf**. Change:

        http_access deny CONNECT !SSL_ports

   to:

        http_access deny CONNECT !Safe_ports

3. Start the proxy:

        # service squid start

4. Open the default squid port:

        # iptables -A INPUT -p tcp --dport 3128 -j ACCEPT

5. Make this iptables rule persistent:

        # service iptables save

You have now set up a machine as a SPICE proxy. Before connecting to the oVirt network from outside the network, activate the SPICE proxy.

### Turning On a SPICE Proxy

This procedure explains how to activate (or turn on) the SPICE proxy.

**Activating SPICE Proxy**

1. On the Engine, use the engine-config tool to set a proxy:

        # engine-config -s SpiceProxyDefault=someProxy

2. Restart the `ovirt-engine` service:

        # service ovirt-engine restart

    The proxy must have this form:

        protocol://[host]:[port]

    **Note:** Only SPICE clients shipped with Enterprise Linux 6.7, Enterprise Linux 7.2, or later, support HTTPS proxies. Older clients only support HTTP. If HTTPS is specified for older clients, the client will ignore the proxy setting and attempt a direct connection to the host.

SPICE Proxy is now activated (turned on). It is now possible to connect to the oVirt network through the SPICE proxy.

### Turning Off a SPICE Proxy

This procedure explains how to turn off (deactivate) a SPICE proxy.

**Turning Off a SPICE Proxy**

1. Log in to the Engine:

        $ ssh root@[IP of Engine]

2. Run the following command to clear the SPICE proxy:

        # engine-config -s SpiceProxyDefault=""

3. Restart the Engine:

        # service ovirt-engine restart

SPICE proxy is now deactivated (turned off). It is no longer possible to connect to the oVirt network through the SPICE proxy.

## Squid Proxy

### Installing and Configuring a Squid Proxy

**Summary**

This section explains how to install and configure a Squid proxy to the User Portal. A Squid proxy server is used as a content accelerator. It caches frequently-viewed content, reducing bandwidth, and improving response times.

**Configuring a Squid Proxy**

1. Obtain a keypair and certificate for the HTTPS port of the Squid proxy server. You can obtain this keypair the same way that you would obtain a keypair for another SSL/TLS service. The keypair is in the form of two PEM files which contain the private key and the signed certificate. For this procedure, we assume that they are named **proxy.key** and **proxy.cer**.

    **Note:** The keypair and certificate can also be generated using the certificate authority of the engine. If you already have the private key and certificate for the proxy and do not want to generate it with the engine certificate authority, skip to the next step.

2. Choose a host name for the proxy. Then, choose the other components of the distinguished name of the certificate for the proxy.

    **Note:** It is good practice to use the same country and same organization name used by the engine itself. Find this information by logging in to the machine where the Engine is installed and running the following command:

        # openssl x509 -in /etc/pki/ovirt-engine/ca.pem -noout -subject

    This command outputs something like this:

        subject= /C=US/O=Example Inc./CN=engine.example.com.81108

    The relevant part here is `/C=US/O=Example Inc.`. Use this to build the complete distinguished name for the certificate for the proxy:

        /C=US/O=Example Inc./CN=proxy.example.com

3. Log in to the proxy machine and generate a certificate signing request:

        # openssl req -newkey rsa:2048 -subj '/C=US/O=Example Inc./CN=proxy.example.com' -nodes -keyout proxy.key -out proxy.req

    **Important:** You must include the quotes around the distinguished name for the certificate. The `-nodes` option ensures that the private key is not encrypted; this means that you do not need to enter the password to start the proxy server.

    The command generates two files: **proxy.key** and **proxy.req**. **proxy.key** is the private key. Keep this file safe. **proxy.req** is the certificate signing request. **proxy.req** does not require any special protection.

4. To generate the signed certificate, copy the certificate signing request file from the proxy machine to the Engine machine:

        # scp proxy.req engine.example.com:/etc/pki/ovirt-engine/requests/.

5. Log in to the Engine machine and sign the certificate:

        # /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=proxy --days=3650 --subject='/C=US/O=Example Inc./CN=proxy.example.com'

    This signs the certificate and makes it valid for 10 years (3650 days). Set the certificate to expire earlier, if you prefer.

6. The generated certificate file is available in the directory **/etc/pki/ovirt-engine/certs** and should be named **proxy.cer**. On the proxy machine, copy this file from the Engine machine to your current directory:

        # scp engine.example.com:/etc/pki/ovirt-engine/certs/proxy.cer .

7. Ensure both **proxy.key** and **proxy.cer** are present on the proxy machine:

        # ls -l proxy.key proxy.cer

8. Install the Squid proxy server package on the proxy machine:

        # yum install squid

9. Move the private key and signed certificate to a place where the proxy can access them, for example to the **/etc/squid** directory:

        # cp proxy.key proxy.cer /etc/squid/.

10. Set permissions so that the `squid` user can read these files:

        # chgrp squid /etc/squid/proxy.*
        # chmod 640 /etc/squid/proxy.*

11. The Squid proxy must verify the certificate used by the engine. Copy the Engine certificate to the proxy machine. This example uses the file path **/etc/squid**:

        # scp engine.example.com:/etc/pki/ovirt-engine/ca.pem /etc/squid/.

    **Note:** The default CA certificate is located in **/etc/pki/ovirt-engine/ca.pem** on the Engine machine.

12. Set permissions so that the `squid` user can read the certificate file:

        # chgrp squid /etc/squid/ca.pem
        # chmod 640 /etc/squid/ca.pem

13. If SELinux is in enforcing mode, change the context of port 443 using the `semanage` tool to permit Squid to use port 443:

        # yum install policycoreutils-python
        # semanage port -m -p tcp -t http_cache_port_t 443

14. Replace the existing Squid configuration file with the following:

        https_port 443 key=/etc/squid/proxy.key cert=/etc/squid/proxy.cer ssl-bump defaultsite=engine.example.com
        cache_peer engine.example.com parent 443 0 no-query originserver ssl sslcafile=/etc/squid/ca.pem name=engine
        cache_peer_access engine allow all
        ssl_bump allow all
        http_access allow all

15. Restart the Squid proxy server:

        # systemctl restart squid.service

    **Note:** Squid Proxy in the default configuration will terminate its connection after 15 idle minutes. To increase the amount of time before Squid Proxy terminates its idle connection, adjust the `read_timeout` option in **squid.conf** (for instance `read_timeout 10 hours`).

## Websocket Proxy

### Websocket Proxy Overview

The websocket proxy allows users to connect to virtual machines via noVNC and SPICE HTML5 consoles. Previously, the websocket proxy could only run on the oVirt Engine machine, but now the proxy can run on any machine that has access to the network.

The websocket proxy can be installed and configured on the oVirt Engine machine during the initial configuration (see "Configuring the oVirt Engine" in the [Installation Guide](/documentation/install-guide/Installation_Guide/)), or on a separate machine (see "Installing a Websocket Proxy on a Separate Machine" in the [Installation Guide](/documentation/install-guide/Installation_Guide/)).

The websocket proxy can also be migrated from the Engine machine to a separate machine. See the "Migrating the Websocket Proxy to a Separate Machine" section below.

### Migrating the Websocket Proxy to a Separate Machine

For security or performance reasons the websocket proxy can run on a separate machine that does not run oVirt Engine. The procedure to migrate the websocket proxy from the Engine machine to a separate machine involves removing the websocket proxy configuration from the Engine machine, then installing the proxy on the separate machine.

The `engine-cleanup` command can be used to remove the websocket proxy from the Engine machine.

**Migrating the Websocket Proxy to a Separate Machine**

1. On the Engine machine, run `engine-cleanup` to remove the required configuration.

        # engine-cleanup

2. Type `No` when asked to remove all components and press **Enter**.

        Do you want to remove all components? (Yes, No) [Yes]: No

3. Type `No` when asked to remove the engine and press **Enter**.

        Do you want to remove the engine? (Yes, No) [Yes]: No

4. Type `Yes` when asked to remove the websocket proxy and press **Enter**.

        Do you want to remove the WebSocket proxy? (Yes, No) [No]: Yes

    Select `No` if asked to remove any other components.

5. Install and configure the proxy on the separate machine. See "Installing a Websocket Proxy on a Separate Machine" in the [Installation Guide](/documentation/install-guide/Installation_Guide/) for instructions.

**Prev:** [Chapter 19: Log Files](../chap-Log_Files)<br>
**Next:** [Appendix A: VDSM and Hooks](../appe-VDSM_and_Hooks)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/administration_guide/chap-proxies)
