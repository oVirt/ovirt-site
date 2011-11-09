---
title: Quota
category: sla
authors: doron, gchaplik, jumper45, lpeer, mlipchuk, ovedo, sandrobonazzola
wiki_category: SLA
wiki_title: Features/Quota
wiki_revision_count: 32
wiki_last_updated: 2015-05-10
---

# Quota

### Summary

The Quota feature enables limiting user resource usage.

### Owner

*   Name: [ Maor Lipchuk](User:mlipchuk)
*   Email: <mlipchuk@redhat.com>

### Current status

*   <http://www.ovirt.org/wiki/Features/DetailedQuota>
*   Last updated date: Wed Nov 9 2011

### Detailed Description

Today, oVirt doesn't have a mechanism for limiting user resource usage. Such a mechanism is important, especially in multi-tenant environments. Thus, the Quota feature will add a mechanism to manage and monitor the resource usage in such environments. This mechanism should provide the administrator a management configuration page, to set rules for each aspect, crucial enough, to be management consumable.

### Benefit to oVirt

The Quota feature enables limiting resources, which is highly relevant in multi-tenant environments (such as public and private cloud providers). This can help oVirt get better exposure in such environments.

### Dependencies / Related Features

Quota is relevant in every feature that either explicitly or implicitly manage resources in the oVirt engine.

Affected oVirt projects:

*   API
*   CLI
*   Engine-core
*   Webadmin
*   User Portal

Quota has to be taken in consideration, for every new feature that will involve consumption of resources managed by it.

### Documentation / External references

### Comments and Discussion

*   See <Talk:Features/Quota>
