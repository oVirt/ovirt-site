---
title: Serial Console in CLI
category: cli
authors: dyasny, oernii, rmiddle
wiki_category: CLI
wiki_title: Features/Serial Console in CLI
wiki_revision_count: 4
wiki_last_updated: 2013-03-27
---

# Serial Console access within oVirt-CLI

### Summary

This document describes the VM Serial Console feature, it's use cases and specifications.

### Owner

*   Name: [ Dan Yasny](User:Dyasny)

<!-- -->

*   Email: <dyasny@redhat.com>

### Current status

*   Target Release: N/A
*   Status: N/A
*   Last updated date: N/A

### Detailed Description

A user in the CLI, with no GUI (X server or otherwise) is able to administer every aspect of oVirt, but is unable to open VMs' consoles, because that would require a graphical VNC or Spice window. the logical way to provide VM console access in GUI mode is to provide access to VMs' serial console.

#### User Experience

The user should be able to run a command, specifying a VM, and will have a VM's serial console opened in the shell he is working in.

### Documentation / External references

<http://libvirt.org/formatdomain.html#elementsConsole>

<Category:CLI>
