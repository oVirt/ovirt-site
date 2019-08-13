---
title: Guest Agent Login RHEL
category: vdsm
authors: danken
---

# Guest Agent Login RHEL

## Automatic login on RHEL

**Notice: The automatic login is not implemented on RHEL 5 guests**

The automatic login on RHEL is based on three components:

1.  The RHEV-Agent which handle the user's credentials and workflow.
2.  A greeter's plug-in which allow interaction with the desktop manager.
3.  A PAM module which handle the PAM's conversation.

Currently there are two greeter's plug-ins. One for GNOME desktop manager (GDM) and one for the KDE desktop manager (KDM).

The flow:

1.  The greeter's plug-in is waiting for a signal on the D-BUS interface.
2.  The RHEV-Agnet receive the user's credentials from the VDSM though the virtio-serial device.
3.  A "User Authenticated" signal with a a one-time token is emitted by the agent. The agent also opens an abstract server socket which is used to send the user's credentials to the PAM module.
4.  After the signal is catch by the greeter's plug-in, the plug-in starts the PAM conversation. The plug-in doesn't start the PAM conversation directly. It start it by using the greeter's interface.
5.  The PAM module start the conversation with a query for the token. The answer to the query is given by the plug-in.
6.  The PAM module connect to the agent's abstract server socket and send the token.
7.  The agent verify that the connection is allowed and the token match. If the connection is verified the user's credentials is send to the PAM module, otherwise the connection is closed.
8.  The PAM module set the user and password field and pass them down the PAM stack (defined in the files: /etc/pam.d/gdm-rhev-cred and /etc/pam.d/kdm-rhev-cred) in order to perform the actual authentication.

