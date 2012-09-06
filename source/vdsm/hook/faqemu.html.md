---
title: faqemu
authors: danken, dyasny
wiki_title: VDSM-Hooks/faqemu
wiki_revision_count: 3
wiki_last_updated: 2014-06-17
---

# faqemu

Enables the Fake QEMU support, used mainly for testing - to run vdsm on virtual machines that do not have VT/AMD-V extensions.

This requires a setting in /etc/vdsm/vdsm.conf

      fake_kvm_support = True

No requirement for a custom property
