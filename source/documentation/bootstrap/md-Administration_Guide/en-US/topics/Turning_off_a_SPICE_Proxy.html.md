# Turning Off a SPICE Proxy

This procedure explains how to turn off (deactivate) a SPICE proxy.

**Turning Off a SPICE Proxy**

1. Log in to the Manager:

        $ ssh root@[IP of Manager]

2. Run the following command to clear the SPICE proxy:

        # engine-config -s SpiceProxyDefault=""

3. Restart the Manager:

        # service ovirt-engine restart

SPICE proxy is now deactivated (turned off). It is no longer possible to connect to the Red Hat Virtualization network through the SPICE proxy.
