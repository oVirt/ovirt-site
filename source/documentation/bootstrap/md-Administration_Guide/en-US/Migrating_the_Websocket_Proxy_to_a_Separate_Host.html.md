# Migrating the Websocket Proxy to a Separate Machine

For security or performance reasons the websocket proxy can run on a separate machine that does not run Red Hat Virtualization Manager. The procedure to migrate the websocket proxy from the Manager machine to a separate machine involves removing the websocket proxy configuration from the Manager machine, then installing the proxy on the separate machine.

The `engine-cleanup` command can be used to remove the websocket proxy from the Manager machine.

**Migrating the Websocket Proxy to a Separate Machine**

1. On the Manager machine, run `engine-cleanup` to remove the required configuration.

        # engine-cleanup

2. Type `No` when asked to remove all components and press **Enter**.

        Do you want to remove all components? (Yes, No) [Yes]: No

3. Type `No` when asked to remove the engine and press **Enter**.

        Do you want to remove the engine? (Yes, No) [Yes]: No

4. Type `Yes` when asked to remove the websocket proxy and press **Enter**.

        Do you want to remove the WebSocket proxy? (Yes, No) [No]: Yes

    Select `No` if asked to remove any other components.

5. Install and configure the proxy on the separate machine. See [Installing a Websocket Proxy on a Separate Machine](https://access.redhat.com/documentation/en/red-hat-virtualization/4.0/single/installation-guide/#appe-Installing_the_Websocket_Proxy_on_a_different_host) in the *Installation Guide* for instructions.





