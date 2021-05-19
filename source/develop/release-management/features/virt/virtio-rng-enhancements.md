---
title: Virtio RNG Enhancements
authors: jniederm
---

# Virtio RNG Enhancements

## Owner

*   Name: Jakub Niedermertl (jniederm)
*   Email: <jniederm@redhat.com>

## `urandom` replaces `random`

### Summary
`/dev/urandom` random number generator (RNG) source replace `/dev/random` for VMs with effective compatibility 
version >= 4.1. `urandom` presents a non-blocking ("unlimited") rng source as opposed to `random`.

[Related bug](https://bugzilla.redhat.com/show_bug.cgi?id=1374227).

### Engine
Each time VM effective compatibility level is changed (by change of cluster compatibility level or VM custom 
compatibility level) source of rng generator device is checked and updated if necessary.

### Non-cluster Entities
For non-cluster-aware entities (Blank template and instance types) `urandom` and `random` rng sources are united to one
rng source labeled "urandom or random" in UI and `urandom` in REST api. Such rng source will be differentiated to either
`urandom` or `random` (depending of effective compatibility level) when Blank template or instance type will be applied
to a new VM.

### Compatibility
Host machines require libvirt version >= [1.3.4][1]. (i.e. RHEL/CentOS >= 7.3) to support `urandom` rng source.

## `urandom` or `random` rng enable by default

### Summary

* All clusters in engine v4.1 requires that their hosts provide `/dev/urandom` or `/dev/random` rng device for cluster
compatibility level 4.1+ or 4.0- respectively.
* Blank template and predefined instance types now contains "urandom or random" based rng device. Thus new VMs based
on these entities will contain such rng device.

[Related bug](https://bugzilla.redhat.com/show_bug.cgi?id=1337101).

### REST Api
List of rng sources that cluster requires for all its hosts is available in `cluster/required_rng_sources`. Source
`urandom` or `random` is always present and can't be removed.

```xml
GET ovirt-engine/api/clusters/{clusterId}

<cluster>
    ...
    <required_rng_sources>
        <required_rng_source>urandom</required_rng_source>
    </required_rng_sources>
</cluster>

```

[1]: https://bugzilla.redhat.com/show_bug.cgi?id=1074464
