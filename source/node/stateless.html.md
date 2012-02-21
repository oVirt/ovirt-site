---
title: Node Stateless
category: node
authors: mburns, pmyers
wiki_title: Node Stateless
wiki_revision_count: 24
wiki_last_updated: 2012-05-29
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

### Boot Process

*   Makes the most sense in a pxe environment, but can be done with usb or CD/DVD
*   Machine boots the image
*   Image comes up and processes command line options
    -   If not stateless, then continue with existing stateful functionality
*   Process all commandline arguments as if this is auto-install
*   persist functions do nothing in these cases
*   Check for admin user password
    -   If set, continue
    -   If not, check for nopwprompt command line option
        -   If it exists, continue
        -   If not, provide TUI screen to set password only
            -   DESIGN: Extract tui screen from install setup for this
*   after all steps are complete, provide login prompt
*   Once configuration TUI is running, functions just like regular node

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

## Upgrades

*   Should be as simple as updating the PXE image (or usb stick or CD/DVD)

## To Swap or Not To Swap

*   In order to overcommit a host, you need to have swap space to support it
*   First implementation will probably disable swap
*   Future implementation may allow the system to configure a local disk as swap space

## Future features

*   TPM/TXT Support for security

## Old design

Kept around for reference, next update will remove

#### Previously configured

*   Retrieve the config bundle from the configuration server
*   Decrypt config bundle
*   Apply changes in config bundle
    -   ?? Do we need to (re)start services ??
*   Make node available to Engine

#### Not Configured

*   No config bundle found
*   Check for autoinstall parameters
*   Autoinstall
    -   Configure based on parameters
    -   Build configuration bundle
    -   Encrypt configuration bundle
    -   Send configuration bundle to config server
    -   Make available to Engine
*   TUI install
    -   Start configuration TUI
    -   After config is complete, User does something to confirm configuration
    -   On confirmation, build bundle, encrypt/sign, and send to config server
    -   Make available to Engine

### Configuration Server

*   A simple server that is running both an nfs and web server
*   New hosts will upload their new config bundles to the nfs server
*   OPTIONAL: Administrator confirms the new bundle and moves to web server
    -   Otherwise, web server can server from same location as nfs server
*   Provide web interface for admin to move and manage config bundles

<!-- -->

*   Suggested Frameworks:
    -   WebDAV
    -   nfs+apache (or similar web server)

#### Config Server Future

*   Probably not for initial development but some considerations for the future
*   May want to integrate the config server into ovirt-engine and have all the management from there
*   Might want to investigate integrating with other heavyweight configuration servers
    -   Katello
    -   IPA
    -   etc...

<Category:Node>
