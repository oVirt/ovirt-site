---
title: Vm Parameters in REST API for Vm Pools
category: api
authors: sandrobonazzola, smelamud
feature_name: Vm Parameters in REST API for Vm Pools
feature_modules: rest-api
feature_status: Implemented
---

<!-- TODO: Content review -->

# Vm Parameters in REST API for Vm Pools

## Summary

Add VM parameters to VmPool collection in REST API. Currently a majority of the parameters available in the UI are missing from VmPool collection in REST API.

## Owner

*   Name: Shmuel Melamud (smelamud)
*   Email: <smelamud@redhat.com>

## Detailed Description

The problem is described in [Bug 1195167](https://bugzilla.redhat.com/show_bug.cgi?id=1195167).

Currently a majority of VM parameters that are available in the UI when adding VM Pool are missing from REST API VmPool collection. The parameters available for VmPool are:

*   `vmpool.cluster.id|name`
*   `vmpool.template.id|name`
*   `vmpool.name`
*   `vmpool.comment`
*   `vmpool.size`
*   `vmpool.max_user_vms`
*   `vmpool.display.proxy`
*   `vmpool.description`

That means that VM parameters are inherited from the template used and there is no way to override them on VmPool level. In contrary, WebAdmin UI has this feature.

The proposal is to add new `<vm>` subelement with all the VM fields into the `<vmpool>` element. The values of these fields will override the values of the corresponding template parameters. The structure will be as follows:

```xml
<vm_pool>
 <size>50</size>
       ...
 <template id="xxx"/>
 <vm>
  <some_overriden_field_a>new value</some_overriden_field_a>
  <some_overriden_field_b>new value 2</some_overriden_field_b>
 </vm>
</vm_pool>
```
