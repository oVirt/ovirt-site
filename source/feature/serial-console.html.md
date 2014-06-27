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

### Outline

*   Access to console will be performed using SSH protocol.
*   Authentication is public key based only;
    -   more secure than most alternatives.
    -   avoid the need to perform user management at host side.
*   Separate access to console subsystem using separate unprivileged ssh daemon.
*   Proxy communication between ssh session and unix domain socket, at which vm serial is tunnelled.

### User Interaction Example

*   Implicit connection, single vm available

      $ ssh -p 2222 -t vmconsole@host
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Implicit connection, multiple vm available

      $ ssh -p 2222 -t vmconsole@host
      1. vm1
      2. vm2
      3. vm3
      > 2
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

*   Explicit connection:

      $ ssh -p 2222 -t vmconsole@host vm3
      Fedora release 19 (Schrödinger’s Cat)
      Kernel 3.13.5-101.fc19.x86_64 on an x86_64 (ttyS0)
      localhost login:

### Manager Side

#### VM static public keys

*   For every VM a set of ssh public keys can be registered. The exact UX sequence is not important.
*   When a VM when serial console is powered up, the public key set should be sent to vdsm.
*   Best if for every public key there will be name/description attached, to be used for logging.

#### VM dynamic public keys

*   In UI there should be an option to "start serial console", this will ask/acquire user public key and send it to vdsm.
*   Nice to have: expiration time for key, to allow temporary access for support.
*   Nice to have: editing the public key list of a running VM.

### Host Side

#### vmconsole user/group

A new os user and group will be created at vdsm installation: vmconsole, no password access is allowed, no shell, home directory at /var/lib/vdsm-vmconsole.

      vmconsole:x:XX:XX:vmconsole:/var/lib/vdsm-vmconsole:/sbin/nologin

#### VM console allocation

For each VM that is serial console enabled a unix domain socket will be attached:

        ~vmconsole/consoles/$(mktemp).
        Permissions: rw by vmconsole group.

#### Access registry

VDSM will have registry of public keys per VM, this can be modified throughout VM lifetime and kept updated.

*   Alternative#1 have a file

        ~vmconsole/registry
        Permissions: ro by vmconsole group.

*   Alternative#2 use some RPC over usock into vdsm.

##### Fields

*   user name - used for auditing
*   public key - authentication factor
*   public key hash - used to reduce public key hash calculations
*   vm name - used for selection
*   vm description - used for menu presentation
*   usock - location of console usock
*   max session time (optional) - maximum session time

#### sshd configuration

VDSM will maintain ~vmconsole/.ssh/authorized_keys within the following format for each public key, This file is derived from the registry.

*   Permissions: owned by root, ro by vmconsole.
*   Compromise: owned by vmconsole.

##### Format

      command="/usr/bin/vdsm-vmconsole HASH(PUBLIC_KEY)",no-agent-forwarding,no-port-forwarding,no-user-rc,no-X11-forwarding PUBLIC_KEY

Explanation:

1.  When remote user login using public key will execute /usr/bin/vdsm-vmconsole
2.  The vdsm-vmconsole utility will accept the public key hash as parameter to know what entity is trying to access.
3.  various of feature disable statement.

#### sshd separate daemon configuration

Using system sshd has limitations:

*   Sysadmin may configure sshd in a way it will not read ~/.ssh, but acquire it from external source.
*   Exposing potential shell access to host.
*   Managing the authorized_keys file dynamically may lead to security issues, as leftovers may remain.
*   Syncing configuration and file is redundant.

Solving the above is possible by adding dedicated sshd instance that will run at different port under the vmconsole user.

##### sshd configuration

~vmconsole/ssh/sshd_config

      AllowAgentForwarding no
      AllowTcpForwarding no
      AllowUsers vmconsole
      AuthorizedKeysCommand /usr/bin/vdsm-vmconsole-authkeys
      AuthorizedKeysCommandUser vmconsole
      AuthorizedKeysFile /dev/null
      AuthorizedPrincipalsFile /dev/null
      ChallengeResponseAuthentication no
      GSSAPIAuthentication no
      HostKey /var/lib/vdsm-vmconsole/ssh/ssh_host_rsa_key
      HostbasedAuthentication no
      KbdInteractiveAuthentication no
      KerberosAuthentication no
      PasswordAuthentication no
      Port 2222
      PubkeyAuthentication yes
      RSAAuthentication no
      X11Forwarding no

##### /bin/vdsm-vmconsole-authkeys utility

Performs rpc to vdsm or read registry to acquire authorized keys at same format as outlined above.

#### vdsm-vmconsole utility

##### Input

*   ENVIRONMENT(SSH_ORIGINAL_COMMAND) - explicit vm (optional).
*   argv[1] - public key hash

##### Output

*   /var/log/vdsm-vmconsole/access.log - audit log
*   Syslog

##### Logic

      Locate allowed VM within registry based on public key hash
      If explicit vm was not provided
        display selection menu
      if vm is not approved for public key
        log failure: user, public key hash, vm
        disconnect
        exit
      log access: user, public key hash, vm
      exec():
         socat -,raw,echo=0 UNIX-CONNECT:/path/to/usock

##### TODO

*   Integrate fakechroot as wrapper to socat, once program is ready as we can inherit the usock fd.
*   Integrate with gate one html5 ssh client.

<Category:Feature>
