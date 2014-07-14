---
title: VDSM VM Query API
category: api
authors: vfeenstr
wiki_title: Feature/VDSM VM Query API
wiki_revision_count: 5
wiki_last_updated: 2014-07-14
feature_name: VDSM VM Data Query API
feature_modules: vdsm, engine-backend
feature_status: Proposed
---

# VDSM VM Data Query API

### Summary

This feature proposes a new API verb for VDSM for querying the data fields of VMs via the RPC interface. The feature allows to get differences since the last request, asking for specific fields and/or excluding fields from the data retrieved.

### Owner

*   Name: [ Vinzenz Feenstra](User:Evilissimo)
*   Email: <evilissimo@redhat.com>

### Current status

*   Last updated on -- by [ WIKI}}](User:{{urlencode:{{REVISIONUSER}})

### Detailed Description

**new verb:** *Host.queryVms(vmIds=[], fields=[], exclude=[], changedSince=' ')* **vmIds:** queries the vms specified or all when the list is empty **fields:** queries only for the fields specified or all when empty **exclude:** excludes the fields specified or none if empty **changedSince:** queries only for the fields which changed since the given stamp. (fields and exclude parameters are respected, so only fields matching will be checked and returned)

The call returns a structure like this:

       {'dataList': [{
         vmId: "`<uuid>`",
      `    `fields queried for`... `
        }],
        'queryStamp': 'a string value indicating the lastest changes and passed to changedSince in a follow up request'}

*Boilerplate status/message omitted in the result for simplification reasons*

### Benefit to oVirt

The proposed API verb can reduce the required volume of data sent over the management network to in a range of 75-90% **without using compression**. Please see the [Measurements Page](Feature/VDSM VM Query API/Measurements) for the actual results of the tests performed using this API in comparison to the current way. This proposal introduces a more flexible way of changing the API by adding new fields or deprecating them by exclusion from the callers side. Additionally fields are only sent when they have been really changed since the last request.

### Dependencies / Related Features

TODO

### Documentation / External references

TODO

### Testing

TODO

### Comments and Discussion

This below adds a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

*   Refer to <Talk:Feature/VDSM_VM_Query_API>
