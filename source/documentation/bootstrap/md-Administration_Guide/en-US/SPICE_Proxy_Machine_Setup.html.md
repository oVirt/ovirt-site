# SPICE Proxy Machine Setup

This procedure explains how to set up a machine as a SPICE Proxy. A SPICE Proxy makes it possible to connect to the Red Hat Virtualization network from outside the network. We use Squid in this procedure to provide proxy services.

**Installing Squid on Red Hat Enterprise Linux**

1. Install Squid on the Proxy machine:

        # yum install squid

2. Open `/etc/squid/squid.conf`. Change:

        http_access deny CONNECT !SSL_ports

    to:

        http_access deny CONNECT !Safe_ports

3. Start the proxy:

        # service squid start

4. Open the default squid port:

        # iptables -A INPUT -p tcp --dport 3128 -j ACCEPT

5. Make this iptables rule persistent:

        # service iptables save

You have now set up a machine as a SPICE proxy. Before connecting to the Red Hat Virtualization network from outside the network, activate the SPICE proxy.
