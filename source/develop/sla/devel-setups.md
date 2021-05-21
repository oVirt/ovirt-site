---
title: devel-setups
category: sla
authors:
  - doron
  - lvroyce
---

# devel-setups

## **Development setup**

This page holds relevant information for MoM and other SLA-related packages

**OS**

*   Fedora
    -   Version 17

**Needed RPMs**

*   **MoM**
    -   version:mom-0.2.1-6.fc17
    -   URL:
    -   <git:git://gerrit.ovirt.org/mom>

        After checkout mom code:
        1.run following cmd to install mom:
          cd mom
          python setup.py install
        2.restart vdsm, vdsm will run mom as a thread

*   **vdsm**
    -   version:vdsm-4.10.0
    -   URL:
    -   git <git://gerrit.ovirt.org/vdsm.git>

<!-- -->

*   **libvirt**
    -   version:libvirt-0.10.1
    -   URL:<http://libvirt.org/sources/>

Note: libvirt-0.10.1 can't be installed by yum, you should download the rpm from URL and install it.

*   -   <git:git://libvirt.org/libvirt.git>

