---
title: GenericRegistration
category: feature
authors: dougsland
wiki_category: Feature
wiki_title: Features/VDSM/GenericRegistration
wiki_revision_count: 14
wiki_last_updated: 2015-06-13
feature_name: GenericRegistration
feature_modules: vdsm, ovirt-node
feature_status: Merged
---

# Generic Registration

### **Summary**

This feature must deprecate vdsm-reg and provide a vdsm-tool verb to make any supported distro (oVirt Node, CentOS, RHEL) be able to register against oVirt Engine using new registration schema.

### **Owner**

*   Name: [ Douglas Schilling Landgraf](User:dougsland)

<!-- -->

*   Email: dougsland AT redhat DOT com
*   IRC: dougsland

### **Modules involved or affected by this Feature**

*   VDSM
*   ovirt-node-plugin-vdsm
*   ovirt-node

### **Detailed Description**

This implementation will require:

*   Create the new registration tool/library and integrate it with vdsm-tool.
*   It should be smart enough to detect if the Engine provides the new registration protocol, if not, use the old registration schema to be compatible with old Engine deploys
*   Integrate it with oVirt Node TUI
*   Create a new tool to handle autoinstall which should use vdsm-tool register to add new node into Engine. (deprecate vdsm_reg/vdsm-config too)
*   Persist conf files if it's oVirt node based distro

### **Benefit to oVirt**

The vdsm-reg was implemented many years ago, should be refreshed with updated programming and using new registration service. Also, have a tool to register nodes in any oVirt supported distro.

### **Dependencies / Related Features**

No dependencies

### **Testing**

As soon oVirt 3.6 be released with the patches merged users can register their Linux distro to became a hypervisor of oVirt using vdsm-tool register verb or using the refectory registration TAB in the oVirt Node TUI (Text User Interface).

**Example of testing**:

*   First, **make sure the node hostname is configured and oVirt Engine is able to reach it**. The vdsm-tool register verb will use the hostname of node to register in oVirt Engine.
*   In oVirt Node TUI:

<https://dougsland.fedorapeople.org/ovirtpics/regtabovirt35.png>

*   In shell:

       # vdsm-tool register --engine-fqdn engine.localdomain

For more options:

       # vdsm-tool register --help
       usage: vdsm-tool [-h] [--node-fqdn NODE_FQDN] [--node-name NODE_NAME]
                      --engine-fqdn ENGINE_FQDN
                      [--engine-https-port ENGINE_HTTPS_PORT] [--ssh-user SSH_USER]
                      [--ssh-port SSH_PORT] [--check-fqdn CHECK_FQDN]
                      [--fingerprint FINGERPRINT] [--vdsm-port VDSM_PORT]
        Tool to register node to Engine
        --engine-fqdn ENGINE_FQDN
                             Engine FQDN (See also: --check-fqdn)
         optional arguments:
       -h, --help            show this help message and exit
       --node-fqdn NODE_FQDN
                             Define node FQDN or IP address. If not provided, will be used system host name
       --node-name NODE_NAME
                             Define node name. If not provided, will be used system short host name (the name before the first dot in the system host name)
       --engine-https-port ENGINE_HTTPS_PORT
                             Define engine https port. If not provided, will be used 443
       --ssh-user SSH_USER   SSH username to establish the connection with Engine. If not provided, the user which is executing the script will catch and used
       --ssh-port SSH_PORT   SSH port to establish the connection with Engine If not provided, the script will use the default SSH port 22
       --check-fqdn CHECK_FQDN
                             Disable or Enable FQDN check for Engine CA, this option is enabled by default (Use: True or False)
       --fingerprint FINGERPRINT
                             Specify an existing fingerprint to be validated against Engine CA fingerprint
       --vdsm-port VDSM_PORT
                             Specify the listen port of VDSM If not provided, will be used the default 54321
       Example of use:
       vdsm-tool --engine-fqdn engine.mydomain

*   In Autoinstall:

For autoinstall users can keep using the already know boot keys: management_server, management_port, management_server_fingerprint, hostname, engine_admin_password.

**management_server**: the key for oVirt Engine FQDN (**required**)
**hostname**: specify oVirt Node hostname (**required**, otherwise it will be localhost.localdomain and oVirt Engine won't reach it)
**management_port**: oVirt Engine https Port (default 443/https)
**management_server_fingerprint**: used to validate the oVirt Engine CA, use in the format: 11:11:11:11:11
**engine_admin_password**: Set root password and Enable SSH daemon **BOOTIF**: Network interface to be configured as ovirtmgmt network interface **firstboot**: Firstboot of node

Example for PXE or Grub for autoinstall of ovirt-node with **dhcp**:

         firstboot storage_init=/dev/sda adminpw=RHhwCLrQXB8zE management_server=engine.localdomain BOOTIF=ens3 hostname=node.localdomain

Example for PXE or Grub for autoinstall of ovirt-node with **static ip address**:

         firstboot storage_init=/dev/sda adminpw=RHhwCLrQXB8zE management_server=engine.localdomain BOOTIF=ens3 hostname=node.localdomain ip=192.168.122.125 netmask=255.255.255.0 gateway=192.168.122.1

Example for PXE or Grub for autoinstall specifying ovirt engine port (**Use for non default port. The default port is 443**)

         firstboot storage_init=/dev/sda adminpw=RHhwCLrQXB8zE management_server=engine.localdomain:7443 BOOTIF=ens3 hostname=node.localdomain

### **Logs**

*   Autoinstall log:

       journal -xr or systemctl status ovirt-node-plugin-vdsm

*   vdsm-tool register log:

       /var/log/vdsm/register.log

### **Documentation / External references**

vdsm-tool: Add register verb
<https://gerrit.ovirt.org/#/c/40966/>

engine_page: vdsm-tool register verb integration
<https://gerrit.ovirt.org/#/c/41081/>

autoinstall: Use systemd service
<https://gerrit.ovirt.org/#/c/41303/>

### **Comments and Discussion**

Comments and discussion can be posted on mailinglist

<Category:Feature> <Category:VDSM>
