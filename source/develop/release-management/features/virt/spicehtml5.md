---
title: SpiceHTML5
category: feature
authors: fkobzik
---

# Spice HTML5

## Summary

This feature adds spice-html5 console to the engine. spice-html5 is a spice answer to novnc webbrowser console client. spice-html5 is still a little bit experimental yet under active development. Similarly to the novnc, spice-html5 uses websockets to communicate with websocket proxy which talks directly to spice server.

## Owner

*   Name: Frank Kobzik (Fkobzik)
*   Email: <fkobzik@redhat.com>

## Design

The design, architecture and implementation is almost same as the noVNC case. That means:

*   we use same (modified) websocket proxy python-websockify
*   we make use of external package with the client (spice-html5) and slightly modified client page that is served by jboss

For more info please visit [Features/noVNC_console](/develop/release-management/features/virt/novnc-console.html)

      Note: In future the websockets support for SPICE will be implemented in QEMU. When this happens, the implementation of spice-html5 in the engine should use this feature instead of using websocket proxy.

However, there is one difference, which is worth noting - in VNC case, there is only one port which the clients connects to. With SPICE, there is secured port and unsecured one. If the client is using the secured one, it is required to pass this information to websockify. This information is passed in the url path.

## Testing

### Test case 1 - Websocket Proxy on the engine's machine

Prerequisities: Browser that has proper websockets and postmessage support (tested with FF and Chrome)

*   Install the engine and in the engine-setup answer 'Yes' to 'Configure websocket proxy on the machine'
*   Import CA of the engine in your browser
*   Set up a VM as usual, set its Display Type to SPICE and run it.
*   In Console Options dialog, select 'SPICE HTML5 browser client'
*   Click the console button to invoke the console.
    -   (The console opens in a new tab and this behavior is usualy blocked by browsers. For opening the console you must allow displaying pop-up windows from engine's domain.)

Results: The new browser tab with spice-html5 session appears.

