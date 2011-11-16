---
title: Node plugins
category: node
authors: apevec, iheim, jboggs, kmestery, mburns, pmyers
wiki_category: Node
wiki_title: Node plugins
wiki_revision_count: 20
wiki_last_updated: 2012-08-20
---

# Node plugins

## Plugin Plan for oVirt Node (Fedora remix)

This outlines a plan for adding 3rd party software to the released oVirt Node ISO images. While it may not make sense for the upstream project, where you could simply rebuild the image, it is important for the released products based on oVirt Node to allow extending functionality while still keeping it compatible.

### Goals

*   Provide tools for easy rebuilding of the oVirt Node ISO image with added software.
*   Provide integrity checking and certification tools for the rebuilt ISO images.
*   Provide guidelines for 3rd party plugin writers.

### Current Build Process

*   LiveCD ISO image, build instructions from git: [Node_Building](Node_Building)

### Requirements

*   Ability for third-party vendors to add packages to the node.
*   Third party packages may have the need for persistent storage. This can be handled either on host (stateful) or off host (stateless).
*   Third party packages need to be upgradable.
*   Third party packages should be able to hot-add (e.g. not require reboot of the node).

### Proposed Process

#### For 3rd Party Packager

*   Package 3rd party software in RPM, following [Fedora Packagking Guideline|<http://fedoraproject.org/wiki/Packaging/Guidelines>]
    -   Additional guidelines are need for Stateless support (e.g. only certain folders are writable and persistence must be explicit)
*   Resolve dependencies via e.g. yumdownloader and remove those already in the oVirt Node image
    -   Provide a script to handle above
*   Create manifests with checksums
*   Create plugin recipe (abbreviated kickstart) for edit-livecd: -k --kickstart option
    -   Requires not-yet-upstream patch edit-livecd which adds kickstart option for using kickstart file as an recipe for editing a livecd image.

      Following kickstart directives are honored:
`part / --size `<new rootfs size to be resized to>
      bootloader --append "!opt-to-remove opt-to-add"
`repo --baseurl=`[`file://path-to-RPMs`](file://path-to-RPMs)
      %pre
      %post
      %packages

*   Package 3rd party RPM and all its dependencies in a TBD plugin format: tarball with manifest and edit-livecd kickstart recipe at the top and a subfolder with RPMs
    -   Plugin should also include oVirt Node ISO version which it is compatible with.
*   Rebuild and verify end result ISO using a wrapper script (ovirt-plugin-build)
    -   Provide a script for a quick smoke test/self-certification?
        -   Verify that TBD core part of the image is not modified

#### For End User

*   Get required oVirt Node ISO image version
*   Get plugin from the 3rd party and rebuild ISO with a wrapper script (ovirt-plugin-build) which runs:
    -   edit-livecd using plugin recipe and provided packages
    -   verifies the end-result image against the checksums list in the plugin
*   Install end-result image normally.

[Category:Node development](Category:Node development)
