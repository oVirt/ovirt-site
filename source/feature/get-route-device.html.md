---
title: Get Route Device
authors: lvernia, phoracek
wiki_title: Features/Get Route Device
wiki_revision_count: 5
wiki_last_updated: 2014-09-08
feature_name: Get Route Device
feature_modules: engine, api
feature_status: Proposed
---

# Get Route Device

#### Summary

New verb `getRoute` should return name of a device assigned to given IP address.

### Owner

*   Name: [ Petr Horacek](User:phoracek)

<!-- -->

*   Email: <phoracek@redhat.com>

### Detailed Description

During deployment of a new host, Engine needs to know which of the host's interfaces is used to connect to Engine. Currently, this is exposed by the \`lastClientIface\` element of \`getVdsCaps\` verb. However, this approach is problematic, as we plant to remove the requirement of direct Engine-Vdsm TCP connection, without which, Vdsm cannot compute this element.

Instead, it is suggested that Vdsm would expose the output of \`ip route get <addr>\`, so that Engine would be able to guess which on top of which host should it configure the management network. Note that this would only be a guess, as Vdsm may sit behind NAT with no route to Engine. In that case, automatic deployment of the management network would be skipped.

### Engine

During "Add Host" flow, Engine defines the management network on the added host. It decides which interface should be used for that network based on the `lastClientIface` element. `lastClientIface` is to deprecated, so Engine should use the new verb when for clusterLevel>3.6

### VDSM

To implement this new verb we could use `netinfo.getRouteDeviceTo(ip_address)` function, which uses `ipwrapper` to do route handling.

### Documentation / External references

*   [add a new getRoute() verb](https://bugzilla.redhat.com/show_bug.cgi?id=1117303)

### Comments and Discussion

*   Refer to [Talk:Get Route Device](Talk:Get Route Device)

<Category:Feature> <Category:Networking>
