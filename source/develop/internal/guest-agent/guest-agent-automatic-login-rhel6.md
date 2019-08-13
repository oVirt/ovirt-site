---
title: oVirt guest agent automatic login RHEL6
category: ovirt-guest-agent
authors: bazulay
---

<!-- TODO: Content review -->

# oVirt guest agent automatic login RHEL6

## Automatic login on RHEL6

The automatic login on RHEL6 is based on three components:

1. The RHEV-Agent which handles the user's credentials and workflow.
2. A greeter's plug-in which allows interaction with the desktop manager.
3. A PAM module which handles the PAM's conversation.

Currently there are two greeter's plug-ins. One for GNOME desktop manager (GDM) and one for the KDE desktop manager (KDM).
 All of the above are included in the ovirt-guest-agent git repo

The flow:

1. The greeter's plug-in is waiting for a signal on the D-BUS interface.
2. The RHEV-Agent receives the user's credentials from the VDSM through the virtio-serial device
3. A user-authenticated signal with a one-time token is emitted by the agent.The agent also opens an abstract server socket which is used to send the user's credentials to the PAM module.
4. After the signal is caught by the greeter's plug-in, the plug-in starts the PAM conversation. The plug-in doesn't start the PAM conversation directly. It starts it by using the greeter's interface.
5. The PAM module starts the conversation with a query for the token. The answer to the query is given by the plug-in.
6. The PAM module connects to the agent's abstract server socket and sends the token.
7. The agent verifies that the connection is allowed and the tokens match. If the connection is verified, the user's credentials are sent to the PAM module. Otherwise, the connection is closed.
8. The PAM module sets the user and password fields and passes them down the PAM stack (defined in the files: /etc/pam.d/gdm-rhev-cred and /etc/pam.d/kdm-rhev-cred) to perform the actual authentication.

![](/images/wiki/Guest-agent-sso.png)

