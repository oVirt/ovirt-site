---
title: Serial Console
category: feature
authors: alonbl, fromani, vitordelima
wiki_category: Feature
wiki_title: Features/Serial Console
wiki_revision_count: 47
wiki_last_updated: 2015-06-15
feature_name: oVirt serial console
feature_modules: vdsm,engine,ovirt-host-deploy-ovirt-vmconsole
feature_status: In Development
---

# oVirt Serial Console

### Summary

Allow direct ssh access to the virtual serial consoles of the VMs managed by an oVirt engine instance, using a SSH proxy server.

### Owner

*   Name: [ Vitor de Lima](User:Vitordelima)
*   Email: vdelima@redhat.com
*   Name: [ Francesco Romani](User:fromani)
*   Email: <fromani@redhat.com>

### Detailed Description

Up until oVirt 3.6.0, VMs can be accessed by logging into Engine, using a browser. This feature will allow users to directly connect to the VM's serial consoles, emulated through virtio channels, using ssh, without directly accessing Engine. Engine will still be used by in background to learn about VM placement, and to store authentication keys.

### Benefit to oVirt

The benefit for oVirt is greater flexibility and easier access to VMs for admistrative purposes.

### Dependencies / Related Features

Depends on the new ovirt-vmconsole package.

### Documentation / External references

N/A

### Testing

TODO

### Contingency Plan

Instructions about how to manually setup the serial console connectivity will be provided below (see section: Manual Configuration) This feature add an independent functionalty, so in the case this is won't be ready in time, admins can fallback to manual configuration with no other drawbacks.

### Release Notes

This feature needs two additional ports to be opened on firewalls.

*   **On the proxy host**, the TCP port **2222** must be opened to enable external connections (from user's boxes)
*   **On each hypervisor host** (aka compute node), the TCP port **2223** must be opened to enable internal connections from the proxy host to the hypervisor hosts.

      == VirtIO serial console ==
      Allow the users to connect directly to the emulated serial console of the VMs, using SSH.

### Implementation details

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

### Manual Configuration

TODO

### Comments and Discussion

*   Refer to <Talk:OVirtSerialConsole>

<Category:Feature>
