---
title: Overriding system ifcfg settings in oVirt
author: mmirecki
date: 2016-05-25 14:21:00 UTC
tags: community, howto, blog, hooks
comments: true
published: true
---

oVirt is using a bridge based setup to configure networks on the managed hosts. The setup process is done by generating and maintaining network interface configuration files (ifcfg file), which define the network devices used by oVirt.
Should any changes be done to these files by an outside party, oVirt will try to restore them to the desired state, to keep the network configuration intact.
There are however situations in which the user want to intentionally introduce permanent changes into some of these files, and prohibit oVirt from overwritting them. In order to do so, VDSM hook script can be used.

Lets look at an example, where the user want to add the following entries to the 'ens11' network interface:
    USERCTL=yes
    ETHTOOL_OPTS="autoneg on speed 1000 duplex full"

A VDSM hook invoked before ifcfg file modification can be used to accomplish this.
The hook script should be placed inside the "/usr/libexec/vdsm/hooks/before_ifcfg_write/" directory on the VDSM host. VDSM must have execute permissions for this script. VDSM will check this directory every time ifcfg configuration is changed, and executes each script it finds in this directory. 
The script will receive a json dictionary as input. The dictionary contains two elements:
- ifcfg_file - full path of the ifcfg file to be written
- config - the contents of the ifcfg file to be written 

For example:
    {
        "config": "DEVICE=ens13\nHWADDR=52:54:00:d1:3d:c8\nBRIDGE=z\nONBOOT=yes\nMTU=1500\nNM_CONTROLLED=no\nIPV6INIT=no\n", 
        "ifcfg_file": "/etc/sysconfig/network-scripts/ifcfg-ens7"
    }

Modified ifcfg file contents (under the "config" entry) can be returned,and will be used by VDSM as the new ifcfg file content. If nothing is returned, VDSM will use the unmodified content.

A sample hook script will look as follows:

    #!/usr/bin/python
    
    import os
    import datetime
    import sys
    import json
    import hooking
    
    hook_data = hooking.read_json()
    
    ifcfg_file = hook_data['ifcfg_file']
    config_data = hook_data['config']
    # adding to ens11 ifcfg file: USERCTL=yes and ETHTOOL_OPTS="autoneg on speed 1000 duplex full"
    if 'ens11' in ifcfg_file:
        config_data += "USERCTL=yes\nETHTOOL_OPTS=\"autoneg on speed 1000 duplex full\"\n"
        hook_data['config'] = config_data
        hooking.write_json(hook_data)
    exit(0)

Following is a description of the hook script.

Reading in the data from the json file:
  
    hook_data = hooking.read_json()

Getting the value of the new ifcfg file content:
  
    config_data = hook_data['config']

Getting the name of the ifcfg file which will be modified:
  
    ifcfg_file = hook_data['ifcfg_file']

Modify the content of the ifcfg file:
  
    config_data += "USERCTL=yes\nETHTOOL_OPTS=\"autoneg on speed 1000 duplex full\"\n"
    hook_data['config'] = config_data

Write the content of the ifcfg file:
    hooking.write_json(hook_data)