# Installing a Websocket Proxy on a Separate Machine

The websocket proxy allows users to connect to virtual machines via noVNC and SPICE HTML5 consoles. The noVNC client uses websockets to pass VNC data. However, the VNC server in QEMU does not provide websocket support, therefore a websocket proxy must be placed between the client and the VNC server. The proxy can run on any machine that has access to the network, including the the Manager machine. 

For security and performance reasons, users may want to configure the websocket proxy on a separate machine.

**Note:** SPICE HTML5 support is a Technology Preview feature. Technology Preview features are not fully supported under Red Hat Subscription Service Level Agreements (SLAs), may not be functionally complete, and are not intended for production use. However, these features provide early access to upcoming product innovations, enabling customers to test functionality and provide feedback during the development process. 

This section describes how to install and configure the websocket proxy on a separate machine that does not run the Manager. See [Red Hat Enterprise Virtualization Manager Configuration Overview](Red_Hat_Enterprise_Virtualization_Manager_Configuration_Overview) for instructions on how to configure the websocket proxy on the Manager.

**Installing and Configuring a Websocket Proxy on a Separate Machine**

1. Install the websocket proxy:

        # yum install ovirt-engine-websocket-proxy

2. Run the `engine-setup` command to configure the websocket proxy.

        # engine-setup

    **Note:** If the `rhevm` package has also been installed, choose `No` when asked to configure the engine on this host.

3. Press **Enter* to allow `engine-setup` to configure a websocket proxy server on the machine.

        Configure WebSocket Proxy on this machine? (Yes, No) [Yes]:

4. Press **Enter** to accept the automatically detected hostname, or enter an alternative hostname and press **Enter**. Note that the automatically detected hostname may be incorrect if you are using virtual hosts:

        Host fully qualified DNS name of this server [host.example.com]: 

5. Press **Enter** to allow `engine-setup` to configure the firewall and open the ports required for external communication. If you do not allow `engine-setup` to modify your firewall configuration, then you must manually open the required ports.

        Setup can automatically configure the firewall on this system.
        Note: automatic configuration of the firewall may overwrite current settings.
        Do you want Setup to configure the firewall? (Yes, No) [Yes]:

6. Enter the fully qualified DNS name of the Manager machine and press **Enter**.

        Host fully qualified DNS name of the engine server []: engine_host.example.com

7. Press **Enter** to allow `engine-setup` to perform actions on the Manager machine, or press **2** to manually perform the actions.

        Setup will need to do some actions on the remote engine server. Either automatically, using ssh as root to access it, or you will be prompted to manually perform each such action.
         Please choose one of the following:
        1 - Access remote engine server using ssh as root
        2 - Perform each action manually, use files to copy content around
        (1, 2) [1]:

    1. Press **Enter** to accept the default SSH port number, or enter the port number of the Manager machine.

            ssh port on remote engine server [22]:           

    2. Enter the root password to log in to the Manager machine and press **Enter**.

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

    Instructions are provided to configure the Manager machine to use the configured websocket proxy.

        Manual actions are required on the engine host
        in order to enroll certs for this host and configure the engine about it.
         
        Please execute this command on the engine host: 
           engine-config -s WebSocketProxy=host.example.com:6100
        and than restart the engine service to make it effective

10. Log in to the Manager machine and execute the provided instructions.

        # engine-config -s WebSocketProxy=host.example.com:6100
        # systemctl restart ovirt-engine.service
