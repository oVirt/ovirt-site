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

The aim of this feature is to make it possible to connect to VM consoles using HTML 5 VNC client called "noVNC" in browsers supporting websockets and HTML5 postMessage function (webkit browsers, Firefox, IE > 9).

### Status

*   Engine part of implementation (loading noVNC client and making it connect to websocket proxy using postMessage) - PREPARING FOR REVIEW
*   Websockets proxy customization - DONE
*   Security over TLS - DONE

### Benefit to oVirt

*   enhancing the possibilities of connecting to the console in oVirt
*   there is no need to have native VNC client installed when using noVNC

### Details

The noVNC client utilizes websockets for passing VNC data. However, VNC server in qemu doesn't support websockets natively and there must be a websocket proxy placed between the client and VNC server. This proxy can run either on any node that has access to the host network, or it can run on each host. Our implementation ensures both ways are possible.

      (Note: There is a patch that integrates websockets directly to qemu, but it will not be merged into DS at the time we need it to be there. As soon as it's merged, we should switch to using this  feature instead of standalone websockets server).

The noVNC client is a html5 page with javascript which talks to websocket server (python-websockify). This page is served by the websocket server.

Upon establishing the VNC session, the noVNC client (HTML + js) must know where to connect. For passing such information, the HTML5 window.postMessage function can be used. As soon as the client receives the information, it connects to websockets proxy (and passes appopriate information to it via cookies).

The websockets proxy reads data from cookies and establishes connection to the VNC server.

### noVNC client and python-websockify customization

There are two changes that must be made to noVNC client and websockify.

#### noVNC client changes

For our purposes, the noVNC client html page must listen to VNC information passed from the engine using HTML5 postMessage. This requires adding event listener "message" to the page. The handler receives information required for establishing VNC connection via websockets and passes it to websockets proxy. This information is:

*   vnc websockets proxy host:port
*   vnc host:port
*   vnc password (ticket)

The implementation modifies vnc_auto.html page that comes from noVNC client.

#### websockify changes

The implementation is based on nova-novnc proxy which reads a token from a cookie, makes an rpc call to the nova consoleauth node and retrieves all connection information (which is connected to this token).

In VDSM we have no such thing as nova token. We must pass all the connection info in the cookie. This information is:

*   vnc host:port
*   password(ticket)

After the proxy receives the data, it establishes the vnc connection.

### Schema

TODO tbd

### Location of the websockets server

There are three possible places where the websocket server can run:

1.  On the machine where engine runs
2.  On single machine outside engine internal network (FWs would still apply)
3.  On each host

The implementation support each of these scenarios, the behavior in the engine is set in vdc_options.

### Security considerations

The websocket server runs on a specific port and allows clients to connect to any port on its machine. This is potential security risk (the attacker could bypass the firewall on server). For further info see <https://github.com/kanaka/noVNC/issues/49>. OpenStack implements customized version of the proxy (openstack-nova-novncproxy package) and verifies the security related information before connection to the target host is actually created. With oVirt this is not easily possible since we don't store the VNC ticket in the engine (afaik the only place in the system with knowledge of the ticket, is the target host), so the verification is impossible. This has to be discussed.

(Maybe the alternative would be to run the websockets server on a separate machine (point #3 in previous paragraph -- TODO add a link) and configure the FW to restrict connections from this machine to hosts and ports that conform to VNC endpoints).

In any case, the websocket proxy must have restricted access to hosts (only allow access to ports that conform to VNC).

### Secure communication

Secure communication is ensured by using TLS. For this reason, websockets server must posses a key and certificate of a server that serves the noVNC client files. The current implementation FORBIDS insecure communication which implies that the websockets proxy instance(s) must be aware of some key/cert pair (which is not protected by a password [e.g.] VDSM key/cert pair).

The distribution of the key/certificate must be discussed, it depends on the where are the client files served from:

*   Client is served the engine/other (single) machine
    -   In this case the key/cert of the engine can be used. In this case the key/cert must be pulled out of the engine's keystore.

      Note the websocket proxy assumes the key/cert pair to be in PEM without password protection.

*   Client is served from hosts
    -   In this case each host runs its own websockets proxy which serves the client
    -   The vdsm certificate (in PEM format) could be used for websocket proxy.

### Downloads

TODO add tarball

<Category:Feature>
