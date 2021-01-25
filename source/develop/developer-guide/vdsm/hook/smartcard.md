---
title: smartcard
authors: dyasny
---

# smartcard

The smartcard hook adds smartcard support for spice enabled VMs. This hook enables the host/VM-side of smartcard implementation in the SPICE service, but the SPICE client should also enable the smartcard support (see `remote-viewer --help-all` for details)

syntax:

      smartcard: smartcard=true

libvirt xml:

```xml
<smartcard mode='passthrough' type='spicevmc'/>
```

