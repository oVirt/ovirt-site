---
title: Porting oVirt
category: developer
authors: alonbl, dneary, zhshzhou
wiki_category: Developer
wiki_title: Porting oVirt
wiki_revision_count: 9
wiki_last_updated: 2013-07-24
---

# Porting oVirt

Because oVirt integrates closely with both the Hypervisor and guest operating systems running on the Hypervisor, there is some porting and integration work required to enable oVirt Engine to manage nodes running on operating systems other than Fedora, CentOS and Red Hat Enterprise Linux. The main work involved is related to porting and integrating [VDSM](VDSM) and its dependencies to the new distribution, and ensuring that the [Guest Agent](Guest Agent) integrates correctly on guests.

<Category:Developer>
