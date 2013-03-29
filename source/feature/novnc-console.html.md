---
title: noVNC console
category: feature
authors: adahms, alonbl, fkobzik, gianluca, nkesick, stirabos
wiki_category: Feature
wiki_title: Features/noVNC console
wiki_revision_count: 38
wiki_last_updated: 2015-01-08
---

# noVNC console in oVirt

### Summary

The aim of this feature is to make it possible to connect to VM consoles using HTML 5 VNC client called "noVNC".

### Status

*   Integrating noVNC client files into engine - done
*   Websockets proxy customization - done
*   Security over TLS

### Benefit to oVirt

*   enhancing the possibilities of connecting to the console in oVirt
*   there is no need to have native VNC client installed when using noVNC

### Implementation

The noVNC client is a html5 page with javascript which talks to websocket server. This page can be rendered by the engine.

The noVNC client requires a websocket server running somewhere (this is part of the noVNC server package). This server basically redirects the websocket communication to the VNC server running on Qemu.

      (Note: There is a patch that integrates websockets directly to Qemu, but it will not be merged into DS at the time we need it to be there. As soon as it's merged, we should switch to using this feature instead of standalone websockets server).

### Passing VNC console data from the engine to the client.

For passing information that noVNC client needs for connection, a HTML5 window.postMessage function can be used.

### Location of the websockets server

There are three possible places where the websocket server can run:

1.  On the machine where engine runs
2.  On single machine outside engine internal network (FWs would still apply)
3.  On each host
4.  (On client (where the browser runs).)

From performance POV the 4th option would be the best, however the implementation wouldn't be trivial (e.g. maintaining the lifecycle of the websockets servers).

### Security considerations

The websocket server runs on a specific port and allows clients to connect to any port on its machine. This is potential security risk (the attacker could bypass the firewall on server). For further info see <https://github.com/kanaka/noVNC/issues/49>. OpenStack implements customized version of the proxy (openstack-nova-novncproxy package) and verifies the security related information before connection to the target host is actually created. With oVirt this is not easily possible since we don't store the VNC ticket in the engine (afaik the only place in the system with knowledge of the ticket, is the target host), so the verification is impossible. This has to be discussed.

(Maybe the alternative would be to run the websockets server on a separate machine (point #3 in previous paragraph -- TODO add a link) and configure the FW to restrict connections from this machine to hosts and ports that conform to VNC endpoints).

In any case, the websocket proxy must have restricted access to hosts (only allow access to ports that conform to VNC).

### Secure communication

Secure communication is ensured by using TLS. For this reason, websockets server must posses a certificate of a server that serves the noVNC client files. The distribution of the certificate must be discussed, it depends on the where are the client files served from:

*   Client is served from the engine
    -   In this case the certificate can be shared with the engine.
    -   Complication: The however uses a certificate stored in the keystore file. The proxy expects the certificate to be in the plain PEM format.
    -   Possible complication: If the websocket proxy runs on a machine that is different from the engine's machine, the cert must be transfered to it.
*   Client is served from hosts
    -   In this case each host runs its own websockets proxy which serves the client
    -   The vdsm certificate (in PEM format) could be used for websocket proxy as well.
    -   Complication: As previously mentioned - maintanance of lifecycle of the websocket proxy could be problematic.

<Category:Feature>
