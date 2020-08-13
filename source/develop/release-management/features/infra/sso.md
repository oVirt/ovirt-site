---
title: SSO
category: feature
authors: alonbl
---

# SSO

## oVirt SSO

### The challenge

Acquire ability to automatically login a user into the console of a virtual machine.

Console login is assumed to be local, there is no standard way to pass credential via a protocol as no network is involved.

There are solution to automate the login process via API, this implies that with cooperation of a component running on system it is possible to automate the login process.

### Why don't we use the network login capabilities of the system?

In theory there should be no need to hijack remote system console, as every modern operating system supports remote login protocol and graphics redirection, in other words there is no need for spice protocols, as we could use native system remote desktop capabilities.

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

           Desktop    ovirt-engine    vdsm    libvirt    qemu     guest-agent  Guest OS
       1.     ---HTTPS---> login
       2.     ---HTTPS---> Start Graphical
       3.
       4.                ---HTTPS(m.auth)-->---usock--->Ticket
       5.                ---HTTPS(m.auth)-->---usock--->---serial-->user/password
       6.                                                            -------------->
       7.     <--HTTPS- Execute spice/vnc client with Ticket, host, port
       8.     ---SSL----------------------------------->Ticket
       9.                           <--usock--------- disconnect
      10                            ---usock----------->---serial-->lock-screen
      11.                           ---usock----------->Ticket

1.  User login into ovirt-engine user portal.
2.  User request graphical session to a VM within user portal.
3.  ovirt-engine generates random "ticket".
4.  ovirt-engine via vdsm sends the ticket to qemu with hard coded validity period of 120 seconds.
5.  ovirt-egnine via vdsm sends desktop login command along with domain, user, password to guest agent running within the virtual machine, this is done via the side band vdsm<->guest agent channel.
6.  guest agent uses the credentials to automate login sequence using one of various methods.
7.  ovirt-engine trigger execution of spice/vnc at client machine passing the ticket.
8.  spice/vnc at client connects to qemu passing the ticket and establish connection.
9.  when spice/vnc session disconnects qemu will issue disconnection event to vdsm.
10. vdsm sends lock-screen command to guest agent.
11. vdsm will revive ticket so it will be valid again in case of virtual migration, to enable client re-connection.

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
    If password on guest differs, the lock reference of the user will be incremented at any attempt (should be solved in 3.4).

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

Establish a channel between client and guest and transfer credentials using stream protocol on top of the channel. The protocol may be based on SASL to exchange credentials information.

This solution can be used outside of the oVirt project scope, so it should be relatively easy to push missing bits into spice upstream.

This solution unlikely to support spice-html5/novnc.

##### Design principals

*   Make solution usable to non-oVirt projects.
*   Tight component - each component should do one task and only one.
*   Decoupling - components should share the minimum required implementation with each other.
*   Interfaces - interaction between components should be done via well defined interfaces.
*   Reuse - any effort invested should be reused for similar cases.

##### Implementation Summary

This section is written mostly for spice developers to understand the reasoning.

*   The current spice client is monolithic, a new functionality cannot be added without modifying the code. Establishing a stream channel between client and guest is usable for many solutions:
    -   Credentials delegation (aka SSO), this initiative.
    -   Private key usage delegation, solutions such as gpg-agent, ssh-agent forwarding.
    -   Access to other client side agents, such as gnome-keyring.
    -   Client software execution, such as stream URLs.
    -   Biometric.
*   serial<->usock proxy - instead of implementing the SSO initiative within the current monolithic implementation, this solution recommends to support serial device delegation into unix domain socket and implement the logic within separate component, this meets design principals:
    -   Tight components - the spice client core is "Remote Desktop" while "SSO" is, well, "SSO", two different unrelated tasks.
    -   Decoupling - there is nothing common between "SSO" and the logic of how to implement remote devices except of that the "SSO" component requires to establish a stream channel over the protocol into the guest. "SSO" component may be usable for other setups, such as vnc or direct tcp connection.
    -   Interfaces - there is no programmatic usage between "SSO", or any similar solution, and the spice implementation, except of tunneling a stream between client and guest. Unix domain socket is an interface that provides all required interaction between components:
        -   Both sides can detect that the channel is alive.
        -   Bidirectional full duplex communication.
        -   Async IO support.
        -   In-process and out-of-process support.
        -   Windows name pipe is similar to unix domain sockets in this regard.
    -   Reuse - implementation of serial<->usock proxy will enable other components such as those which are outlined above to be implemented with zero effort.
*   spice-client-sso - once serial<->usock proxy is available, the client component aka spice-client-sso can be implemented to interact with guest and delegate credentials.
    -   The author of this component can be completely detached from spice-gtk implementation considerations, hence we add more potential contributers.
    -   The author of this component can know nothing about spice nor its protocol, hence we add more potential contributers.
    -   The component can be reused with any stream channel such as vnc or plain tcp connection.
    -   The component can be managed/maintained/reside at spice project or as standalone project.
    -   If the protocol is designed properly, various of guest agent implementation may reuse this component for establishing SSO.
    -   Easier to debug, and perform integration tests.
*   sso-guest-agent - guest agent is responsible of accepting the credentials, it is the most complex piece of software in this solution.
    -   pam module.
    -   gdm2 plugin.
    -   gdm1 plugin.
    -   kde greeter.
    -   windows credprov
    -   gina
    -   agent logic.
    -   Credentials accept, interacts with spice-client-sso to acquire credentials.
*   ovirt-guest-agent is the most complete agent to provide the sso-guest-agent functionality, there is no point in re-inventing the wheel. The addition of credentials accept is minor compared to the other required functionality. The functionality of the sso-guest-agent can be reused and split out of the ovirt-guest-agent when we have a working solution, to enable component reuse at other projects.

Regardless this design comes from the oVirt project it had been written as if spice team is to implement the functionality regardless of oVirt. The same principals and arguments had been introduced as well and the conclusion had been the same. Modularity is better than monolithic, reuse of effort invested for future component implementation to extend the eco-system of spice is important.

I would like to separate the argument of who is maintaining the spice-client-sso component from the discussion, as it should not impact the resource allocation.

Open up the spice implementation for external component does not imply losing control of the components nor fragmentation of these. Forbidding external components damage innovation and limiting the size of the eco-system. Please keep in mind that nothing prevents the spice team to maintain the spice-client-sso as separate component in-tree, out-of-tree or at letting 3rd party maintain it.

Also be aware that spice client side SSO solution is the least work in maintaining a solution, most of the work is at guest agent. As far as I want to perceive the solution the spice-client-sso has far more in common with the guest agent than with the spice client, both in term of code and knowledge. Unlike supporting remote desktop, the SSO is derived from IT infrastructure, and far from being stable, every day we witness new technologies and there should be flexible method for people to provide a solution that is synced not between the guest agent and client but between the guest agent and the spice-client-sso component.

In term of packaging it would be something like the following:

*   Install the following at guest: xxxagent-sso.
*   Install the following at client: spice-gtk, xxxagent-spice-sso.

The xxxagent can as well be vdagent, however per the tight and decoupling design principals, there is nothing common between the current vdagent which is used for core interaction (display, mouse, clipboard) and SSO, both in term of functionality and knowledge required to maintain each component. BTW: I believe that in future at least the clipboard integration can be implemented using the same approach of usock<->serial channel quite easily.

##### Preparations

*   mod_auth_kerb5 is installed at engine to enable kerberos SSO.
*   Issue kerberos credentials to all VMs.

##### Sequence

           Desktop    ovirt-engine    vdsm    libvirt    qemu     guest-agent  Guest OS
       1.
       2.     ---HTTPS---> login
       3.     ---HTTPS---> Start Graphical
       4.                ---HTTPS(m.auth)-->---usock--->---serial-->get SPN
       5.
       6.                ---HTTPS(m.auth)-->---usock--->Ticket
       7.     <--HTTPS- Execute spice/vnc client with Ticket, host, port, SPN
       8.     ---SSL----------------------------------->Ticket
       9.     ---SSL----------------------------------->---serial-->SASL
      10.                                                             ----------->

1.  User login into his desktop using kerberos.
2.  User access ovirt-engine user portal.
3.  User requests graphic session.
4.  ovirt-engine queries guest agent for its service principal name.
5.  ovirt-engine generates random "ticket".
6.  ovirt-engine via vdsm sends the ticket to qemu with hard coded validity period of 120 seconds. NOTE: in standalone mode this can be replaced with SASL negotiation.
7.  ovirt-engine trigger execution of spice/vnc at client machine passing the ticket and the service principal name.
8.  spice/vnc at client connects to qemu passing the ticket and establish connection.
9.  spice/vnc client negotiate using SASL directly with the guest agent delegating TGT or other credentials.
10. guest agent uses the credentials to automate login sequence using one of various methods.

#### Components' major changes

##### **Spice client**

It turns out[2](http://lists.freedesktop.org/archives/spice-devel/2013-November/015504.html) the spice client is monolithic software, design that should not happen in the 21th century... but ovirt-engine and vdsm are aligned in this sense. So it won't be that easy to introduce new functionality.

There is an existing project named vd_agent[3](http://cgit.freedesktop.org/spice/linux/vd_agent) which is guest agent. It implements mouse offload and X server helper. The guest agent already interacts with the spice client using virtual serial device.

The easiest implementation is probably to push more code into spice client and the vd_agent projects. However, this will not be productive for future maintenance of the functionality, nor it will help the spice project to be able to support similar efforts in future.

There are two options of implementation to help the spice project to open up:

*   Modularizing the interface at client side, allowing to dynamically load components that can serve spice channels. This will require much resources and will likely be a long process to complete.
*   Modularizing only the spice port at client side implementation, this will provide a solution to any stream based implementation including our own, while splitting the work between spice developer and agent developer.

I suggest to focus on modularizing only the spice port at client side, the solution will be to fork a process attaching usock to its stdin/stdout and proxy the spice port stream into the usock. Once this mechanism is in place the implementation of the software that interact with the agent is quite simple and completely detached from spice internals.

Spice client should accept the following additional parameters:

*   port name.
*   executable to run. The path should be relative to some pre-defined spice plugin folder, example ${libdir}/spice/, so that only approved plugins will be allowed to be loaded.
*   parameters to pass.

Once spice client connects, if port exists on remote, it will fork the process with parameters and usock as stdin/stdout, and proxy all data. It should be generic implementation.

##### **spice-sso-client**

A new component to be loaded by spice-client for the sso channel to interact with the guest agent for credentials delegation and refresh.

At qemu side, define spice port for the interaction:

      -device virtio-serial-pci
      -device virtserialport,chardev=spicesso,name=spice.sso.0
      -chardev spicevmc,id=myappl,name=spicesso

At guest a serial device at /dev/virtio-ports/spice.sso.0 will be available for guest agent use.

At client configure spice client to execute spice-sso-client for spice.sso.0 spice port, the parameters it accept are:

*   Optional: Remote service principal name.
*   Trust any service principal name (disabled per default)
*   Offer TGT to untrusted for delegation services (disabled per default).
*   Perform password authentication (disabled per default)
*   Optional: User/password.

###### Protocol highlights

*   SIGNATURE - sent by guest agent when connected or reseted.
*   SIGNATURE - sent by spice-client-sso to reset guest agent in case of inability for guest to detect disconnect of spice port.
*   startTLS - sent by spice-client-sso to start TLS negotiation over the channel, optional.
*   startSASL - sent by spice-client-sso to start SASL negotiation over the channel, optional.
*   credentials type blob - sent by spice-client-sso to delegate credentials, blob is encoded using base64.
*   authenticate type type type... - sent by guest agent when credentials are required, while specifying supported types.
*   info attr - sent by spice-client-sso to retrieve information, example 'spn' or 'time'.
*   ok
*   error code string

###### Sequence

            Client                                       Guest
       1.1    <---SIGNATURE---------------------------------
       1.2.1  ---SIGNATURE--------------------------------->
       1.2.2  <---SIGNATURE---------------------------------
       2.     <--authenticate kerberos password-------------
       3.     ---error 300, delay-------------------------->
       4.     ---startTLS---------------------------------->
       5.     <--error 400, unsupported ------------------->
       6.     ---startSASL--------------------------------->
       7.     <--ok-----------------------------------------
       8.     <--------------SASL negotiation-------------->
       9      <---SIGNATURE---------------------------------
      10.1    <--authenticate kerberos password-------------
      10.2    ---ok---------------------------------------->
      10.3    ---credentials kerberos AAEK12DS==----------->
      10.4    <--ok-----------------------------------------

1.  Signature exchange
    1.  Guest detect new client connection and sends signature.
    2.  In case we cannot detect connection at guest and/or at client
        1.  Client will send signature to reset guest state.
        2.  Guest was rested so it sends signature when reseted.

2.  Guest asks for authentication using kerberos or password.
3.  Client delay this request.
4.  Client tries to initiate TLS.
5.  Guest does not support TLS.
6.  Client tries to initiate SASL
7.  Guest support SASL.
8.  SASL negotiation
    1.  If no spn given in command-line acquire spn from guest (weak), if not trust all spn parameter set prompt user for acknowledge spn.
    2.  Acquire service ticket by using the service principal name.
    3.  If TGT is forwardable forward TGT using SASL negotiation, guest will extract TGT out of negotiation.
    4.  If TGT is not forwardable perform plain SASL negotiation.

9.  Guest sends signature.
10. In case ticket was not forwardable and configuration allows passing TGT
    1.  Guest asks for authentication using kerberos or password.
    2.  Client support types.
    3.  Client sends kerberos TGT.
    4.  Guest accepts.

##### **vnc client**

Needs support of stream between client and guest in similar manner as spice.

##### **virt-viewer**

Support of new features of spice client within its configuration file format.

##### **vdsm**

*   Forward libvirt GRAPHICS event phase INITIALIZE into new guest agent 'client-connect' command.
*   Add 'get-spn' command to acquire service principal name of the guest agent.

Optional:

*   Add version command vdsm->guest agent with minimum and maximum supported versions.
*   Add version command guest agent->vdsm with minimum and maximum supported versions.
*   If not received assumes version=0 (current) is supported
*   Add connect vdsm->guest agent command to be used when vdsm is started.
*   Add connect guest agent->vdsm command to be used when guest agent is started.
*   Add command to return guest agent protocol version of an active vm to engine so engine be aware of new features availability.

Note: Sending unknown commands in current implementation will issue error within logs of both components, no other side effect.

##### **guest agent**

*   Add get-spn command to return service principal name of guest agent.
*   If 'client-connect' is received try to detect SASL VDI.
*   Implement the spice-client-sso protocol.
*   If console is locked, user must patch current logged on user.

##### **ovirt-engine**

*   If kerberos SSO is enabled.
*   Acquire VM machine service principal name via guest agent.
*   Send service principal name to virtviewer instructing it to enable the spice-client-sso component.

### Resource Estimation

| Resource              | Task                                                                 | Estimation |
|-----------------------|----------------------------------------------------------------------|------------|
| Spice developer       | Implement the spice-port<->usock proxy                             | 4w         |
| AAA developer         | Implement the spice-client-sso and guest agent component, verify TGT | 8w         |
| Guest agent developer | Wrap all up, handle local login, tests                               | 4w         |
| AAA developer         | Setup environment at rhev office                                     | 3d         |
| Virt developer        | Setup environment at rhev office                                     | 3d         |
| Virt developer        | Implement sequence within vdsm, ovirt-engine                         | 1w         |
| QE                    | Test                                                                 | 2w         |
| Manager               | Overhead                                                             | 1w         |
| Peers                 | Review                                                               | 2w         |

Author: Alon Bar-Lev (Alonbl)
