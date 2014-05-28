---
title: Configure libvirt testing matrix
authors: moolit
wiki_title: Configure libvirt testing matrix
wiki_revision_count: 11
wiki_last_updated: 2014-05-29
---

# Configure libvirt testing matrix

|                             | fedora20                                                                                                      | el6.4                                                             |
|-----------------------------|---------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| Build source on machine     | v (testMirroring, testMirroringWithDistraction and testReplacePrio are failing, but they also fail on master) | v (testGetBondingOptions is failing, but it also fails on master) |
| rpm installation on machine | row 2, cell 2                                                                                                 | row 2, cell 3                                                     |
