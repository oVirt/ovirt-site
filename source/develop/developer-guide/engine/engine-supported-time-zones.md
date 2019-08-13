---
title: Engine supported Time Zones
authors: mbetak
---

# Engine supported Time Zones

Due to the fact the supported timezone list needs to be shared between the engine frontend, backend and also the engine-config tool the list of supported time zones is concentrated in

<http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=backend/manager/modules/common/src/main/java/org/ovirt/engine/core/common/TimeZoneType.java>

There are two basic sets of timezone keys:

*   Windows - time zones specifically supported in [Windows](http://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx) e.g. 'GMT Standard Time' or 'Israel Standard Time'
*   General - time zones used for non-Windows OS types. Keys follow the standard [tz format](http://en.wikipedia.org/wiki/Tz_database) e.g. 'Etc/GMT' or 'Asia/Jerusalem'

Note that one must differentiate between timezone **Key** and **Display value**. Time zone key is the string used when configuring DefaultWindowsTimeZone or DefaultGeneralTimeZone using the engine-config tool. Display value on the other hand is displayed in webadmin UI and multiple timezone keys may correspond to the same display value.

All (currently supported) mappings or time zone keys to display value can be found in the [TimeZoneType.java](http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=backend/manager/modules/common/src/main/java/org/ovirt/engine/core/common/TimeZoneType.java) file. Due to occasional changes in the TZ data this may get out of date so when in doubt, please reference the current master version of the file.
