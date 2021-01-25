---
title: Custom Fencing
authors: emesika
---

# Custom Fencing

Here are detailed instructions how to add a custom agent:

## Pre oVirt 3.5 releases

a) Add your new agent to VdsFenceType option_value in vdc_options table for the relevant cluster version
b) Add agent options mappings to VdsFenceOptionMapping option_value in vdc_options table for the relevant cluster version
c) If the agent maps actually to another agent , add that to FenceAgentMapping option_value in vdc_options
 Example :

        Adding zzz agent support for version 3.3 that maps internally to ipmi and have just port setting (from: port, slot, secure) that maps to the fencing script ipport
        a) VdsFenceType for 3.3 becomes "apc,apc_snmp,bladecenter,cisco_ucs,drac5,eps,ilo,ilo2,ilo3,ilo4,ipmilan,rsa,rsb,wti,zzz"
         b) VdsFenceOptionMapping for 3.3 becomes "apc:secure=secure,port=ipport,slot=port;apc_snmp:port=port;bladecenter:secure=secure,port=ipport,slot=port;cisco_ucs:secure=ssl,slot=port; drac5:secure=secure,slot=port;eps:slot=port;ilo:secure=ssl,port=ipport;ipmilan:;ilo2:secure=ssl,port=ipport;ilo3:;ilo4:;rsa:secure=secure,port=ipport;rsb:;wti:secure=secure,port=ipport,slot=port;zzz:port=ipport"
         c) FenceAgentMapping becomes "ilo2=ilo,ilo3=ipmilan,ilo4=ipmilan,zzz=ipmilan"

NOTES

1) Please backup your database
2) You should restart the engine for this to take place
3) Custom definitions will be overridden in your next upgrade , for the long run please fill RFE so it will be part of the supported agents

## oVirt 3.5

In oVirt 3.5 we had added custom fence configuration keys :

      CustomFenceAgentMapping - Maps a fencing agent to other agent implicitly. 
         Format : ((\\w)+[=](\\w)+[,]{0,1})+. 
         Example: agent1=agent2,agent3=agent4
      CustomFenceAgentDefaultParams - Default parameters per agent. 
         Format ([\\w]+([=][\\w]+){0,1}[,]{0,1})+. 
         Example: agent1=key1=val1,flag;key2=val2
      CustomVdsFenceOptionMapping - secure/port/slot mapping support per agent. 
         Format ([\\w]+[:]([\\w]*[=][\\w]*[,]{0,1}[;]{0,1}){0,3}[;]{0,1})+. 
         Example: agent1:secure=secure;agent2:port=ipport,slot=slot
      CustomVdsFenceType - Fence agents types. 
         Format ((\\w)+[,]{0,1})+. 
         Example: agent1,agent2
      CustomFencePowerWaitParam - Maps a fencing agent to the param for delay on/off actions. 
         Format : ((\\w)+[=](\\w)+[,]{0,1})+. 
         Example: agent1=power_wait,agent2=delay

Those keys are accessible from the engine-config util

Example 1 : Adding zzz agent support for version 3.5 that maps internally to ipmi and have just port setting (from: port, slot, secure) that maps to the fencing script ipport

        engine-config -s CustomVdsFenceType="zzz"
        engine-config -s CustomFenceAgentMapping="zzz=ipmilan"
        engine-config -s CustomVdsFenceOptionMapping="zzz:port=ipport"
        engine-config -s CustomFencePowerWaitParam="zzz=power_wait"

Example 2: Adding a new custom fencing device 'yyy' that have just port setting (from: port, slot, secure) that maps to the fencing script ipport First you have to insure that you have a script named fence_yyy in /usr/sbin directory of all servers that might be selected as proxy host for fencing operations

        engine-config -s CustomVdsFenceType="yyy"
        engine-config -s CustomVdsFenceOptionMapping="yyy:port=ipport"
        engine-config -s CustomFencePowerWaitParam="yyy=power_wait"

Example 3: Adding support for Intel Modular agent

       engine-config -s CustomVdsFenceType="intelmodular"
       engine-config -s CustomFencePowerWaitParam="intelmodular=power_wait"
       engine-config -s CustomVdsFenceOptionMapping="intelmodular:port=port"

NOTE : if you have a power management card that needs no other parameters to be set, you still have to set it mapping as empty example

       engine-config -s CustomVdsFenceOptionMapping="zzz:"

In this case those changes remains valid after oVirt upgrades as well, so please use that method from oVirt 3.5 and on.
