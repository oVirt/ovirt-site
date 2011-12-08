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
*   Required configuration is posted and retrieved from a configuration server
*   Minimal size configuration bundle
*   Provide some sort of security for communications

## High Level Design

*   Machine boots and retrieves it's configuration bundle from the configuration server
*   Configuration bundle is extracted and applied
*   Machine makes itself available based on configuration

## Details

### Boot Process

*   Makes the most sense in a pxe environment, but can be done with usb or CD/DVD
*   Machine boots the image
*   Image comes up and processes command line options
    -   If not stateless, then continue with existing stateful functionality
*   Start network using DHCP on nic specified in BOOTIF
    -   ?? Default to eth0 otherwise ??
    -   ?? Or should we abort stateless attempt ??
*   Find your config server
    -   Multiple methods possible
    -   Get DNS SRV record for the configuration server
    -   provide config server on commandline
*   Check config server for config bundle

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

### Open Issues

*   Do we need something that prevents a host from uploading a new bundle while waiting for it to be approved?
*   What about updating configuration bundles?
*   How do we tell a host to create a new bundle even if one exists?
    -   kernel commandline?
    -   Admin on web server removes? <-- Do we need this anyway?
*   How do we handle the configuration server being down?
    -   boot and allow re-configuration?
    -   wait for it to be up?
    -   prompt user

## Security Considerations

How do we authenticate a node with the configuration server?

*   Multiple levels that could be done
*   USB drive that contains some certificate or key for encrypting and decrypting the bundle
*   Single key embedded in the pxe image
*   TPM module to contain unique key per machine **DEFERRED to future**
    -   motherboard upgrades would require a node to be re-registered and configured in this case

## Upgrades

*   Should be as simple as updating the PXE image (or usb stick or CD/DVD)
*   Shouldn't be much need to change the config bundle, but a new config bundle shouldn't be difficult to upload

## To Swap or Not To Swap

*   In order to overcommit a host, you need to have swap space to support it
*   First implementation will probably disable swap
*   Future implementation may allow the system to configure a local disk as swap space

## Future features

*   TPM/TXT Support for security

#### Config Server Future

*   Probably not for initial development but some considerations for the future
*   May want to integrate the config server into ovirt-engine and have all the management from there
*   Might want to investigate integrating with other heavyweight configuration servers
    -   Katello
    -   IPA
    -   etc...

<Category:Node>
