---
title: Non plugin console invocation
category: feature
authors: fkobzik
---

# Non plugin console invocation

## Summary

Non plugin console invocation allows connecting to VM console from the engine frontend without the need of browser plugin. The feature is available for SPICE, VNC and RDP protocols.

## Owner

*   Name: Frank Kobzik (Fkobzik)
*   Email: <fkobzik@redhat.com>

## Detailed description

This feature adds to the engine the possibility of generating and serving configuration files for console viewer on the client system. The user can then associate corresponding viewer application to this file (using MIME type registration in browser) or alternatively use a script that parses the config file and runs appropriate application.

## Configuration

The actual invocation behavior can be configured via Console Options dialog in portals. The default behavior is configured separately for SPICE and RDP protocols using `engine-config`:

*   SPICE: `engine-config -s ClientModeSpiceDefault=value`, where `value` is one of `Auto`, `Plugin` or `Native`.
*   RDP: `engine-config -s ClientModeRdpDefault=value`, where `value` is one of `Auto`, `Plugin` or `Native`.
*   (for VNC the default behavior is always 'Native' as the only alternative is noVNC for the moment and this is not available on all deployments)

Explanation of client modes:

*   Plugin - The browser plugin is used for connecting to the console.
*   Native - The console configuration file is served to the client and then the native console client or alternative application is used.
*   Auto - if there is the console plugin installed in the browser, it is used. Otherwise native client is used.

## Note on Automatic Login feature with RDP

The activex-plugin way of invoking RDP console allows automatic user logon. The non plugin way doesn't support this feature for the moment (so the user has to punch in the credentials on console invocation). The reason for this is that RDP descriptor support storing passwords in plaintext (for security concerns).

## Benefit to oVirt

*   Provide an alternative way of invoking consoles.
*   Allow invoking console from browsers that don't support console plugins (SPICE in chrome, RDP in Firefox on MS Windows).

## Testing

### RDP

#### Test case

*   Create a VM with Windows OS type set, install Windows on it, allow Remote Desktop connections on it.
*   Select 'Native client' in Console Options dialog.
*   Click console button to invoke console.
*   Expected result: The RDP console is invoked (with possible dialog window informing user that they are invoking RDP console) with Windows logon screen.

