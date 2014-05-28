---
title: Configure libvirt testing matrix
authors: moolit
wiki_title: Configure libvirt testing matrix
wiki_revision_count: 11
wiki_last_updated: 2014-05-29
wiki_warnings: references
---

# Configure libvirt testing matrix

|                                        | fedora20                                                                      | el6.4                                                           |
|----------------------------------------|-------------------------------------------------------------------------------|-----------------------------------------------------------------|
| Build source on machine                | v                                                                             
                                          (testMirroring, testMirroringWithDistraction and testReplacePrio are failing,  
                                           but they also fail on master in addition there are pep8 violation [1]         
                                           also found on master (probably due to pep8 version version))                  | v                                                               
                                                                                                                          (testGetBondingOptions is failing, but it also fails on master)  |
| rpm installation on machine            | v                                                                             | v                                                               |
| attempt to run vdsm after installation | v                                                                             | x                                                               |

<references/>

[1] ./lib/yajsonrpc/betterAsyncore.py:257:55: E225 missing whitespace around operator
./tests/utilsTests.py:534:24: W602 deprecated form of raising exception
./vdsm_hooks/fileinject/before_vm_start.py:96:80: E501 line too long (89 characters)
