---
title: Normalizing scheduling policy weights
category: feature
authors: msivak
---

## Normalizing scheduling policy weights

### Summary

The currently used weight policy units do not use any common result value range. Each unit reports numbers as needed and this causes issues with user configured preferences (policy unit multiplier), because for example memory (very high numbers) always wins over CPU (0-100).


### Owner

*   Name: [Martin Sivák](User:msivak)
*   Email: <msivak@redhat.com>

### Detailed Description

#### Comparing the current CPU and memory weight units

I selected the CPU vs. memory balancing to demonstrate the issue and the possible fix.

The CPU load policy unit is currently not effective as the weight values used are too low (0-100) and the memory policy unit almost always overrules the CPU (2**31 - max scheduling memory in MB). The factor value the user can assign to the policy units is confusing for this reason, because 2x memory weight has a huge impact, but 1000x CPU weight is still not enough to overrule memory.

#### Weight normalization algorithms

As you see in the CPU and memory example we have to either normalize the weights reported by all policy units (either manually in the code or automatically) or use some different reduction step.

I was reading a bit and the three basic normalization options we can use are:

- Using percentage of hardcoded maximum values for each policy unit
- Using percentage of the maximum reported value (during the scheduling attempt) of a policy unit
- Using rank (sorting reported weights and awarding points according to the position; my example calculation computes rank as number of hosts that are better than the ranked one)

All three options have advantages and disadvantages. Hardcoded maximum is obviously a problem for future memory size values, dynamic maximum depends on which hosts make it into the weighting step and rank does not do a good job when there are huge gaps in weight values.

Personally I am in favour of testing rank though as it is future proof and the factor multiplier has predictable results (and we already have the code too).

#### Algorithm results comparison

This is a simple case where all three algorithms report the same result. That won’t always be so.

* CPU, factor 10 (hardcoded maximum 100%)
* Memory, factor 1 (hardcoded maximum 4096 MB)


| Host / Metric | CPU load | Occupied memory | Normalized (lower is better) | Normalized dynamic (lower is better) | Ranked (lower is better) |
| ------------- | -------- | --------------- | ---------------------------- | ------------------------------------ | ------------------------ |
| Host A | 90 | 1024 MB | 10 * 90 + 25 = 925 | 10 * 100 + 25 = 1025 | 10 * 2 + 0 = 20 |
| Host B | 50 | 2048 MB | 10 * 50 + 50 = 550 | 10 * 55 + 50 = 600 | 10 * 1 + 1 = 11 |
| Host C | 10 | 4096 MB | 10 * 10 + 100 = 200 | 10 * 11 + 100 = 210 | 10 * 0 + 2 = 2 |


### Benefit to oVirt

The multiplier factor in the Scheduling policy edit dialog will become predictable. This will also allow the user to fine tune his preferences (for example: CPU vs. memory vs. weak affinity rules).

### Implementation details

#### Scheduling process changes

The existing policy units won't be affected. The normalization process will be done by adding an extra step to the current Filter / Weight sequence. It will become Filter / Weight / Select.

#### User Experience

No changes to the UI or REST will be necessary, this change will be totally transparent.

#### Installation/Upgrade

Users using the weight multipliers might need to update them to reasonable values.

### Dependencies / Related Features

This normalization is needed as a ground work for all weak affinity features, including host affinity and Rack based balancing.

### Documentation / External references

- [Bug: Soft negative affinity](https://bugzilla.redhat.com/show_bug.cgi?id=1207255)
- [Bug: Normalize policy unit weights](https://bugzilla.redhat.com/show_bug.cgi?id=1306263)

### Testing

Basic sanity checks for scheduling VMs are needed. The internal weighting rules were never really exposed so a slight change in behaviour might not be even noticed.

The selection step result is visible in the DEBUG log (logger name: org.ovirt.engine.core.bll.scheduling.policyunits.RankSelectorPolicyUnit) in a CSV table form. Each row represents one weight unit and columns representing hosts have two walues: rank (higher is better), raw weight returned by policy unit.

```
2016-12-01 18:03:18,299+01 DEBUG [org.ovirt.engine.core.bll.scheduling.policyunits.RankSelectorPolicyUnit] (org.ovirt.thread.pool-6-thread-49) [ceadae95-bc68-4ae7-ac85-55b610194981] Ranking selector:
*;factor;4adcef93-a088-437e-ac0d-479046deae71;;5bec53b1-548a-4f3a-beee-ee55c9180b34;;71d65d53-bd3d-4028-b5f8-ec4f4f276394;
98e92667-6161-41fb-b3fa-34f820ccbc4b;1;2;1;2;1;2;1
84e6ddee-ab0d-42dd-82f0-c297779db567;1;2;1;2;1;2;1
7db4ab05-81ab-42e8-868a-aee2df483edb;1;2;4;0;5;2;4
7f262d70-6cac-11e3-981f-0800200c9a66;1;2;0;2;0;2;0
591cdb81-ba67-45b4-9642-e28f61a97d57;1;2;10000;2;10000;2;10000
4134247a-9c58-4b9a-8593-530bb9e37c59;1;2;1;2;1;0;47
```

Testing with many different VMs might reveal interesting situations though.

### Contingency Plan

The feature is ready and only needs to be enabled.

### Release Notes

      == Scheduling multipliers changed ==
      The impact of scheduling multipliers was changed as the underlying weight values were normalized. Please check that the values you use represent the real relative value of importance instead of empirical number that you used to get the desired behaviour in the past.

### Comments and Discussion

Please use the devel@ovirt.org mailinglist for discussing this feature.

