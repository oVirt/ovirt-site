---
title: Windows
category: ovirt-guest-agent
authors: vfeenstr
---

<!-- TODO: Content review -->

# Windows

## An overview how the single sign on process works on Microsoft Windows® systems

![](/images/wiki/Ovirt-guest-agent-sso-windows2.png")

1.  VDSM sends a 'login' message to the oVirt Guest Agent
2.  In case the "SAS" library is installed, the service will simulate a "Secure attention sequence" by issuing a SendSAS(0) call on the SAS library
3.  The service then will send the credentials to a named Pipe ("\\\\\\\\.\\\\pipe\\\\VDSMPipe") via the CallNamedPipe system call
4.  The plugin either GINA on Windows XP® or the Credentials Provider on Windows 7® will issue the login process with the credentials received.
5.  If the login credentials are valid, the user is authenticated and the Desktop session started

