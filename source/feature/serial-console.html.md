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

### Mission

Enable secure access to VM serial by users via ssh.

### Solution

#### Outline

*   Access to console will be performed using SSH protocol.
*   Proxy based solution, authentication between user and proxy and authentication between proxy and host.
*   Separate access to console subsystem using separate unprivileged ssh daemon.
*   Proxy communication between ssh session and unix domain socket, at which vm serial is tunnelled.

      User---[ssh pk(user)]--->Proxy---[ssh pk(proxy)]--->Host---[usock]--->qemu
                                 |
                                 V
                               Engine

#### User Interaction Example

*   Implicit connection, single vm available

      $ ssh -p 2222 -t vmproxy@enine
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Implicit connection, multiple vm available

      $ ssh -p 2222 -t vmproxy@engine
      1. vm1 [vmid1]
      2. vm2 [vmid2]
      3. vm3 [vmid3]
      > 2
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Explicit connection:

      $ ssh -p 2222 -t vmproxy@engine vmid3
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

#### Manager Side

##### User record

*   For each user record a list of SSH public keys will be attached.
*   Every user will be able to upload his public key via the user portal / admin portal.

##### RestAPI call?

*   Based on ssh key fingerprint and map it to user retrieve list of running authorized running VMs:
    -   VM Name
    -   VM Id within engine.
    -   VM ID within VDSM.
    -   Host running VM.

<!-- -->

*   Query users, for each user:
    -   ssh public key

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

##### ssh configuration

~vmproxy/ssh/ssh_config

      CheckHostIP no
      EscapeChar none
      GlobalKnownHostsFile /var/lib/vmproxy/ssh/known_hosts
      IdentityFile /var/lib/vmproxy/ssh/id_rsa
      PasswordAuthentication no
      PermitLocalCommand no
      PubkeyAuthentication yes
      RhostsRSAAuthentication no
      RSAAuthentication no
      ServerAliveInterval 10
      StrictHostKeyChecking yes

~vmproxy/ssh/known_hosts

      @cert-authority * CA_KEY

##### /usr/bin/vmproxy-authkeys utility

*   Query engine for public keys.
*   For each public key echo:

      command="/usr/bin/vmproxy --ssh-key-fingerprint=FINGERPRINT(PUBLIC_KEY)",no-agent-forwarding,no-port-forwarding,no-user-rc,no-X11-forwarding PUBLIC_KEY

##### /usr/bin/vmproxy utility

*   while True
    -   Query engine for running VMs based on ssh-key-fingerprint argument.
    -   if vmid not provided in ssh arguments, present a menu with all running vms, allow user to select.
    -   /var/log/vdsm-vmconsole/access.log - audit log
    -   Syslog audit
    -   execute:

      ssh -p 2223 -F /var/lib/vmproxy/ssh/ssh_config vmconsole@host -t vdsm-vmid

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

#### Alternative Host Side Solution

The communication between the SSH console proxy and the host can be done using the libvirtd TLS port, which is already available in the hosts. This can be done by using virsh instead of the SSH client in the console proxy:

    virsh -c qemu+tls://<host-address>/system console <vm-name>

A few notes about this approach:

*   In the console proxy, virsh must be configured to use a proper CA, certificate and private key, they must located in /var/lib/vmproxy/.pki/libvirt
*   Avoids deployment problems in the hosts, requiring just a simple VDSM RPM upgrade
*   Avoids problems with setting the proper permissions/paths for the VM consoles in the host

#### Host Deploy

*   TODO

### TODO

*   Integrate fakechroot as wrapper to socat, once program is ready as we can inherit the usock fd.
*   Integrate with gate one html5 ssh client[1](https://github.com/liftoff/GateOne) or wssh[2](https://github.com/aluzzardi/wssh/)

[Alon Bar-Lev](User:Alonbl) ([talk](User talk:Alonbl)) 14:39, 18 September 2014 (GMT)

<Category:Feature>
