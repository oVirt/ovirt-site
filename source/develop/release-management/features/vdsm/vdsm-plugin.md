---
title: Node vdsm plugin
category: feature
authors: mburns
---

# Node vdsm plugin

## oVirt Node VDSM plugin

### Summary

This feature converts the generic oVirt Node image into an image customized use with oVirt Engine.

### Owner

*   Name: Mike Burns (mburns)

<!-- -->

*   Email: mburns AT redhat DOT com
*   IRC: mburns


### Detailed Description

An offshoot of the [Universal Node Image](/develop/release-management/features/node/universal-image.html) feature. This plugin can be used to convert a generic oVirt Node image into an image ready for use with oVirt Engine.

### Benefit to oVirt

Because of the [Universal Node Image](/develop/release-management/features/node/universal-image.html) feature, there would be no more oVirt Node image available with the oVirt Project. This plugin is simply the moving of the logic for interacting with oVirt Engine from oVirt Node into a plugin.

### Dependencies / Related Features

*   [Universal Node Image](/develop/release-management/features/node/universal-image.html)
*   Affected Packages
    -   ovirt-node
    -   ovirt-node-iso
    -   New Package: ovirt-node-plugin-vdsm (Name TBD)

### Testing

Cover all methods for registering an oVirt Node to oVirt Engine

| Test                                             | Steps                                                                                                                  | Expected Result                                                                      | Status | Version |
|--------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|--------|---------|
| Auto-install (HTTPS)                             | Register with https using autoinstall (management_server=host:port)                                                   | Host should show up in Engine to be approved                                         |        |         |
| Auto-install (HTTP)                              | Register with http using autoinstall (management_server=host:port) (port 80)                                          | Host should show up in Engine to be approved                                         |        |         |
| Auto-install (password)                          | autoinstall with rhevm-admin-password                                                                                  | Root password should be set correctly, ssh password authentication should be enabled |        |         |
| TUI -- HTTPS                                     | Register with Host/Port on the TUI, confirm certificate, host should appear                                            | Host should appear in engine for approval                                            |        |         |
| TUI -- HTTP                                      | Register with Host/Port on the TUI using HTTP ports (80)                                                               | Host should appear for approval in Engine                                            |        |         |
| TUI -- password                                  | Set password in the TUI oVirt Engine screen                                                                            | Root password should be set; ssh password authentication should be enabled           |        |         |
| Engine Add Host                                  | After setting password (either through the TUI or autoinstall), use Add Host flow in the Engine to add oVirt Node Host | Host should be added and activated correctly                                         |        |         |
| Engine approval                                  | After registering (Tui host/port or autoinstall management_server), approve oVirt Node host in Engine                 | Host should be approved successfully                                                 |        |         |
| Negative: invalid hostname/ip                    | set invalid host/ip on the hostname line in the tui                                                                    | On screen warning should be shown, should not let you commit changes                 |        |         |
| Negative: invalid port                           | set invalid port (letters, blank, special chars) on the hostname line in the tui                                       | On screen warning should be shown, should not let you commit changes                 |        |         |
| Negative: reject certificate                     | when registering with engine, reject the downloaded certificate                                                        | You should not be able to submit the changes                                         |        |         |
| Negative: don't match password with confirmation | set password to something and set confirmation to something else                                                       | On screen warning should be shown, should not let you commit changes                 |        |         |
| Retrieve certificate                             | Click on retrieve certificate (with https)                                                                             | Screen should cleanly display the fingerprint and provide accept/reject offer        |        |         |
| Acccept certificate                              | Accept certificate                                                                                                     | Should return and say that the certificate has been accepted                         |        |         |
| Negative - retrieve cert from incorrect host     | retrieve cert from an incorrect host/ip (typo like engin.example.com instead of engine.example.com)                    | Screen should cleanly report error retrieving the certificate.                       |        |         |

### Documentation / External references

*   Coming Soon




