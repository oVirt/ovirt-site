---
title: smartcard
authors: dyasny
---

# smartcard

The smartcard hook adds smartcard support for spice enabled VMs. This hook enables the host/VM-side of smartcard implementation in the SPICE service, but the SPICE client should also enable the smartcard support (see `remote-viewer --help-all` for details)

syntax:

      smartcard: smartcard=true

libvirt xml:

<smartcard mode='passthrough' type='spicevmc'/>

Download link: <http://ovirt.org/releases/nightly/rpm/EL/6/hooks/vdsm-hook-smartcard-4.10.0-0.442.git6822c4b.el6.noarch.rpm>
