---
title: Editable Field Annotations Consolidation
author: phbailey
tags: community, news, documentation, infrastructure
date: 2016-06-20 14:00:00 EST
---

Robust functionality with minimum verbosity and complexity is a goal for which developer’s often strive. To that end, we have refactored the annotations used to indicate which fields are editable for hosts and VMs.

## The Problem

Prior to the change, the following annotations were used:

For VMs:

* `EditableField`
- `EditableHostedEngineField`
- `EditableOnVmStatusField`

For VM Templates:

- `EditableField`
- `EditableOnTemplate`

For Hosts:

- `EditableField`
- `EditableOnVdsStatus`

This lead to fields with an overabundance of individual annotations. For example, take the `memSizeMb` field in the `VmBase` class:

```
@CopyOnNewVersion
@EditableOnVmStatusField(isHotsetAllowed = true)
@EditableOnTemplate
@EditableHostedEngineField
private int memSizeMb;
```

Logically, each of the Editable* annotations are communicating the same information: the circumstances under which a given field is editable. However, `EditableOnVmStatusField` and `EditableOnHostedEngineField` indicate conditions under which a VM entity can be edited, whereas `EditableOnTemplate` indicates the entity type for which the field is editable (`VmTemplate`). It is easy to see how this can be a bit confusing for someone reading through this code, especially if they are unfamiliar with it.

## The Solution

In the first step of the refactor, new annotation names were created that indicate the entity type for which the annotated field is editable:

* `EditableVmField`
* `EditableVdsField`
* `EditableVmTemplateField`

In the second step, each of the conditions described by the old annotation names were turned into fields in the applicable annotation. For example, the `EditableVmField` annotation was given three fields: `onHostedEngine`, `hotsetAllowed`, and `onStatuses`.

The third and final step was to address the way entity statuses were handled, as the previous implementation was problematic. `EditableOnVmStatus` and `EditableOnVdsStatus` both required each status for which a field is editable to be listed in its `onStatus` field. Initially, this makes sense, but consider a field that is editable under any status. The obvious long list of statuses aside, this approach requires that the status list for such a field be updated any time a new status is added to the entity. If the individual adding the status isn't aware of this requirement, a silent regression would be introduced.

In addition to this potentially serious problem, the implementation of each annotation provided a default list of statuses to be used if no status list was provided in the annotation declaration. In order to be aware of the existence of these default lists, an individual would have to either be familiar with the implementation code or have been informed by a third party.

In the consolidated version, if no explicit list is provided in the `onStatuses` field of the `EditableVmField` and `EditableVdsField` annotations, it is assumed that the field is editable under all statuses. However, if a list is provided within the annotation declaration, the field will be considered editable only if it is in a status provided in that list. This implementation is clearer, as the `onStatuses` field will only be used if the statuses list is being restricted, and the restricted list will be displayed alongside the field to which it applies. It also avoids the entity status update problem.

## The End State

If we employ the new annotations using our previous `memSizeMb` example, we get the following:

```
@CopyOnNewVersion
@EditableVmField(
        onHostedEngine = true,
        hotsetAllowed = true,
        onStatuses = { VMStatus.Down })
@EditableVmTemplateField
private int memSizeMb;
```

While the line count increased, the conceptual weight of the code has been reduced. The entities for which this field is editable are obvious, and the conditions under which the field is editable for a VM entity are immediately clear.

**Note**: The line count has only increased due to the styling convention being employed. The same code could be written as:

```
@CopyOnNewVersion
@EditableVmField(onHostedEngine = true, hotsetAllowed = true, onStatuses = { VMStatus.Down })
@EditableVmTemplateField
private int memSizeMb;
```

Overall, we feel that this change will provide a cleaner way of representing this information for both the readers and writers of this code.
