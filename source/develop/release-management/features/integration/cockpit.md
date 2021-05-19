---
title: CockpitOvirtPlugin
category: feature
authors: mlibra
---

# Proposed Feature 4.0: Cockpit-oVirt Plugin

## Summary 
The oVirt's webadmin provides complete datacenter/cluster view and it's administration but lacks in tuning of specific hosts parameters.
Recent oVirt's UI can be considered as comprehensive but heavy-weight, confusing for non-advanced users, resource-consuming and it's accessibility can be limited in case of high-loaded engine.

This feature introduces new plugin to Cockpit which provides VM-centric monitoring and management of a host machine while taking advantage of already built-in admin functionality in the Cockpit.

### About Cockpit
Cockpit is a Linux system administration tool with fancy web UI, easy setup and minimal system footprint at runtime.
Cockpit's functionality can be extended by plugins represented by html page(s), javascript, manifest file and optionally backend components.
Cockpit's access to the host is restricted to the same privileges as shell of a logged user, i.e. via ssh.

### Owner
* Name: Marek Libra
* Email: mlibra@redhat.com

### Benefit to oVirt
User experience in using Cockpit can be described with words like 'light-weight', 'targeted on action', 'user-friendly' or 'easy-to-use'.

The oVirt plugin represents VM-centric monitoring and troubleshooting tool of a host with easy setup.
It's use is complimentary to the recent oVirt UIs, allowing user to easily switch among them depending on his/her actual needs.

Brings benefits in:

* fine grained host tuning
* troubleshooting tool when heavy-weight UIs can't be effectively accessed
* oVirt's integration point on UI level since whole plugin or it's parts are easily embeddable within other web applications (i.e. ManageIQ or even oVirt Webadmin)
* starting point for management of a small cluster setup, while deploying VDSM and so making foundation to full oVirt setup in the future when demands grows

### Dependencies
Cockpit needs to be installed and running.

The plugin has dependency on the 

* Cockpit - needs to be installed and running
* VDSM running on the host.

Access to oVirt's engine is optional. When login is available, additional functionality is accessible in the plugin.

### Rules of Thumb
If functionality provided by the plugin is in contrary to the oVirt's engine, it is either not provided or achieved via engine's REST API call.
Despite the logged user might have access to the libvirt/VDSM on the host, the plugin shall not attempt to replace oVirt's engine.
The plugin is meant to allow access to engine/vdsm functionality in a user-friendly way, but not actualy implement it.

While respecting previous rule and if possible, the VDSM is  preferred to perform host-local actions over direct calls to other components/libraries (i.e. libvirt).

The plugin is not meant as full replacement of UI. Just selected functionality should be provided to keep user-friendliness on mind.


### Recent Status
Please see issue tracker [2] for more details about recent issues and planed enhancements.

Initial implementation is on github.

### Action Items
Initial implementation with basic functionality is recently on github [1].

High priority ongoing enhancements:

* SSO (for both engine and cockpit)
* patternfly
* rpm packaging and oVirt's repository
* event-driven internal data update
* embedding in webadmin

More details and list of next planed enhancements can be found in the issue tracker, see [2]

## Detailed Description
![](/images/wiki/cockpit_vmsList.png) 
![](/images/wiki/cockpit_vmDetail.png) 
![](/images/wiki/cockpit_vdsmConfig.png) 

### Basic

* List VMs running on the host
* VM details with usage charts/statistics
* Shutdown/Force off the VM
* get Console
* edit vdsm.conf
* vdsmd.service management (hyperlink)

### With access to oVirt's engine
* cluster VMs list with details
* click-through to remote cockpit-ovirt plugin to see VM Detail
* run VM
* engine login SSO

### General
* look&feel supported by patternfly if not in contrary to other parts of Cockpit (recently not 100% achieved)
* packaged as RPM (.deb is not decided yet)
* access to the sub-screens (user components) via URL hashes:
    <pre>https://HOST:PORT/ovirt/ovirt#/[component]/[state]</pre>


## Implementation
The plugin is composed of

* single HTML page (ovirt.html)
    * defines plugin's layout
* JavaScripts (*.js)
    * implements majority of plugin's functionality
    * as stated in the Rules of Thumb section, no importnant business logic is implemented on plugin's side
    * keeps user-session state
    * requirements on 3rd party libraries are kept at minimum
    * spawns the vdsmJsonRPCCli.py to get data or invoke actions on VDSM or Engine
    * handles navigation in-/out-side of the plugin
    * sensitive information (like engine's token) are stored in the Window.sessionStorage
* backend (vdsmJsonRPCCli.py)
    * runs on the host under cockpit's logged user privileges
    * connects to VDSM via JSON RPC (utilizes jsonrpcvdscli.py)
    * stateless
    * bridges connection to the Engine
        * has access to engine's SSL certificate
        * browser does not require access to the engine

* Cockpit namely provides:
    * authentication
    * basic libraries (jquery, mustache)
    * CSS (reused as much as possible)
    * management and monitoring of the host and related services (networking, storage, system services, etc)


### Installation/Upgrade
Refer the plugin's README file for install instructions.

## External links
* [The plugin on github](https://github.com/mareklibra/cockpit-ovirt)
* [The Issue Tracker](https://github.com/mareklibra/cockpit-ovirt/issues)
* [The Plugin's README.md](https://github.com/mareklibra/cockpit-ovirt/blob/master/README.md) 
* [The Cockpit project](http://cockpit-project.org/ )

