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
feature_status: tbd
---

# WebSocketProxy on a separate host

### Summary

The aim of this feature is to enhance the engine setup being able to install and configure the WebSocketProxy on a second machine, where engine does not run, in a fully automated way.

### Owner

*   Name: [ Simone Tiraboschi](User:stirabos)

<!-- -->

*   Email: <stirabos@redhat.com>

### Current status

*   To be discussed

### Detailed Description

The noVNC client used for VM web console utilizes websockets for passing VNC data. However, VNC server in qemu doesn't support websockets natively and there must be a websocket proxy placed between the client and VNC server. This proxy can run either on any node that has access to the host network but, currently, the engine-setup is only able to install and configure the WebSocketProxy on the node that runs the engine.

It's currently already possible run the WebSocketProxy on a separate host but it requires a manual procedure [1](http://www.ovirt.org/Features/noVNC_console#Setup_Websocket_Proxy_on_a_Separate_Machine). What we are proposing will automate the setup process so it will be configurable just using engine-setup command. The engine-setup process will be updated asking (both in the interactive way and in the answer file) for the details (fqdn, port) of the machine that will run the WebSocketProxy.

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
