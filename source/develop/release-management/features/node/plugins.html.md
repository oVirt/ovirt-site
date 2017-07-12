---
title: Node plugins
category: node
authors: apevec, iheim, jboggs, kmestery, mburns, pmyers
---

# Node plugins

## 3rd Party Plugins for oVirt Node (Fedora remix)

This outlines a plan for adding 3rd party software to the released oVirt Node ISO images. While it may not make sense for the upstream project, where you could simply rebuild the image, it is important for the released products based on oVirt Node to allow extending functionality while still keeping it compatible.

### Goals

*   Provide tools to allow 3rd parties (ISVs/IHVs) to develop plugins that can be injected into oVirt Node ISO images.
*   Provide tools to consumers of oVirt Node to allow them to inject one or more plugins into oVirt Node ISO images.
*   Provide integrity checking and certification tools for the rebuilt ISO images.
*   Provide guidelines for 3rd party plugin writers.
*   Provide reporting (via vdsm?) so ovirt engine can present which plugin and versions are installed on a node

### Current Build Process

*   LiveCD ISO image, build instructions from git: [Node_Building](/develop/projects/node/building/)

### Requirements

#### Version 1 Requirements

*   Ability for 3rd party developers/vendors to write/adapt software for installation into an oVirt Node.
*   Multiple plugins able to be installed simultaneously without interfering with each other.
*   To isolate plugins from each other and to prevent misconfiguration, it is strongly recommended (but not required) that plugins reside under /opt/VENDOR/PLUGIN_NAME
    -   This includes lock files, configuration files, and library files
        -   /opt/VENDOR/PLUGIN_NAME/var/lock/
        -   /opt/VENDOR/PLUGIN_NAME/etc/
        -   /opt/VENDOR/PLUGIN_NAME/usr/lib/
*   Ability for third-party vendors or direct end-users to add plugins to the Node.
*   Method for plugins to specify auto-installation parameters and handling
    -   Mostly already handled, but need to formalize
    -   add file with list of autoinstall options, one per line, to /etc/ovirt-commandline.d
    -   add handling script for autoinstall scripts to ovirt-config-boot.d
*   Protection against unverified/unauthorized plugins from being injected into a Node.
*   Tracking of all plugins injected or updated on the Node including manifest deltas for all files, packages and configuration changes.
*   Third party plugins may have the need for persistent storage. This can be handled either on host (stateful) or off host (stateless).
    -   For how this would be handled in a stateless environment, this feature would be dependent on [Node_Stateless](/develop/projects/node/stateless/)
*   Plugins are installed via an offline ISO injection process. Runtime installation and updating of plugins is not implemented.
*   Ability to upgrade a plugin by injecting a new version of the plugin into an existing offline Node ISO and then upgrading the Node via USB/CDROM/PXE boot.
    -   NOTE: This is dependent on the ability of the plugin itself to handle upgrades meaning plugins need to keep backwards compatibility with configuration files and other metadata.
*   Plugins cannot modify any configuration directly in /etc, therefore plugin metadata must be constructed with allows controlled changes like:
    -   Entries including cron/logrotate/systemd/selinux configuration files will be handled during the plugin injection process and will be placed in their appropriate locations
    -   Opening firewall ports
    -   Adding users/groups
    -   Enabling system services via init scripts/systemd units
    -   Additional metadata TBD

#### Version 2 Requirements

*   Enable runtime injection and upgrade of plugins
    -   Plugins packages are treated similar to 'configuration data' and can be installed either from the remote configuration store or from the local /data partition.
    -   Plugins are installed on boot, and configuration files are applied dynamically.
    -   Plugins can be updated runtime, and updates to runtime plugins will persist the plugin bundle to the remote configuration store or local /data partition so that the updated plugin is used on reboot.

### Proposed Process

#### For 3rd Party Packager

*   Package 3rd party software in RPM, following [Fedora Packaging Guideline](http://fedoraproject.org/wiki/Packaging/Guidelines)
*   In addition to normal Fedora Guidelines, will need to use additional guidelines being presently developed for a new concept called Stacks. This will be proposed and ideally integrated into the Fedora Guidelines, but it covers topics like:
    -   Structured namespace located under the /opt directory with a format like: /opt/<vendor>/<plugin name>.
    -   Spec file conventions that utilize the /opt structure rather than normal /usr /etc structures.
    -   Utilizing these guidelines, we can open /opt up in /etc/rwtab, eliminating the normal issues encountered with / being nominally stateless. Plugins will be able to write to anything under /opt normally. This means that each plugin will need to maintain their own etc, var, bin, lib structures in their namespace. (For example: /opt/vendor/myplugin/var/run/myplugin.pid)
    -   This also implies that vendors will need to write their plugins to be compliant with these guidelines. It will not be possible to take stock RHEL software and assume that it will 'just work' as an oVirt Node plugin.
    -   See [Fedora Software Collections](http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/Software_Collections_Guide/index.html) Documentation for more details of the thought process behind this.
    -   a metadata file (format TBD, possibly XML or maybe included in the kickstart)
        -   vendor name
        -   plugin name
        -   plugin version
        -   firewall ports to open
        -   users to create (including UID information)
        -   groups to create (including GID information and group membership)
        -   services (systemd/init scripts) to enable
        -   kernel modules to install/enable
        -   minimum version of oVirt Node that it can be installed in
        -   Additional metadata can be added to the specification as need is determined, but new metadata will require updates to the plugin tooling as well as possibly to oVirt Node itself. Therefore, the plugin tooling should have a version associated with it, and specific plugins should be specified to require a minimum version of the plugin tooling to support injecting the plugin into a Node. And the Node should only accept plugins that are compatible with it.
            -   For example, Node is version 3 and knows how to process opening firewall ports, but does not understand how to create new users. Therefore, plugins that require new users would be incompatible with this version of the Node.
    -   a collection of packages
        -   For the Fedora based oVirt Node, these will be RPMs, other distributions can use their own package formats.
        -   Each package must be written to install to the 'stacks' location in the /opt filesystem
        -   Dependencies on the kernel or other things that would require a rebuild of the initramfs cannot be allowed since the kernel can not be updated in oVirt Node
        -   All RPMs included in a plugin tarball can be optionally signed with a gpgkey.
*   All of the above can be done with standard tools and some recipe/metadata templates that instruct the ISV/IHV on how to build a compliant plugin. No special tooling should be necessary here.

#### For End User

*   Tool for injecting plugins based on edit-livecd code: edit-node
*   edit-node should handle the following tasks:
    -   validation of the plugin by checking the metadata/kickstart for syntax/policy errors
    -   validation of rpm signatures using a set of valid certificates that are bundled with the tool
    -   resolution of dependencies that need to be included from an external repository
        -   For example, plugin foo requires tog-pegasus, so download that from the Fedora yum repository
*   edit-node should also be capable of operating in two modes:
    -   offline ISO editing mode for v1 feature
        -   this will use edit-livecd functionality to crack up the ISO, chroot it and perform local operations
    -   online plugin injection mode for v2 feature
        -   this will use a control channel (SSH or Matahari perhaps) to interact with and run live operations on the Node
*   To determine dependency resolution deltas, edit-node must either use the rpm database of the offline Node ISO or the live running Node. yumdownloader can be used from the host running edit-node to download dependencies and then bundle those dependencies with the plugin tarball for installation either on the offline or online image
*   edit-node will also create manifests for all changes
    -   During oVirt Node ISO creation, a set of manifests are created for rpm and file manifests
    -   During plugin injection (either online or offline), manifest deltas should be created and persisted to either the ISO image or to the persistent config store (remote or local disk) so that a record of all changes to the image from every plugin can be tracked by date.
    -   These manifests should also contain listing of all config changes made from the metadata instructions
*   Validation/Signing
    -   By default the injection tooling will validate the gpg signartures of all RPMs to be installed to make sure they are signed by a valid provider.
    -   The 3rd party plugin injection tool should provide an argument to pass the equivalent of --no-gpg so that this behavior can be overridden.
    -   Each 3rd party software developer will have their own private/public keypair and the stock oVirt Node will include the public keys. The gpg verification should be done by certificates installed inside the Node itself, so that both the offline and online plugin injection mechanism can benefit from it.

<!-- -->

*   Usage
    -   Install a local rpm and use a repo for dependency resolution
        -   edit-node --install-plugin ./vdsm.rpm --repo=<http://ovirt.org/releases/stable/f16> $iso_file
    -   Install plugin directly from a yum repo
        -   edit-node --install-plugin vdsm --repo=./myrepo $iso_file
    -   Plugin name should be set with --ver
        -   edit-node --install-plugin vdsm --repo=./myrepo --ver foo $iso_file
    -   Installing multiple plugins
        -   edit-node --install-plugin "foo, bar" --repo ./myrepo --ver foo $iso_file
    -   Based on [Node versions numbers](/develop/projects/node/versions-numbers/):
        -   New version: ovirt-node-iso-2.3.0-1.1.1.foo.f16.iso
        -   Second version: ovirt-node-iso-2.3.0-1.1.2.foo.f16.iso
    -   Other Features
        -   List Plugins
            -   edit-node --list-plugins node.iso
        -   Print Plugin Manifests
            -   edit-node --print-manifests

