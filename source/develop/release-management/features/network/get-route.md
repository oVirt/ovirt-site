---
title: Get Route
category: feature
authors:
  - lvernia
  - phoracek
---

# Get Route

### Summary

New verb `getRoute` should return name of a device assigned to given IP address.

## Owner

*   Name: Petr Horacek (phoracek)

<!-- -->

*   Email: <phoracek@redhat.com>

## Detailed Description

During deployment of a new host, Engine needs to know which of the host's interfaces is used to connect to Engine. Currently, this is exposed by the \`lastClientIface\` element of \`getVdsCaps\` verb. However, this approach is problematic, as we plant to remove the requirement of direct Engine-Vdsm TCP connection, without which, Vdsm cannot compute this element.

Instead, it is suggested that Vdsm would expose the output of \`ip route get <addr>\`, so that Engine would be able to guess which on top of which host should it configure the management network. Note that this would only be a guess, as Vdsm may sit behind NAT with no route to Engine. In that case, automatic deployment of the management network would be skipped.

## Engine

<b>Overview:</b> Currently, the engine stores a host's "Active NIC", and uses it to decide on which interface it should set up the management network as part of the "Install Host" flow. This "Active NIC" is reported by VDSM as part of `getVdsCaps` (in the `lastClientIface` entry). With the introduction of the `getRoute` verb, the engine could use it for VDSM versions compatible with cluster >= 3.6 instead of the mentioned entry in `getVdsCaps`.

<b>Details:</b>This can be done by wrapping `getRoute` in its own VdsCommand class (e.g. `GetRouteVdsCommand`), and run that as part of `CollectVdsNetworkDataAfterInstallationVDSCommand.executeVdsBrokerCommand()` if the host's reported versions are compatible - then call `VDS.setActiveNic()` with the result. Similarly, the code setting the active NIC in `VdsBrokerObjectBuilder.updateNetworkData()` may be made dependent on older VDSM versions (this is likely optional - it might just be stored as null and overwritten later according to the result of `getRoute`), and removed when that API is officially deprecated.

## VDSM

To implement this new verb we could use `netinfo.getRouteDeviceTo(ip_address)` function, which uses `ipwrapper` to do route handling.

## Documentation / External references

*   [add a new getRoute() verb](https://bugzilla.redhat.com/show_bug.cgi?id=1117303)



