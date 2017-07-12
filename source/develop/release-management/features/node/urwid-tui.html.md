---
title: Urwid TUI
category: feature
authors: fabiand
---

# Urwid TUI

## Summary

This feature introduces new TUI components (installer and setup) based on urwid, this modern !tui toolkit" is event driven and supports features like mouse input.

## Owner

*   Name: Fabian Deutsch (fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

## Current status

*   Last updated: ,

## Detailed Description

The old UI had several limitations and many bugs were opened (partially unfixable due to the nature of snack/newt the old "tui toolkit"). The rewrite of the TUI components is not only a migration to [excess.org/urwid/ urwid] but also a refactoring to address common problems with the old UI e.g. a general solution to validate values, a clean solution to display popus, …. Besides that a focus was also set on keeping the code testable, that means to isolate functions which rely on runtime-informations from the actual representation and runtime-independent parts.

## Benefit to oVirt

Making oVirt Node more generic and available to other projects widens the user base for the model that oVirt Node uses. This model will then get additional testing and use outside of the oVirt Project and thus be more stable in the long term.

The new UI components fix a lot of old bugs and offers features which solve many of the common problems. Besides that it offers an UI independent API for plugins to add new pages to the installer and/or setup. besides that it offers a better user experience.

## Dependencies / Related Features

*   Affected Packages
    -   ovirt-node
*   New Package for the UI
    -   python-urwid

## Documentation / External references

*   Coming Soon




