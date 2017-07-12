---
title: TUIredesign
category: feature
authors: fabiand
---

# TUI redesign

## Summary

This feature adds a new TUI to oVirt Node to address some shortcommings of the current implementation.

## Owner

*   Name: Fabian Deutsch (Fabiand)
*   Email: <fabiand@redhat.com>
*   IRC: fabiand at #ovirt (irc.oftc.net)

## Current status

*   Completed: POC
*   Completed: Design and document plugin layout
*   Completed: Design UI layout for all pages/tui-plugins (Status, Network, ...)
*   In progress: Implement logic for all pages/tui-plugins
*   Pending: Update plugin documentation and create a plugin writer guide
*   Pending: Update TUI builder to meet aesthetic demands/ux guidelines
*   Last updated: Oct. 25. 2012
*   Bug: <https://bugzilla.redhat.com/865017>

## Detailed Description

The TUI rewrite will use a different TUI toolkit (urwid) which is maintained and easily extendable. Additionally it is event based. Besides that every page in the new TUI is a TUI-Plugin which communicates with the main TUI through a limited number of methods, this allows a good separation of functionality and representation.

The sources are currently hosted at <https://www.gitorious.org/ovirt/ovirt-node-config-molch>

## Benefit to oVirt

The TUI solves problems with the old TUI:

*   Reacts to terminal resizes
*   Event based (no recursion problems)
*   Much easier to extend
*   UI not bound to specififc toolkit

## Dependencies / Related Features

Self contained except a dependency on python-urwid (not in oVirt Node yet) and common oVirt Node py libraries.

## Documentation / External references

TBD


