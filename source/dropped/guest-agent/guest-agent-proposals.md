---
title: Guest agent proposals
authors:
  - abaron
  - mdroth
---

<!-- TODO: Content review -->

# Guest Agent Proposals

Summary of discussions from the ovirt workshop, and the qemu-devel and vdsm-devel mailing lists
(used to be at `http://thread.gmane.org/gmane.comp.emulators.ovirt.vdsm.devel/93/focus=93` but gmane service got discontinued)
regarding guest agents for oVirt.

## Considerations

VDSM/oVirt currently relies on the [ovirt-guest-agent](guest-agent.html) as the mechanism for servicing host-initiated
commands and data collection within a guest. QEMU relies on [qemu-ga](https://wiki.qemu.org/Features/GuestAgent) for similar purposes.

Additionally, there are a number of domain-specific agents, such as vdagent for Spice, and Matahari for virtualization-aware systems management.

Currently, ovirt-guest-agent and qemu-ga are the primary candidates under consideration. The purpose of this wiki page is to gather the oVirt requirements for a guest agent, along with the guest agent requirements for related projects, and outline the pros/cons of the existing proposals.

## Requirements

### oVirt

1.  Assistance in VM life-cycle:
    1.  "desktopShutdown" - Shuts the VM down gracefully from within the guest.
    2.  "quiesce" - does not exist today. This is definitely a requirement for us.

2.  SSO support for spice sessions (automatically login into guest OS using provided credentials):
    1.  "desktopLock" - lock current session, used when spice session gets disconnected / before giving a new user access to spice session
    2.  "desktopLogin"
    3.  "desktopLogoff"
    4.  reporting of relevant info (currently active user, session state)

3.  Monitoring and inventory:
    1.  memory usage
    2.  NICs info (name, hw, inet, inet6)
    3.  appslist (list of installed apps / rpms)
    4.  OS type
    5.  guest hostname
    6.  internal file systems info (path, fs type, total space, used space)
    7.  potentially, user-defined statistics via WMI/collectd

### QEMU

1.  first-class agent (same repo, available via QMP management interface, distributable via ISO, upgradeable via hypervisor push)
2.  guest reboot/shutdown, filesystem freeze for live snapshots
3.  project-agnostic primitives (file open/read/write/exec) to build higher-level interfaces (hypervisor-deployable scripts/binaries/executables, arbitrary data collection, etc)

### Spice

1.  User/session-level and system-level guest agent (particularly for copy/paste)
2.  Paravirtual mouse (needed to get mouse coordinates right with multi monitor setups)
3.  Send client monitor configuration, so that the guest os can adjust its resolution (and number and place of monitors) to match the client
4.  Copy and paste in a platform neutral manner, if anyone wishes to add this to another agent contact Spice team (specifically, hdegoede at redhat.com) first. This is easy to get wrong (went through 2 revisions of the protocol for this)
5.  Allow the client to request the guest to tone down the bling (for low spec clients)
6.  client <-> guest communication vs. host <-> guest communication (i.e. per-session "channel" and state rather than multiplexing a single QMP-session)

## Pros/Cons

### ovirt-guest-agent

*   pros
    -   Has been around for a long time (~5 years) - considered stable
    -   Started as rhevm specific but evolved a lot since then
    -   Currently the only fully functional guest agent available for ovirt
    -   Written in python
    -   Some VDI related sub components are written in C & C++
    -   Supports a well defined list of message types / protocol [3]
    -   Supports the folowing guest OSs, Linux: RHEL5, RHEL6 F15, F16(soon), Windows: xp, 2k3 (32/64), w7 (32/64), 2k8 (32/64/R2)
*   cons
    -   Not designed to be made consumable by QMP/QEMU directly
    -   No session-level agent
    -   Deployment complexity: The more complex the guest agent is, the more often it will need to be updated (bug/security fixes, distro compatibility, new features). Rolling out guest agent updates does not scale well in large environments (especially when the guest and host administrators are not the same person).

### qemu-ga

*   pros
    -   Qemu specific - it was aimed for specific qemu needs (mainly quiesce guest I/O and reliable guest shutdown)
    -   project agnostic by design: supports file open/read/write/close, and when exec functionality is added will have the ability to deploy/exec abitrary code as well as upgrade itself
    -   So far linux only, windows port in the works
    -   written in C
    -   Re-uses QMP transport and command schema, will be made transparent to QMP users once replacement QMP server is merged upstream
    -   Patches for libvirt integration available on list, plans for default installation on Fedora 17 guests
*   cons
    -   No plans for native high-level functionality: management tools extend functionality by deploying/executing scripts/binaries in guest, collect state by similar mechanisms, or reading files, etc.
    -   No session-level agent

## Proposals

### Leverage ovirt-guest-agent out-of-band where appropriate, use qemu-ga via QMP where appropriate

*   currently viable, but lots of wasted resources (duplication of efforts, extra packages, etc)

### Drop qemu-ga, consolidate around ovirt-guest-agent

*   blocker: Requires that ovirt-guest-agent be proxied through QMP management interface, subsumes existing qemu-ga commands. Also requires qemu.git submobule to access ovirt-guest-agent command schema to generate marshalling code for proxied commands.

      The need to converge is obvious, and now that ovirt-guest-agent is opensourced
      under the ovirt stack, and since it already produces value for enterprise
      installations, and is cross platform, I offer to join hands around ovirt-guest-agent
      and formalize a single code base that will serve us all.

      git @ git://gerrit.ovirt.org/ovirt-guest-agent

      Thoughts ?

      Thanks
      Barak Azulay

### Make ovirt-guest-agent functionality available via an executable or a set of scripts, and have hypervisor deploy+exec the functionality via qemu-ga file write/exec interfaces.

*   blocker: Requires exec support to be added (planned). Requires careful evaluation of security model.

      Today qemu-ga supports the following verbs: sync ping info shutdown
      file-open file-close file-read file-write file-seek file-flush fsfreeze-status
      fsfreeze-freeze fsfreeze-thaw.  If we add a generic execute mechanism, then the
      agent can provide everything needed by oVirt to deploy SSO.

      Let's assume that we have already agreed on some sort of security policy for the
      write-file and exec primitives.  Consensus is possible on this issue but I
      don't want to get bogged down with that here.

      With the above primitives, SSO could be deployed automatically to a guest with
      the following sequence of commands:

      ```
      file-open "<exec-dir>/sso-package.bin" "w"
      file-write <fh> <buf>
      file-close <fh>
      file-open "<exec-dir>/sso-package.bin" "x"
      file-exec <fh> <args>
      file-close <fh>
      ```

      At this point, the package is installed.  It can contain whatever existing logic
      exists in the ovirt-guest-agent today.  To perform a user login, we'll assume
      that sso-package.bin contains an executable 'sso/do-user-sso':

      ```
      file-open "<exec-dir>/sso/do-user-sso" "x"
      exec <fh> <args>
      file-close <fh>
      ```

      At this point the user would be logged in as before.

      Obviously, this type of approach could be made easier by providing a well
      designed exec API that returns command exit codes and (optionally) command
      output.  We could also formalize the install of additional components into some
      sort of plugin interface.  These are all relatively easy problems to solve.

      If we go in this direction, we would have a simple, general-purpose agent with
      low-level primitives that everyone can use.  We would also be able to easily
      extend the agent based on the needs of individual deployments (not the least of
      which is an oVirt environment).  If certain plugins become popular enough, they
      can always be promoted to first-order API calls in future versions of the API.

      --
      Adam Litke <alitke@redhat.com>
