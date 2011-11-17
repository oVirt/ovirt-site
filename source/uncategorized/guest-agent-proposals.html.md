---
title: Guest agent proposals
authors: abaron, mdroth
wiki_title: Guest agent proposals
wiki_revision_count: 5
wiki_last_updated: 2011-11-17
---

# Guest Agent Proposals

Summary of discussions from the ovirt workshop, and the qemu-devel and vdsm-devel mailing lists (http://thread.gmane.org/gmane.comp.emulators.ovirt.vdsm.devel/93/focus=93) regarding guest agents for oVirt.

### Considerations

VDSM/oVirt currently relies on the ovirt-guest-agent (http://www.ovirt.org/wiki/Ovirt_guest_agent) as the mechanism for servicing host-initiated commands and data collection within a guest. QEMU relies on qemu-ga (http://wiki.qemu.org/Features/QAPI/GuestAgent) for similar purposes.

Additionally, there are a number of domain-specific agents, such as vdagent for Spice, and Matahari for virtualization-aware systems management.

Currently, ovirt-guest-agent and qemu-ga are the primary candidates under consideration. The purpose of this wiki page is to gather the oVirt requirements for a guest agent, along with the guest agent requirements for related projects, and outline the pros/cons of the existing proposals.

### Requirements

#### oVirt

1.  Assistance in VM life-cycle:
    1.  "desktopShutdown" - Shuts the VM down gracefully from within the guest.
    2.  "quiesce" - does not exist today. This is definitely a requirement for us.

2.  SSO support for spice sessions (automatically login into guest OS using provided credentials):
    1.  "desktopLock" - lock current session, used when spice session gets disconnected / before giving a new user access to spice session
    2.  "desktopLogin"
    3.  "desktopLogoff"
    4.  reporting of relevant info (currently active user, session state)

<!-- -->

1.  Monitoring and inventory:
    1.  memory usage
    2.  NICs info (name, hw, inet, inet6)
    3.  appslist (list of installed apps / rpms)
    4.  OS type
    5.  guest hostname
    6.  internal file systems info (path, fs type, total space, used space)
    7.  potentially, user-defined statistics via WMI/collectd

#### QEMU

1.  first-class agent (same repo, available via QMP management interface, distributable via ISO, upgradeable via hypervisor push)
2.  guest reboot/shutdown, filesystem freeze for live snapshots
3.  project-agnostic primitives (file open/read/write/exec) to build higher-level interfaces (hypervisor-deployable scripts/binaries/executables, arbitrary data collection, etc)

#### Spice

1.  User/session-level and system-level guest agent (particularly for copy/paste)
2.  Paravirtual mouse (needed to get mouse coordinates right with multi monitor setups)
3.  Send client monitor configuration, so that the guest os can adjust its resolution (and number and place of monitors) to match the client
4.  Copy and paste in a platform neutral manner, if anyone wishes to add this to another agent contact Spice team (specifically, hdegoede at redhat.com) first. This is easy to get wrong (went through 2 revisions of the protocol for this)
5.  Allow the client to request the guest to tone down the bling (for low spec clients)
6.  client <-> guest communication vs. host <-> guest communication (i.e. per-session "channel" and state rather than multiplexing a single QMP-session)

### Pros/Cons

#### ovirt-guest-agent

*   pros

1.  Has been around for a long time (~5 years) - considered stable
2.  Started as rhevm specific but evolved a lot since then
3.  Currently the only fully functional guest agent available for ovirt
4.  Written in python
5.  Some VDI related sub components are written in C & C++
6.  Supports a well defined list of message types / protocol [3]
7.  Supports the folowing guest OSs

       Linux: RHEL5, RHEL6 F15, F16(soon) 
       Windows: xp, 2k3 (32/64), w7 (32/64), 2k8 (32/64/R2)

*   cons

1.  Not designed to be made consumable by QMP/QEMU directly
2.  No session-level agent

#### qemu-ga

*   pros

1.  Qemu specific - it was aimed for specific qemu needs (mainly quiesce guest I/O)
2.  project agnostic by design: supports file open/read/write/close, and when exec functionality is added will have the ability to deploy/exec abitrary code as well as upgrade itself
3.  So far linux only, windows port in the works
4.  written in C
5.  Re-uses QMP transport and command schema, will be made transparent to QMP users once replacement QMP server is merged upstream
6.  Patches for libvirt integration available on list, plans for default installation on Fedora 17 guests

*   cons

1.  No plans for native high-level functionality: management tools extend functionality by deploying/executing scripts/binaries in guest, collect state by similar mechanisms, or reading files, etc.
2.  No session-level agent

### Proposals

*   Drop qemu-ga, consolidate around ovirt-guest-agent:
    -   blocker: Requires that ovirt-guest-agent be proxied through QMP management interface, subsumes existing qemu-ga commands. Also requires qemu.git submobule to access ovirt-guest-agent command schema to generate marshalling code for proxied commands.

<!-- -->

*   Make ovirt-guest-agent functionality available via an executable or a set of scripts, and have hypervisor deploy+exec the functionality via qemu-ga file write/exec interfaces.
    -   blocker: Requires exec support to be added (planned). Requires careful evaluation of security model.

<!-- -->

*   Leverage ovirt-guest-agent out-of-band where appropriate, use qemu-ga via QMP where appropriate
    -   currently viable, but lots of wasted resources (extra libvirt integration work, duplification of efforts, extra packages, etc)
