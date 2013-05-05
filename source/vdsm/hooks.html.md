---
title: Vdsm Hooks
category: vdsm
authors: amuller, danken
wiki_category: Vdsm
wiki_title: Vdsm Hooks
wiki_revision_count: 14
wiki_last_updated: 2014-02-26
---

# VDSM Hooks

### Writing a new hook

This patch may be used as reference: <http://gerrit.ovirt.org/#/c/12833/>

When creating a new vdsm hook, create a directory for it and place it under vdsm_hooks. Each hook should contain at minimum three files:

1.  Makefile.am - You may copy an existing Makefile.am from another hook and make the appropriate changes.
2.  README - The readme should include any known gotchas, custom properties required by the hook and any domxml changes made by the hook.
3.  And the event at which the hook is fired. For example: before_vm_start. Here is where you write the actual code. Your hook may implement several events of course.

Additionally, the following changes have to be made:

1.  vdsm_hooks/Makefile.am - Add your hook name to the section at line 25.
2.  configure.ac - Add your new hook name under the section beginning at line 196.
3.  vdsm.spec.in - Your new hook must be placed in two different spots:

Hooks placed below line 993 are non-required hooks, while hooks immediately above that line are installed as part of the installation even if hooks are not explicitly enabled. Finally, you must add a package summary and description under the section at line 291.

During installation, hooks are placed at /usr/libexec/vdsm/hooks/hook_event/your_hook_name
where hook_event is one of before_vm_start, before_migrate_source and so on.

### Creating a new hook point

This patch may be used as reference: <http://gerrit.ovirt.org/#/c/13411/>

If needed additional hook points may be implemented to respond to new events.

Four changes need to be made:

1.  vdsm.spec.in - Insert your new event (Which might actually be two as you often implement before and after the event) at the section under line 795. This will add your new directories to the RPM listing.
2.  vdsm/hooks.py - Add your new hook points. Your new function will call _runHooksDir, which simply executes all scripts in the directory you pass it.
3.  vdsm/vdsmd.8.in - VDSM's man page lists all of the different hook points and so you must add yours to the list. It is required you read the man page and see if any additional changes have to be made because of your new hook point.
4.  vdsm_hooks/Makefile.am - Add your new folder names to the section under line 61. This will cause the new hook point directories to be created during installation.

<Category:Vdsm> <Category:Documentation>
