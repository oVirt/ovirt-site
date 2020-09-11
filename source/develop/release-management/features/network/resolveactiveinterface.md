---
title: ResolveActiveInterface
category: feature
authors: elevi
feature_name: Resolve Active Interface
feature_modules: engine,network
feature_status: Development
---

Features/ResolveActiveInterface

# Resolve Active Interface

## Summary

The feature will extend the engine ability to resolve the active interface in which vdsm uses to communicates over it with engine.

## Owner

*   Name: Eliraz Levi



## Detailed Description

When adding host to the Data Center, engine will instruct vdsm (if required) to deploy management network.
However, engine must first know, the correct interface to deploy the management network on top of it.
Until now, engine acquired the correct interface by looking at the lastClientIface element of VdsGetCapabilities verb.
As approaching the removal of the direct Engine-Vdsm TCP connection requirement, vdsm will no longer be able to compute the lastClientIface element.
Instead, engine will resolve the correct interface as followed next:
engine will resolve the host ip address by using the java's INetAddress.getByName function. The limitation of this approach will be discussed later.
Next, engine will compare between the resolved host's ip address and the one that owned (if exists) by each of host's interfaces. In case of a match, the interface will be resolved as the hostActiveNic.
note that the host's interface's ip address, is reported by vdsm's VdsGetCapabilities verb.
 The main concept of the feature, is that in case of a "nested" network topology configuration , only the top Link-Layer component will own an ip address.
for example:

      == network layout ==
    bond0        slaves=ens1, ens2

in this case, only bond0 will own an ip address (if configured) as it the top Link-Layer component.

Note that in case vdsm is communicating with engine over a bridge, the bridge will be resolved as "hostActiveNic".
important to mention that oVirt doesn't support deployment of management network over a bridge, resulting with a setup network failure in this scenario.

## Benefit to oVirt

Engine will be able to resolve the host active interface, without being depended on vdsm to report it. By doing so, freeing vdsm from reporting it and helps to break the Engine-Vdsm TCP connection dependency which is required to be eliminated.

## Dependencies / Related Features

vdsm:

*   eliminating the need of "get route" vdsm's verb.
*   lastClientIface element of getVdsCapabilites verb will be no longer needed.

## Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

## Testing

*   Verification of management network setup in different network topology configurations:
    -   one nic owns the same ip address as host-ip.
    -   multiple nics own an ip address , only one has the resolved host-ip address.
    -   multiple nics own an ip address , more than one has the resolved host-ip address.
        -   note that this scenario is possible in case that DNS host name resolution has more than one ip address.
    -   bond with nics, bond owns the same ip address as host-ip.
    -   all the scenario above, with VLAN configured on top.
    -   all the scenario above, with Bridge configured on top (should fail).
*   UTest in which will mock host interfaces and confirm that the correct interface is being resolved as hostActiveNic

## Feature Limitations

*   In case host name resolution has more than one ip address, the following scenario is possible:
    -   Let be a host with two interfaces "A" with ip "a.a.a.a", "B" with ip address "b.b.b.b".
    -   The DNS is configured to has two ip address resolutions of the host under the key "host name".
    -   Say that host with name "host name" was added to the Data Center before.
    -   The DNS name resolution of "host name" was "a.a.a.a" and management network was deployed over interface "A" with ip "a.a.a.a" as interface "A" was resolved to be the hostActiveNic.
    -   Later the host was removed from the Data Center.
        -   Note, in this case the host's network configuration is not being reverted as before the host was initially added to the Data Center, resulting the management network to still be configured at the host.
    -   Later, the host was added again, but this time the DNS name resolution was "b.b.b.b", resulting interface "B" to be resolved as hostActiveNic.
    -   In this case, the management network deployment will failed as it fail to pass the validation of NETWORKS_ALREADY_ATTACHED_TO_IFACES.

## Contingency Plan

Explain what will be done in case the feature won't be ready on time

## Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes

## Comments and Discussion

*   important to mention, the original "GetRoute" feature in which a new vdsm verb defining an API of engine telling the host its ip address. Vdsm will then response with the hostActiveNic.
    -   The feature was abandoned as engine is not able to tell vdsm it's own ip address as same as vdsm is seeing it as the engine can be hiding behind NAT for example.

