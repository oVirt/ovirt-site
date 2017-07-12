---
title: Configure libvirt testing matrix
authors: moolit
---

# Configure libvirt testing matrix

Results compared against same machine with master vdsm on it: (except for remove-config which does not exist on master.)

|                                                                           | fedora20                                                                      | el6.4                                                           |
|---------------------------------------------------------------------------|-------------------------------------------------------------------------------|-----------------------------------------------------------------|
| Build source on machine                                                   | v                                                                             
                                                                             (testMirroring, testMirroringWithDistraction and testReplacePrio are failing,  
                                                                              but they also fail on master in addition there are pep8 violation             
                                                                             also found on master (probably due to pep8 version version))                   | v                                                               
                                                                                                                                                             (testGetBondingOptions is failing, but it also fails on master)  |
| rpm installation on machine                                               | v                                                                             | v                                                               |
| attempt to run vdsm after installation                                    | v[1]                                                                          | v[2]                                                            |
| vdsm-tool is-configured                                                   
 False expected                                                             | v                                                                             | v                                                               |
| vdsm-tool configure --force                                               
  **compare configuration files with master configured files.**             | v (order changes)                                                             | v (order changes)                                               |
| vdsm-tool is-configured                                                   
 True expected                                                              | v                                                                             | v                                                               |
| upgrade from master vdsm                                                  
 test is-configured, validate-config                                        
  remove-config, configure --force and run vdsm                             |                                                                               | v                                                               |
| change vdsm.conf ssl = false                                              
 validate-config should fail                                                
  configure --force and run vdsm should run ok                              |                                                                               | v                                                               |
| getVdsCaps should work well with/without ssl using -s or not in vdsClient |                                                                               | v                                                               |
| remove vdsm rpm and check configuration files                             
  vdsm sections should be removed                                           |                                                                               | v                                                               |
| connect to engine & run cross migration to/from patch configured hosts    | v - migration completes successfully                                          | cannot currently connect el6.4 due to an upstream bug           |

| connect to engine & create snapshots                                      | v-snapshots created successfully                                              | cannot currently connect el6.4 due to an upstream bug           |

Currently there is an upstream bug preventing node installation. I'm am awaiting an ovirt-node 3.4 iso with my patches and will tests on it when it arrives. I do not think it should block the patch since currently installation on master is not working.

|                         | ovirt Node              |
|-------------------------|-------------------------|
| Create iso from source. | v (By Douglas! Thanks!) |
|                         |                         |

<references/>

[1] [root@dhcp-1-228 ~]# systemctl start vdsmd.service
Job for vdsmd.service failed. See 'systemctl status vdsmd.service' and 'journalctl -xn' for details.

[2] [root@reserved-0-250 vdsm]# service vdsmd start
vdsm: Running mkdirs
vdsm: Running configure_coredump
vdsm: Running configure_vdsm_logs
vdsm: Running run_init_hooks
vdsm: Running gencerts
vdsm: Running check_is_configured
libvirt is not configured for vdsm yet
sanlock service is already configured
Modules libvirt are not configured
Error:
One of the modules is not configured to work with VDSM.
To configure the module use the following:
'vdsm-tool configure [module_name]'.
If all modules are not configured try to use:
'vdsm-tool configure --force'
(The force flag will stop the module's service and start it
afterwards automatically to load the new configuration.)
usage:
 /usr/bin/vdsm-tool [options] is-configured [-h|...]
 Determine if module is configured
 Invoke with -h for complete usage.
 vdsm: stopped during execute check_is_configured task (task returned with error code 1).
vdsm start [FAILED]
