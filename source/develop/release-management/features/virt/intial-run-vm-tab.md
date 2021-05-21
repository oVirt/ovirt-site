---
title: Intial Run Vm tab
category: feature
authors:
  - jbiddle
  - roy
---

# Intial Run Vm tab

## Summary

Initial Run is a replacment for sysprep tab. It contains OS independent properties as well as specific one's like the current "Domain" for Windows sysprep tool.

## Owner

*   Name: [Roy Golan](https://github.com/rgolangh) (rgolan)
*   Email: <rgolan@redhat.com>

## Current status

in code review.

## Detailed Description

This feature emereged from the need to set the HW clock for non-windows machine in the first time the VM runs and store it in templates and their instances.
To do so we must use the Timezone offset from GMT in seconds and send it to VDSM:

```xml
<clock offset="variable" adjustment="-3600">
  <timer name="rtc" tickpolicy="catchup">
</clock>
```

## Required Changes

*   Engine - `GetTimezoneQuery`

`GetTimeZoneQuery` was extended with the option to pool general timezone list and not only windows-specific
Simply pass isWindowsOS=false with the params. The default behaviour is set to "true" to return windows values.

```java
      public class TimeZoneQueryParams extends VdcQueryParametersBase {
         private boolean windowsOS = true;
         ...
      }
```

*   UX

1.  Sysprep tab is renamed to Initial Run
2.  tab is always visible
3.  content is splitted into "General" for common properties to all OSs and "Windows" section with windows only properties e.g Domain
4.  on selection of different OS under Genral tab the Timezone list is fetched (cached)
5.  Domain select-box gets disable when the OS is non windows

## Benefit to oVirt

First an admin can set a VM with a desired clock offset, make a template from it and each VM created from that templte will have its clock set already. Second we would be able to use future sysprep for linux.

## Screenshot

![](/images/wiki/Initial-run-tab.png)
