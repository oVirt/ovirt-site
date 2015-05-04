---
title: Serial Console
category: feature
authors: alonbl, fromani, vitordelima
wiki_category: Feature
wiki_title: Features/Serial Console
wiki_revision_count: 47
wiki_last_updated: 2015-06-15
---

# oVirt Serial Console

#### Summary

This feature will allow access to the virtual serial consoles of the VMs managed by an oVirt engine instance using a SSH proxy server.

#### Owner

*   Name: [ Vitor de Lima](User:Vitordelima)
*   Email: vdelima@redhat.com

#### Current status

In development.

### Solution

![](Serial_console.png "Serial_console.png")

*   A secondary instance of the SSH server is used, it allows only one method of authentication (using public keys) and can only login into one user (the vmproxy user)
*   The vmproxy_authkeys script lists which public keys are allowed to login and forces a command to be executed after the vmproxy user logs in (the vmproxy command)
*   The vmproxy command calls "virsh console" with the appropriate parameters to open a session in the virtual serial console of the chosen VM
*   There is a servlet (Public Keys Servlet) inside the engine used by vmproxy_authkeys which lists the public keys and GUIDs of each user
*   Another servlet (Available Consoles Servlet) lists the VMs a user is allowed to login and in which host they are located, it is used by the vmproxy script to call virsh console with the appropriate parameters
*   The SSH key management creates a public/private SSH key pair, stores the public key in the database with the user record and gives the private key to the user

#### Detailed Outline

*   Access to console will be performed using SSH protocol.
*   Proxy based solution, authentication between user and proxy and authentication between proxy and host.
*   Separate access to console subsystem using separate unprivileged ssh daemon.
*   Communication between the SSH proxy and the VM console using "virsh console"

      User---->[ssh pk(user)]---->SSH Proxy (manager side) --->[TLS socket]---> libvirtd (host side)
                                  |
                                 V
                               Engine

#### User Interaction Example

*   Implicit connection, single vm available

      $ ssh -i console.key -p 2222 -t vmproxy@engine
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Implicit connection, multiple vm available

      $ ssh  -i console.key -p 2222 -t vmproxy@engine
      1. vm1 [vmid1]
      2. vm2 [vmid2]
      3. vm3 [vmid3]
      > 2
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Explicit connection:

      $ ssh  -i console.key -p 2222 -t vmproxy@engine vmid3
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

#### Manager Side

##### User record

*   For each user record a SSH public key will be generated on demand and the private key will be given to the user
*   The generated public key will be stored in the database to be used by the "Public Keys Servlet"

##### Auxiliary Servlets

"Available Consoles Servlet":

*   Given a user GUID, list the authorized running VMs:
    -   VM Name
    -   VM Id within engine.
    -   VM ID within VDSM.
    -   Host running VM.

"Public Keys Servlet":

*   Query users, for each user:
    -   SSH public key
    -   GUID

OPTIONAL

*   User retrive self (login) running VMs, similar to above list only executed by user.

#### Serial Console Proxy Daemon

##### System configuration

A new os user and group will be created vmproxy, no password access is allowed, no shell.

      vmproxy:x:XX:XX:vmproxy:/var/lib/vmproxy:/sbin/nologin

Home directory and all files are owned by root, to avoid modifications, readable to vmproxy group.

##### sshd configuration

~vmproxy/ssh/sshd_config

      AllowAgentForwarding no
      AllowTcpForwarding no
      AllowUsers vmproxy
      AuthorizedKeysCommand /usr/bin/vmproxy-authkeys
      AuthorizedKeysCommandUser vmproxy
      AuthorizedKeysFile /dev/null
      AuthorizedPrincipalsFile /dev/null
      ChallengeResponseAuthentication no
      GSSAPIAuthentication no
      HostKey /var/lib/vmproxy/ssh/ssh_host_rsa_key
      HostbasedAuthentication no
      KbdInteractiveAuthentication no
      KerberosAuthentication no
      PasswordAuthentication no
      Port 2222
      PidFile /var/lib/vmproxy/ssh/ssh.pid
      PubkeyAuthentication yes
      RSAAuthentication no
      X11Forwarding no

systemd/sysvinit script for daemon.

    [Unit]
    Description=OpenSSH server for VM console proxy daemon
    After=syslog.target network.target auditd.service sshd.service

    [Service]
    EnvironmentFile=/etc/sysconfig/sshd
    ExecStart=/usr/sbin/sshd -D -f /var/lib/vmproxy/ssh/sshd_config $OPTIONS
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-failure
    RestartSec=42s

    [Install]
    WantedBy=multi-user.target

##### /usr/bin/vmproxy-authkeys utility

*   Query engine for public keys and GUIDs.
*   For each public key echo:

      command="/usr/bin/vmproxy --ssh-key-fingerprint=FINGERPRINT(PUBLIC_KEY)",no-agent-forwarding,no-port-forwarding,no-user-rc,no-X11-forwarding PUBLIC_KEY

##### /usr/bin/vmproxy utility

*   while True
    -   Query engine for running VMs based on GUID argument.
    -   if vmid not provided in ssh arguments, present a menu with all running vms, allow user to select.
    -   /var/log/vdsm-vmconsole/access.log - audit log
    -   Syslog audit
    -   execute:

virsh console vdsm-id host

OPTIONAL

*   If ssh-key is not available
    -   Prompt for user/password
    -   Authenticate against RestAPI
    -   Retrieve list of running VMs of self.

#### Host Side

##### VM console allocation

For each VM that is serial console enabled a unix domain socket will be attached:

        ~vmconsole/consoles/`<vdsm-vmid>`.
        Permissions: rw by vmconsole group.

##### System configuration

A new os user and group will be created vmconsole, no password access is allowed, no shell.

      vmconsole:x:XX:XX:vmconsole:/var/lib/vmconsole:/sbin/nologin

Home directory and all files are owned by root, to avoid modifications, vmconsole to vmproxy group.

##### sshd configuration

~vmconsole/ssh/sshd_config

      AllowAgentForwarding no
      AllowTcpForwarding no
      AllowUsers vmconsole
      AuthorizedKeysFile /dev/null
      AuthorizedPrincipalsFile /dev/null
      ChallengeResponseAuthentication no
      ForceCommand /usr/bin/vmconsole
      GSSAPIAuthentication no
      HostCertificate /var/lib/vmconsole/ssh/ssh_host_rsa_key-cert.pub
      HostKey /var/lib/vmconsole/ssh/ssh_host_rsa_key
      HostbasedAuthentication no
      KbdInteractiveAuthentication no
      KerberosAuthentication no
      PasswordAuthentication no
      Port 2223
      PubkeyAuthentication yes
      RSAAuthentication no
      TrustedUserCAKeys /var/lib/vmconsole/ssh/cakeys
      X11Forwarding no

systemd/sysvinit script for daemon.

##### /usr/bin/vmconsole utility

      log access: vm
      exec():
         socat -,raw,echo=0 UNIX-CONNECT:/path/to/usock/of/vm

### TODO

*   Integrate with gate one html5 ssh client[1](https://github.com/liftoff/GateOne) or wssh[2](https://github.com/aluzzardi/wssh/)

[Alon Bar-Lev](User:Alonbl) ([talk](User talk:Alonbl)) 14:39, 18 September 2014 (GMT)

<Category:Feature>
