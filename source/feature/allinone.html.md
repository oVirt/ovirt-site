---
title: AllInOne
category: feature
authors: acathrow, alourie, dneary, jbrooks, netbulae, oschreib, sandrobonazzola
wiki_category: Feature|All In One
wiki_title: Feature/AllInOne
wiki_revision_count: 25
wiki_last_updated: 2015-01-16
---

# All in one

This feature is provided as a separate rpm binary which adds a plugin to the setup sequence.

"All in One" means configuring VDSM on the same host where oVirt-engine is installed, so that VMs can be hosted on the same machine.

### Installation Flow

*   Install ovirt-engine-setup-plugin-allinone rpm.
*   Start regular engine-setup procedure.
*   When asked "Configure VDSM on this host?", answer yes.
*   Provide answers to the presented questions.
*   After all answers are provided, the setup will install oVirt-engine and configure VDSM, including local host.
