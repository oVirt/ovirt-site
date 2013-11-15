---
title: SSO
category: feature
authors: alonbl
wiki_category: Feature
wiki_title: Features/SSO
wiki_revision_count: 30
wiki_last_updated: 2014-07-01
---

# SSO

## oVirt SSO

### The challenge

Acquire ability to automatically login a user into the console of a virtual machine.

Console login is assumed to be local, there is no standard way to pass credential via a protocol as no network is involved.

There are solution to automate the login process via API, this implies that with cooperation of a component running on system it is possible to automate the login process.

### Why don't we use the network login capabilities of the system?

In theory there should be no need to hijack remote system console, as every modern operating system supports remote login protocol and graphics redirection.

In practice there are no mature Windows based solutions for graphics redirection leveraging the local and remote GPUs.

Within Linux using ssh + x11 + mesa is possible, but is somewhat difficult to establish, as X11 does not support multiple window managers.

The other challenge is to reach virtual machine user interface via network protocol when there is no network available or via side-band, this can be solved by tunneling stream over virtual io channel into localhost at specific port, for example ssh.

### Current oVirt Implementation (3.3)

Automatic login is enabled only in user portal.

Automatic login is always enabled in user portal for VMs that run guest agent.

The domain, user and password that it used are the credentials used to login into the web interface.

#### Players

|-----------------|-----------------------------------------------|
| ovirt-engine    | management server                             |
| vdsm            | host managers                                 |
| libvirt         | qemu access layer                             |
| qemu            | virtualization provider                       |
| guest agent     | software that runs within vm operating system |
| websocket proxy | websocket protocol proxy                      |
| desktop         | end-user desktop                              |

#### Use diagram

      vdsm control:            ovirt-engine --HTTPS(mutual authentication)--> vdsm
      qemu control:            vdsm --API----> libvirt --usock--------------> qemu
      guest agent:             vdsm --usock--> qemu    --virtual serial-----> guest agent
      user: ovirt user portal: browser --HTTPS-----------> ovirt-engine
      user: spice/novnc        native  --SSL(vnc/spice)-->  qemu
      user  novnc/spice-html5: browser --SSL(webscoket)--> websocket proxy --TCP(vnc/spice)--> qemu

#### Auto login sequence

1.  User request graphical session to a VM within user portal.
2.  ovirt-engine generates random "ticket".
3.  ovirt-engine via vdsm sends the ticket to qemu with hard coded validity period of 120 seconds.
4.  ovirt-egnine via vdsm sends desktop login command along with domain, user, password to guest agent running within the virtual machine, this is done via the side band vdsm<->guest agent channel.
5.  guest agent uses the credentials to automate login sequence using one of various methods.
6.  ovirt-engine trigger execution of spice/vnc at client machine passing the ticket.
7.  spice/vnc at client connects to qemu passing the ticket and establish connection.
8.  when spice/vnc session disconnects qemu will issue disconnection event to vdsm which in turn will issue lock-screen command to guest agent.
9.  vdsm will revive ticket so it will be valid again in case of virtual migration, to enable client re-connection.

\* in case of webscoket proxy another ticket is issued signed by engine key and validated against engine public key at websocket proxy, ticket contains destination ip and port to establish communication with.

#### Guest agent commands

Available more commands than actually used.

*   refresh - Send misc information back.
*   login - Perform login, triggered by engine command, can also be used to unlock. Accepts: username[@domain], password
*   lock-screen - Lock console, used by:
    1.  vdsm save vm state sequence (before saving).
    2.  libvirt event GRAPHICS phase: GRAPHICS_DISCONNECT
*   log-off - Force logoff user from console, triggered by engine command, not actually used anywhere.
*   shutdown - Gracefully shutdown system, used by vdsm VM shutdown sequence before using other more intrusive means.

### Problems in current implementations

*   Inability to support single signon or non password based authentication (example: OpenID)
    The assumption that the password used to login into the ovirt web interface is available or can be used in order to login into guest is incorrect. Authentication using kerberos, SSL certificate, OpenID or any password based SSO will not provide usable password to the engine.

*   Always enable automatic login when guest agent is available may cause user lockout
    If password on guest differs, the lock reference of the user will be incremented at any attempt.

*   Webadmin does not support automatic login
*   No mutual authentication between client and virtual machine
    The user credentials are passed directly to VM using the engine->vdsm channel, the user login takes place without even the user is involved. User does not need to connect to the VM in order to establish login.

*   vdsm<->guest agent protocol does not support negotiation
    No protocol version is exchanged between components, components are unaware of what features are supported by peer.

*   vdsm<->guest protocol does not support peer restart message
    If vdsm is restarted (upgraded for example) or guest agent is restarted (upgraded for example) the peer do not know of the event in order to enable new features or handle state pull.

*   websocket proxy does not use SSL protocol toward qemu
    Should be solved separately.

*   The guest agent uses thread to send periodic status but does not use locking, so channel may become corrupted
    Should be solved separately.

### Requirements

1.  Establish single signin friendly environment.
2.  Provide Linux end-to-end and firefox based solution of kerberos based end-to-end SSO.
3.  Decouple solution from oVirt specific implementation as much as possible.
4.  Windows guests are out of scope for now, there are multiple issues with Windows as CredSSP[1](http://msdn.microsoft.com/en-us/library/cc226764.aspx) violates SSO by require access to user's master password, and there is no [documented] way to load TGT into LSA.

### Proposed solution

#### Outline

Guest agent will acquire user credentials from two different sources:

1.  vdsm<->guest agent channel - a key.
2.  guest<->client - encrypted credentials blob.

It then use the key to decrypt the credentials blob and use the information in order to perform local and network authentication.

This approach has several benefits:

1.  It provides mutual authentication between client and destination VM, as login cannot be performed without client connection.
2.  It enables support of various authentication methods without modifying the protocol between engine->vdsm->guest agent.
3.  User credentials can be collected from client machine as well be provided by management server. This mean that the solution can be re-used without management server, allowing users of plain spice and qemu to enjoy SSO.

##### Kerberos solution

There can be, at least, two viable kerberos based solutions, both can be seen as complementary solutions and can be supported in parallel, however, for simplicity batter to select one for starters.

##### Kerberos solution (method#1)

*   The least changes to 3rd party components.
*   Makes ovirt-engine more security critical component.
*   Supports setup in which initial authentication is performed to oVirt web authentication (no TGT at client machine).
*   Supports potential spice-html5 setup.
*   Caveat: Unsure how to handle TGT expiration.

###### Preparations

*   ovirt-engine https service is to be marked as trusted for delegation in the kdc.
*   Client firefox browser is configured with network.negotiate-auth.delegation-uris to enable the ovirt-engine uri.
*   mod_auth_kerb5 is installed at engine to enable kerberos SSO, it is configured to pass the kebreros ticket as request attribute to be available for ovirt-engine.

###### Sequence

1.  User logon into his desktop using kerberos.
2.  User access ovirt-engine user portal.
3.  ovirt-engine receives user's TGT.
4.  User requests graphic session, in addition to current implementation ovirt-engine generate random key, encrypts TGT, then sends the key to the guest agent via vdsm and the encrypted TGT is sent along with the qemu ticket to the client.
5.  Spice client makes the encrypted blob available to target vm.
6.  Guest agent wait for connection establish then use the key to decrypt the blob available at client to have a valid TGT.
7.  Guest agent validate TGT and resolve it to local user and performs local login without farther authentication, while making TGT available to the user.

If user login without delegating TGT there are some options:

1.  mod_auth_kerb5 is capable to perform basic authentication and enforce authentication using kerberos at web server side.
2.  ovirt-engine can use the password obtained from user to retrieve TGT from KDC.
3.  Disable automatic login functionality.

##### Kerberos solution (method#2)

*   More cooperation of spice team.
*   Do not enhance the security sensitivity of the engine.
*   Has the potential to handle TGT expiration.

###### Preparations

*   mod_auth_kerb5 is installed at engine to enable kerberos SSO.

###### Sequence

1.  User login into his desktop using kerberos.
2.  User access ovirt-engine user portal.
3.  User requests graphic session, in addition to current implementation ovirt-engine generate random key, send the key to guest agent via vdsm and the key is sent along with the qemu ticket to the client, it also instructs spice to forward kerberos credentials.
4.  Spice acquire user's TGT, encrypt it using the key and makes this blob available to the target vm.
5.  Guest agent wait for connection establish then use the key to decrypt the blob available at client to have a valid TGT.
6.  Guest agent validate TGT and resolve it to local user and performs local login without farther authentication, while making TGT available to the user.

##### SASL solution (method#3)

*   Completely independent from ovirt-engine.
*   Will not support spice-html5/novnc
*   Every virtual machine to which SSO should be enabled, must have valid kerberos credentials (service principal name and keytab).

###### Preparations

*   mod_auth_kerb5 is installed at engine to enable kerberos SSO.
*   Issue kerberos credentials to all VMs.

###### Sequence

1.  User login into his desktop using kerberos.
2.  User access ovirt-engine user portal.
3.  User requests graphic session, in addition to current implementation ovirt-engine query guest agent for its service principal name, it also instructs spice to use SASL VDI and provide the name of the remove service principal.
4.  Guest agent wait for connection establish then initiate SASL negotiation on the SASL VDI.
5.  Client verify service principal name and performs SASL negotiation to guest agent.
6.  Client uses SASL channel to transfer its TGT with or without delegation.

#### Components' major changes

##### <b>Spice client (method#1)</b>

*   Establish/leverage a new virtual device interface to hold credentials blob, accessible by target host.
*   Add API and command-line parameter to accept blob as file and make it available to target host.

The format of the blob should not be important to the implementation.

NOTE: this infrastructure change will work in non-oVirt configurations as long as there is a cooperative component running on target OS.

##### <b>Spice client (method#2)</b>

*   Establish/leverage a new virtual device interface to hold credentials blob, accessible by target hist.
*   Add API and command-line parameter to enable kerberos credentials forward.
*   Add API and command-line optional parameter of credentials encryption key.
*   Define format of credentials blob, example: json format with salt, timestamp, credentials type (user, password, TGT), credentials blob encoded as base64.
*   Optionally encrypt the credentials blob using the provided key.

NOTE: this infrastructure change will work in non-oVirt configurations as long as there is a cooperative component running on target OS.

##### <b>Spice client (method#3)</b>

*   Implement SASL VDI - enables SASL negotiation on top of virtual serial or any other stream device.
*   Parameters (or command-line):
    -   Optional: Remote service principal name.
    -   Trust any service principal name (disabled per default)
    -   Offer TGT to untrusted for delegation services (disabled per default).
    -   Optional: User/password.
*   If remote service principal name is provided, request ticket to that service name.
*   If remote service principal name is not provided, ask remote for its service principal name, prompt user for approval before continue.
*   Perform SASL negotiation with TGT delegation.
*   if fails and "Offer TGT to untrusted for delegation services" is enabled perform SASL negotiation without TGT delegation, send TGT.
*   If has no TGT prompt the user for user, password and send to host.

NOTE: this infrastructure change will work in non-oVirt configurations as long as there is a cooperative component running on target OS.

##### <b>vnc client</b>

The encrypted credentials blob visibility to target host should be implemented in similar way to spice.

##### <b>virt-viewer (method#1, method#2)</b>

Support the new spice credentials blob feature, enable passing key/blob via command line or within configuration file.

##### <b>virt-viewer (method#3)</b>

*   Support of loading and configuring the SASL VDI.

##### <b>vdsm</b>

*   Forward libvirt GRAPHICS event phase INITIALIZE into new guest agent 'client-connect' command.
*   Forward credentials encrypted blob into new guest 'credentials-key' command.
*   Expose API command to allow engine feed credentials key to a vm.

Optional:

*   Add version command vdsm->guest agent with minimum and maximum supported versions.
*   Add version command guest agent->vdsm with minimum and maximum supported versions.
*   If not received assumes version=0 (current) is supported
*   Add connect vdsm->guest agent command to be used when vdsm is started.
*   Add connect guest agent->vdsm command to be used when guest agent is started.
*   Add command to return guest agent protocol version of an active vm to engine so engine be aware of new features availability.

Note: Sending unknown commands in current implementation will issue error within logs of both components, no other side effect.

##### <b>guest agent (method#1, method#2)</b>

*   If 'credentials-key' is received store encryption key.
*   If 'client-connect' is received communicate with the VDI to acquire the encrypted blob, if encrypted, decrypt using the credentials key. NOTE: we support plain text credentials as well.
*   If blob contains TGT validate TGT and extract user, perform local authentication without password and make TGT available to user.
*   If blob contains user,password extract user and password and perform current logic.
*   If console is locked, user must patch current logged on user.

##### <b>guest agent (method#3)</b>

*   If SASL VDI device is detected, perform SASL negotiation.
*   If success try to extract delegated TGT.
*   If no delegated TGT as client for TGT over SASL.
*   If no TGT ask for user/password.
*   If TGT available, validate TGT and extract user, perform local authentication without password and make TGT available to user.
*   If user, password available perform current logic.
*   If console is locked, user must patch current logged on user.

##### <b>ovirt-engine (method#1)</b>

*   If kerberos SSO is enabled.
*   Acquire user's TGT from http servlet request attributes.
*   Generate key and encrypt TGT, send key instead of user/password to guest agent via vdsm.
*   Send encrypted blob to virtviewer instructing it to actually use it.

##### <b>ovirt-engine (method#2)</b>

*   If kerberos SSO is enabled.
*   Generate key, send key instead of user/password to guest agent via vdsm.
*   Send key to virtvieweer instructing it to use it and send encrypted kerberos credentials.

##### <b>ovirt-engine (method#3)</b>

*   If kerberos SSO is enabled.
*   Acquire VM machine service principal name via guest agent.
*   Send key to service principal name instructing it to enable the SASL VDI.

##### <b>ovirt-engine (method#1 future)</b>

*   Enable pluggable creation of the blob, to support non kerberos SSO technologies.

<Category:Feature>
