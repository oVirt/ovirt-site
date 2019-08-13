---
title: faqemu
authors: danken, dyasny
---

# faqemu

Enables the Fake QEMU support, used mainly for testing - to run vdsm on virtual machines that do not have VT/AMD-V extensions.

This requires a setting in /etc/vdsm/vdsm.conf

      fake_kvm_support = True

ovirt-host-deploy should be told not to overwrite this setting. See [ovirt-host-deploy README](http://gerrit.ovirt.org/gitweb?p=ovirt-host-deploy.git;a=blob;f=README;hb=HEAD#l52) on how to do that.

No requirement for a custom property

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-faqemu-4.10.0-0.442.git6822c4b.el6.noarch.rpm>
