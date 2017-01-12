# Installing and Configuring a Squid Proxy

**Summary**

This section explains how to install and configure a Squid proxy to the User Portal. A Squid proxy server is used as a content accelerator. It caches frequently-viewed content, reducing bandwidth and improving response times.

**Configuring a Squid Proxy**

1. Obtain a keypair and certificate for the HTTPS port of the Squid proxy server. You can obtain this keypair the same way that you would obtain a keypair for another SSL/TLS service. The keypair is in the form of two PEM files which contain the private key and the signed certificate. For this procedure, we assume that they are named `proxy.key` and `proxy.cer`.

    **Note:** The keypair and certificate can also be generated using the certificate authority of the engine. If you already have the private key and certificate for the proxy and do not want to generate it with the engine certificate authority, skip to the next step.

2. Choose a host name for the proxy. Then, choose the other components of the distinguished name of the certificate for the proxy.

    **Note:** It is good practice to use the same country and same organization name used by the engine itself. Find this information by logging in to the machine where the Manager is installed and running the following command:

        # openssl x509 -in /etc/pki/ovirt-engine/ca.pem -noout -subject

    This command outputs something like this:

        subject= /C=US/O=Example Inc./CN=engine.example.com.81108

    The relevant part here is `/C=US/O=Example Inc.`. Use this to build the complete distinguished name for the certificate for the proxy:

        /C=US/O=Example Inc./CN=proxy.example.com

3. Log in to the proxy machine and generate a certificate signing request:

        # openssl req -newkey rsa:2048 -subj '/C=US/O=Example Inc./CN=proxy.example.com' -nodes -keyout proxy.key -out proxy.req

    **Important:** You must include the quotes around the distinguished name for the certificate. The `-nodes` option ensures that the private key is not encrypted; this means that you do not need to enter the password to start the proxy server.

    The command generates two files: `proxy.key` and `proxy.req`. `proxy.key` is the private key. Keep this file safe. `proxy.req` is the certificate signing request. `proxy.req` does not require any special protection.

4. To generate the signed certificate, copy the certificate signing request file from the proxy machine to the Manager machine:

        # scp proxy.req engine.example.com:/etc/pki/ovirt-engine/requests/.

5. Log in to the Manager machine and sign the certificate:

        # /usr/share/ovirt-engine/bin/pki-enroll-request.sh --name=proxy --days=3650 --subject='/C=US/O=Example Inc./CN=proxy.example.com'

    This signs the certificate and makes it valid for 10 years (3650 days). Set the certificate to expire earlier, if you prefer.

6. The generated certificate file is available in the directory `/etc/pki/ovirt-engine/certs` and should be named `proxy.cer`. On the proxy machine, copy this file from the Manager machine to your current directory:

        # scp engine.example.com:/etc/pki/ovirt-engine/certs/proxy.cer .

7. Ensure both `proxy.key` and `proxy.cer` are present on the proxy machine:

        # ls -l proxy.key proxy.cer

8. Install the Squid proxy server package on the proxy machine:

        # yum install squid

9. Move the private key and signed certificate to a place where the proxy can access them, for example to the `/etc/squid` directory:

        # cp proxy.key proxy.cer /etc/squid/.

10. Set permissions so that the `squid` user can read these files:

        # chgrp squid /etc/squid/proxy.*
        # chmod 640 /etc/squid/proxy.*

11. The Squid proxy must verify the certificate used by the engine. Copy the Manager certificate to the proxy machine. This example uses the file path `/etc/squid`:

        # scp engine.example.com:/etc/pki/ovirt-engine/ca.pem /etc/squid/.

    **Note:** The default CA certificate is located in `/etc/pki/ovirt-engine/ca.pem` on the Manager machine.

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

16. Connect to the User Portal using the complete URL, for instance:

        https://proxy.example.com/UserPortal/org.ovirt.engine.ui.userportal.UserPortal/UserPortal.html

    **Note:** Shorter URLs, for example `https://proxy.example.com/UserPortal`, will not work. These shorter URLs are redirected to the long URL by the application server, using the 302 response code and the Location header. The version of Squid in Red Hat Enterprise Linux does not support rewriting these headers.

**Note:** Squid Proxy in the default configuration will terminate its connection after 15 idle minutes. To increase the amount of time before Squid Proxy terminates its idle connection, adjust the `read_timeout` option in `squid.conf` (for instance `read_timeout 10 hours`).
