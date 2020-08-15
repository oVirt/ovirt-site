---
title: New policy language for MOM
category: feature
authors: akrejcir
feature_name: New policy language for MOM
feature_modules: mom
feature_status: design
---

# New policy language for MOM
Currently, [MOM](/develop/sla/host-mom-policy.html)
policies are written in a lisp-like scripting language
that can be confusing to use.
We want to change the model and the language,
to make it easy for users to write their own policies.

## Owner
* Owner: Andrej Krejcir
* Email: akrejcir@redhat.com

## Declarative policy representation
The rule representation uses YAML format.
The main idea can be explained on a simple example:

```yaml
scope: VM

conditions:
  io_or_net_overutilized:
    any:
      - io.read_bytes_per_s  > policy.io_threshold
      - io.write_bytes_per_s > policy.io_threshold
      - net.throughput > policy.net_threshold

rules:
    cpu_limit:
        output: cpu.max_load
        min: 10
        target: 0
        function:
            name: linear
            change: 1
            time: 1 sec

        when: io_or_net_overutilized

    cpu_release:
        output: cpu.max_load
        max: 100
        function:
            name: exponential
            factor: 2
            time: 30 sec

        when: not io_or_net_overutilized
```

The first line sets the scope of the rules in the file:

```yaml
scope: VM
```

Scope can be:

- `Host` - Rules modify global properties of a host (like KSM). They are executed once per rule evaluation cycle.
- `VM` - Rules modify properties of VMs. They are executed for all VMs every rule evaluation cycle.

Next is optional definitions of `conditions`.
They are for convenience, so the same expression is not repeated in multiple rules.

```yaml
conditions:
  io_or_net_overutilized:
    any:
      - io.read_bytes_per_s  > policy.io_threshold
      - io.write_bytes_per_s > policy.io_threshold
      - net.throughput > policy.net_threshold
```

The condition `io_or_net_overutilized` is defined as the logical `or` of three conditions.
The objects `io`, `net` and `policy` are VM property objects and
contain the properties the rules have access to.
Other property objects can be `cpu`, `memory` or anything else.

The next section defines rules.

```yaml
rules:
    cpu_limit:
        output: cpu.max_load
        min: 10
        target: 0
        function:
            name: linear
            change: 1
            time: 1 sec

        when: io_or_net_overutilized
```

This rule is triggered when the condition `io_or_net_overutilized` is satisfied.
The property `cpu.max_load` of the VM is linearly decreased by 1 percent per second.
Until the minimum value `10` is reached.

Meaning of the rule attributes:

- `output` - The property that is modified by the rule.
- `min` - The minimum allowed value of the output property. It can be any expression, not only a constant.
- `target` - The ideal value we are trying to reach (can be any expression).
- `function` - Defines how the `output` is changed in response to computed target.
    - `name` - Name of the function
    - `change`, `time` - Parameters of the function (described below).
- `when` - Condition, that has to be satisfied. It can be any boolean expression and use the predefined conditions.

The second rule is:

```yaml
cpu_release:
    output: cpu.max_load
    max: 100
    target: 100
    function:
        name: exponential
        factor: 2
        time: 30 sec

    when: not io_or_net_overutilized
```

It is triggered when `io_or_net_overutilized` is not satisfied.
The maximum CPU load of the VM is exponentially increasing.
It doubles every 30 seconds, until the maximum 100 is reached.

## Details of the representation

### Functions

At least three function types are available in the rules:
- `constant` - The output is immediately set to the `target`. This function has no parameters and it is the default used, when no `function` attribute is present in the rule.

- `linear` - The output is changed linearly by a given `change` over a period of `time`. Parameters:
  - `change` - The absolute change
  - `time` - The interval

- `exponential` - The output is changed exponentially by `factor` over a period of `time`. Parameters:
  - `factor` - How big is the relative change
  - `time` - The interval

### Vars block

The block contains values used in the rules. An example from the KSM rule:

```yaml
vars:
    ksm_pages_boost: 300
    ksm_pages_decay: -50
    ksm_npages_min: 64
    ksm_npages_max: 1250
    ksm_sleep_ms_baseline: 10
    ksm_free_percent: 0.20
```

An example from the ballooning rule:

```yaml
vars:
    host_free_percent: host.mem_free_avg / host.mem_available
    vm_used_mem: memory.balloon_cur - memory.unused
```

### Minimum needed change and maximum allowed change

In some cases it may not be practical to modify a value if the change would be too small.
The output will be modified once enough time has passed and the change is big enough.

- `min_absolute_change` - Will not modify the output if the absolute change is smaller.
- `min_relative_change` - Will not modify the output if the relative change is smaller.

```yaml
rules:
  balloon_shrink:
    output: memory.balloon
    min: policy.balloon_min
    min_relative_change: min_balloon_change

    target: 0

    function:
      type: exponential
      factor: 0.5
      time: 1 min

    when: shrink_balloon
```

Maximum change can be limited to a specified amount over a period of time.
- `max_absolute_change` - Limits the absolute change.
- `max_relative_change` - Limits the relative change.

```yaml
rules:
  balloon_grow:
    output: memory.balloon
    target: policy.balloon_max
    max: policy.balloon_ma
    max_absolute_change:
      value: 100
      time: 1 sec

    function:
      name: exponential
      factor: 2
      time: 1 min

    when: not shrink_balloon
```

Combining change limits with `constant` function has the same effect as
using `linear` or `exponential` function.

### Rule influence

When multiple rules modify the same `output`, the final value is a linear combination of their outputs.
Weight of each rule is set by the `influence` parameter that can be any expression:

```yaml
rules:
    cpu_rule_1:
        output: cpu.max_load
        target: 100
        influence: 2 # <-------------

        function:
            name: linear
            change: 1
            time: 1 sec


    cpu_rule_2:
        output: cpu.max_load
        target: 0
        influence: 1 # <-------------

        function:
            name: linear
            change: 1
            time: 1 sec
```

### Attribute with a list of values

Some attributes of the rule can take a list of values:

```yaml
# Logical AND
all:
    - condition1
    - condition2

# Logical OR
any:
    - condition1
    - condition2

# Similar
when_any: ...
when_all: ...

# This is the minimum allowed output,
# so the maximum of value1, value2 is used as minimum
min:
    - value1
    - value2

# Minimum of the 2 values is used as maximum allowed output
max:
    - value1
    - value2
```

## Behavior implementation

The general behavior can be expressed in pseudocode:

```python
if rule.when:
  # sets the limits
  target = min(max(rule.target, rule.min), rule.max)

  # time between rule executions
  elapsed_time = ...

  # limits the slope and approach speed
  immediate_target = function(output, target, elapsed_time, ...)

  # changes the output
  delta = immediate_target - output
  if (abs(delta) > minimum_absolute_change and
      abs(delta) > min_relative_change * output):

    abs_max = rule.max_absolute_change * elapsed_time
    delta = min(delta, abs_max)
    delta = max(delta, -abs_max)

    rel_max = output * rule.max_relative_change^elapsed_time
    delta = min(delta, rel_max)
    delta = max(delta, -rel_max)

    output += delta
```
