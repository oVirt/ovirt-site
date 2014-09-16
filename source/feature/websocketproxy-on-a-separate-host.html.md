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

*   The user still needs to install the needed RPMs on both the machine
*   The user still need to run engine-setup on both the machine
*   This process is relative to a new install but an upgrade of ovirt-engine-websocket-proxy should not be a problem
*   The two hosts should be installed in strictly order:
    -   first the host with the engine to setup also the CA
    -   than the host with websocket-proxy

Under this assumptions it can works this way:

*   On the first node:
    1.  Via yum, the user installs the required RPMs on the first machine (the engine one)
    2.  Then he can launch engine-setup
    3.  engine-setup wil ask about engine configuration; the user should choose YES to install the engine there.

<!-- -->

*   On the second node:
    1.  Via yum user install the required RPM (yum install ovirt-engine-websocket-proxy)
    2.  Then he can launch engine-setup
    3.  If the user also installed engine rpms, engine-setup will ask about engine configuration; the user should choose NO
    4.  acknowledging that the engine is not being configured, engine-setup show instruction to configure a remote engine to talk with the websocket proxy on this host, in particular:
        1.  it shows a command to configure, on the engine host, the new websocket proxy location (via engine-config)
        2.  it supports websocket proxy cert setup proposing the required commands; it can happen in two different way:
            1.  inline: the engine setup generates and prints a CSR on the screen, the user should paste it on the engine host into a well know path, sign it, and than paste back the signed cert within engine-setup UI
            2.  file-based: not that different from the previous one, CSR is not shown on the screen but is saved into a temp file, the user should copy it to the other host in order to sign it, than ha has to copy back the signed cert file

    5.  engine-setup also asks engine fqdn in order to automatically download the engine cert

### Benefit to oVirt

The installation process will become easier for who needs to install the WebSocketProxy on a separate engine cause it will require less manual actions

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
