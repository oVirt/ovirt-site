---
title: Installing a Websocket Proxy on a Separate Machine
---

# Appendix F: Installing a Websocket Proxy on a Separate Machine

The websocket proxy allows users to connect to virtual machines via noVNC and SPICE HTML5 consoles. The noVNC client uses websockets to pass VNC data. However, the VNC server in QEMU does not provide websocket support, therefore a websocket proxy must be placed between the client and the VNC server. The proxy can run on any machine that has access to the network, including the the Engine machine.

For security and performance reasons, users may want to configure the websocket proxy on a separate machine.

This section describes how to install and configure the websocket proxy on a separate machine that does not run the Engine.

**Installing and Configuring a Websocket Proxy on a Separate Machine**

1. Install the websocket proxy:

        # yum install ovirt-engine-websocket-proxy

2. Run the `engine-setup` command to configure the websocket proxy.

        # engine-setup

    **Note:** If the `rhevm` package has also been installed, choose `No` when asked to configure the engine on this host.

3. Press **Enter** to allow `engine-setup` to configure a websocket proxy server on the machine.

        Configure WebSocket Proxy on this machine? (Yes, No) [Yes]:

4. Press **Enter** to accept the automatically detected hostname, or enter an alternative hostname and press **Enter**. Note that the automatically detected hostname may be incorrect if you are using virtual hosts:

        Host fully qualified DNS name of this server [host.example.com]:

5. Press **Enter** to allow `engine-setup` to configure the firewall and open the ports required for external communication. If you do not allow `engine-setup` to modify your firewall configuration, then you must manually open the required ports.

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

6. Enter the fully qualified DNS name of the Engine machine and press **Enter**.

        Host fully qualified DNS name of the engine server []: engine_host.example.com

7. Press **Enter** to allow `engine-setup` to perform actions on the Engine machine, or press **2** to manually perform the actions.

        Setup will need to do some actions on the remote engine server. Either automatically, using ssh as root to access it, or you will be prompted to manually perform each such action.
         Please choose one of the following:
        1 - Access remote engine server using ssh as root
        2 - Perform each action manually, use files to copy content around
        (1, 2) [1]:

    i. Press **Enter** to accept the default SSH port number, or enter the port number of the Engine machine.

            ssh port on remote engine server [22]:

    ii. Enter the root password to log in to the Engine machine and press **Enter**.

            root password on remote engine server engine_host.example.com:

8. Select whether to review iptables rules if they differ from the current settings.

        Generated iptables rules are different from current ones.
        Do you want to review them? (Yes, No) [No]:

9. Press **Enter** to confirm the configuration settings.

        --== CONFIGURATION PREVIEW ==--

        Firewall manager                        : iptables
        Update Firewall                         : True
        Host FQDN                               : host.example.com
        Configure WebSocket Proxy               : True
        Engine Host FQDN                        : engine_host.example.com

        Please confirm installation settings (OK, Cancel) [OK]:

    Instructions are provided to configure the Engine machine to use the configured websocket proxy.

        Manual actions are required on the engine host
        in order to enroll certs for this host and configure the engine about it.

        Please execute this command on the engine host:
           engine-config -s WebSocketProxy=host.example.com:6100
        and than restart the engine service to make it effective

10. Log in to the Engine machine and execute the provided instructions.

        # engine-config -s WebSocketProxy=host.example.com:6100
        # systemctl restart ovirt-engine.service

**Prev:** [Appendix E: Preparing a Local Manually-Configured PostgreSQL Database](appe-Preparing_a_Local_Manually-Configured_PostgreSQL_Database) <br>
**Next:** [Appendix G: Configuring a Host for PCI Passthrough](appe-Configuring_a_Host_for_PCI_Passthrough)

[Adapted from RHV 4.2 documentation - CC-BY-SA](https://access.redhat.com/documentation/en-us/red_hat_virtualization/4.2/html/installation_guide/appe-installing_the_websocket_proxy_on_a_different_host)
