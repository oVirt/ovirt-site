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

The aim of this feature is to make it possible to connect to VM consoles using HTML 5 VNC client called noVNC.

### Owner

*   Feature owner: [ Frank Kobzik](User:Fkobzik)
*   Email: fkobzik@redhat.com

### Benefit to oVirt

*   enhancing the possibilities of connecting to the console in oVirt
*   there is no need to have native VNC client installed when using noVNC

### Implementation

The noVNC client is a html5 page with javascript which talks to websocket server. This page can be rendered by the engine.

The noVNC client requires a websocket server running somewhere (this is part of the noVNC server package). This server basically redirects the websocket communication to the VNC server running on Qemu.

      (Note: There is a patch that integrates websockets directly to Qemu, but it will not be merged into DS at the time we need it to be there. As soon as it's merged, we should switch to using this feature instead of standalone websockets server).

#### Passing VNC console data from the engine to the client.

For the client to know where to connect, the appropriate information (VNC host, port, ticket) must be passed to it. This information is known by the engine after creation. It will be passed to noVNC client using js function window.postData (HTML5 spec).

#### Location of the websockets server

There are three possible places where the websocket server can run:

1.  On client (where the browser runs)
2.  On the machine where engine runs (or on some other (_single_) node)
3.  On single machine outside engine internal network (FWs would still apply)
4.  On each host

From performance POV the 4th option would be the best, however the implementation wouldn't be trivial (e.g. maintaining the lifecycle of the websockets servers). I suggest using 2nd or 3rd option for now and then switch to websockets in Qemu, when they are available.

### Security considerations

The websocket server runs on a specific port and allows clients to connect to any port on its machine. This is potential security risk (the attacker could bypass the firewall on server). For further info see <https://github.com/kanaka/noVNC/issues/49>. OpenStack implements customized version of the proxy (openstack-nova-novncproxy package) and verifies the security related information before connection to the target host is actually created. With oVirt this is not easily possible since we don't store the VNC ticket in the engine (afaik the only place in the system with knowledge of the ticket, is the target host), so the verification is impossible. This has to be discussed.

(Maybe the alternative would be to run the websockets server on a separate machine (point #3 in previous paragraph -- TODO add a link) and configure the FW to restrict connections from this machine to hosts and ports that conform to VNC endpoints).

#### Secure communication

using wss. TBD

<Category:Feature>
