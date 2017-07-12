---
title: Node Stateless
category: node
authors: mburns, pmyers
---

# Node Stateless

## Goals

*   Be able to run a node image without installing to local disk
*   No configuration is persisted
*   Provide some sort of security for communications

## High Level Design

*   Machine boots with regular kernel commandline params + stateless
*   Machine does regular boot process including autoinstall for all args passed
*   Machine launches Configuration TUI after complete for additional config if needed
*   Machine runs normally

## Details

### TODO List

*   Check for admin user password
    -   If set, don't set it to expire and continue
    -   If not, check for nopwprompt command line option
        -   If it exists, continue
        -   If not, provide TUI screen to set password only
            -   DESIGN: Extract tui screen from install setup for this
*   Swap/local storage disk handling
    -   Provide a method for admin to allocate swap
    -   Provide method for admin to designate disk as local data domain

### Boot Process

*   Makes the most sense in a pxe environment, but can be done with usb or CD/DVD
*   Machine boots the image -- **DONE**
*   Image comes up and processes command line options -- **DONE**
    -   If not stateless, then continue with existing stateful functionality -- **DONE**
*   Process all commandline arguments as if this is auto-install -- **DONE**
*   persist functions do nothing in these cases -- **DONE**
*   Check for admin user password
    -   If set, don't set it to expire and continue
    -   If not, check for nopwprompt command line option
        -   If it exists, continue
        -   If not, provide TUI screen to set password only
            -   DESIGN: Extract tui screen from install setup for this
*   after all steps are complete, provide login prompt
*   Once configuration TUI is running, functions just like regular node -- **DONE**

### Offline Password Setting

**This is part of Plugins, but stateless depends on it.**

*   Goal: Provide a way to set the admin password offline
*   Reasoning: Insecure to set the password on the kernel commandline
*   Design
    -   Use Plugin Methodology
    -   Plugin will take commandline arguments, crack open the ISO, and set the password
    -   Version 1: non-interactive, command line only, admin password only
        -   Handles clear-text passwords and pre-encrypted passwords
        -   Possibly use password file instead of passing the password on the command line where it would show up in shell history
    -   Version n: simple UI, can set admin and root passwords, interactively set passwords

### Open Issues

*   Engine Registration process
    -   Not currently able to handle stateless
    -   Would currently require the admin to go into engine, manually remove the host, then re-add the host and approve it with \*every\* boot

## Security Considerations

How do we authenticate a node with the engine?

*   Multiple levels that could be done
*   USB drive that contains some certificate or key for encrypting and decrypting the bundle
*   Single key embedded in the pxe image
*   TPM module to contain unique key per machine **DEFERRED to future**
    -   motherboard upgrades would require a node to be re-registered and configured in this case

<!-- -->

*   Because Engine doesn't have a way to support stateless nodes, they need to be removed manually, then re-added
    -   The nodes thus need to be re-approved by the engine admin, making these concerns an issue when Engine supports stateless, but not an issue currently.

## Upgrades

*   Should be as simple as updating the PXE image (or usb stick or CD/DVD)

## Storage

Since it's stateless, we probably don't want to touch HostVG at all. Instead, we can leverage AppVG which is already setup for supporting Swap and Data storage.

### To Swap or Not To Swap

*   In order to overcommit a host, you need to have swap space to support it
*   First implementation will probably disable swap
*   Future implementation may allow the system to configure a local disk as swap space

### Local Storage

*   In order to support local storage domains, we need to partition and allocate a disk
*   Need to support some method for re-creating the local storage during boot
*   Provide a TUI screen for storage config

## Future features

*   TPM/TXT Support for security
