---
title: vdsm flowID
category: vdsm
authors: dougsland
---

# vdsm flowID

The idea is provide a mechanism to identify the transactions between ovirt engine and vdsm.

## Design

Any acceptable design must meet the following requirements:

*   vdsm should log the id of ovirt Engine transactions
*   Do not break API

## Owner

Douglas Landgraf <dougsland *AT* redhat *DOT* com>

## Development plan

*   Share initial patch into vdsmdevel and ask ideas
*   Implement the final version

## Status

**Merged**
 Subject:
Adding flowID
 Description:
This patch will implement the flowID schema in vdsm side. The idea is provide a mechanism to identify the flow between ovirt engine and vdsm API calls
in order to identify the entire scope of the backend action (which possibly consisted of several VSDM calls). At moment, we are
going to use HTTP headers to implement this feature to keep the compability with current API, avoiding possible breakes.
 Git Commit: ba607427f03526d8d7c030888ca3b9d9ad2c0807
<http://gerrit.ovirt.org/#patch,sidebyside,1221,7,vdsm/BindingXMLRPC.py>

