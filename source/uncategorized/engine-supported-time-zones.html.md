---
title: Engine supported Time Zones
authors: mbetak
wiki_title: Engine supported Time Zones
wiki_revision_count: 2
wiki_last_updated: 2014-03-26
---

# Engine supported Time Zones

Due to the fact the supported timezone list needs to be shared between the engine frontend, backend and also the engine-config tool the list of supported time zones is concentrated in

<http://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=backend/manager/modules/common/src/main/java/org/ovirt/engine/core/common/TimeZoneType.java>

There are two basic sets of timezone keys:

*   Windows - time zones specifically supported in [Windows](http://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx) e.g. 'GMT Standard Time' or 'Israel Standard Time'
*   General - time zones used for non-Windows OS types. Keys follow the standard [tz format](http://en.wikipedia.org/wiki/Tz_database) e.g. 'Etc/GMT' or 'Asia/Jerusalem'
