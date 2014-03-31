---
title: WebSocketProxy on a separate host
category: feature
authors: sandrobonazzola, stirabos
wiki_category: Feature|WebSocketProxy on a separate host
wiki_title: Features/WebSocketProxy on a separate host
wiki_revision_count: 29
wiki_last_updated: 2015-01-16
feature_name: WebSocketProxy on a separate host
feature_modules: websocket-proxy
feature_status: Design
---

# WebSocketProxy on a separate host

### Summary

The aim of this feature is to enhance the engine setup being able to install and configure the WebSocketProxy on a second machine, where engine does not run, in a fully automated way.

### Owner

*   Name: [ Simone Tiraboschi](User:stirabos)

<!-- -->

*   Email: <stirabos@redhat.com>

### Current status

*   Design
*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

The noVNC client used for VM web console utilizes websockets for passing VNC data. However, VNC server in qemu doesn't support websockets natively and there must be a websocket proxy placed between the client and VNC server. This proxy can run either on any node that has access to the host network but, currently, the engine-setup is only able to install and configure the WebSocketProxy on the node that runs the engine.

It's currently already possible run the WebSocketProxy on a separate host but it requires a manual procedure [1](http://www.ovirt.org/Features/noVNC_console#Setup_Websocket_Proxy_on_a_Separate_Machine). What we are proposing will automate a bit the setup process making it easier but still requiring some manual actions on both the machine.

Assumption:

*   The user still needs to install the needed RPMs on both the machine; the user have to install only the required RPMs, installing a not required RPM on one of the two machine can broken the process
*   The user still need to run engine-setup on both the machine
*   The user knows the root password of the first machine when on the second

Under this assumptions it can works this way:

### On the first node:

1.  Via yum, the user installs the required RPMs on the first machine (the engine one) ensuring to don't install ovirt-engine-websocket-proxy
2.  Then the can launch engine-setup
3.  Acknowledging that ovirt-engine-websocket-proxy RPM is not install, the engine-setup asks to the user if he/she wants to install the WebSocketProxy on a different machine.
4.  If so, the engine-setup asks for a fqdn and and port of the machine that will run the WebSocketProxy
5.  engine-setup on the first machine generates and signs also the cert for the WebSocketProxy one storing them on a well defined path: having it running on a different host with a different fdqn requires an additional SSL cert

### On the second node:

1.  Via yum user install only ovirt-engine-websocket-proxy being sure to not install ovirt-engine (if so the engine-setup will run as for an installation with the engine and the websocket-proxy on a single node)
2.  Then the can launch engine-setup
3.  Acknowledging that ovirt-engine-websocket-proxy RPM is install but ovirt-egine no, the engine-setup asks:

*   -   The fqdn of the engine node
    -   The fqdn of the WebSocketProxy (current) node
    -   The port to bind on

1.  engine-setup ask the user for the engine machine root password to download its own certs signed by the CA and also the private key with scp
2.  Than engine-setup downloads CA and engine public cert for data validation over https
3.  engine-setup configures the service editing /etc/ovirt-engine/ovirt-websocket-proxy.conf.d/10-setup.conf
4.  engine-setup starts the WebSocketProxy service

Engine setup currently asks: 'Configure websocket proxy on the machine' accepting

### Benefit to oVirt

The installation process will become easier for who needs to install the WebSocketProxy on a separate engine cause it will not require any successive manual procedure.

### Dependencies / Related Features

The WebSocketProxy is already able to run on a different host, only the engine setup should be improved to allow it being automatically configured.

### Documentation / External references

*   [RFE] Allow setup of ovirt-websocket-proxy on separate machine - [2](https://bugzilla.redhat.com/show_bug.cgi?id=1080992)
*   [RFE] rhevm-websocket-proxy - using as standalone service - automatic configuration - [3](https://bugzilla.redhat.com/show_bug.cgi?id=985945)

### Testing

A tester should perform a full oVirt installation choosing to install the WebSocketProxy on a different host. The The tester should be able to connect to any running machine via the noVNC web client.

### Comments and Discussion

*   Refer to [Talk:WebSocketProxy on a separate host](Talk:WebSocketProxy on a separate host)

<Category:Feature>
