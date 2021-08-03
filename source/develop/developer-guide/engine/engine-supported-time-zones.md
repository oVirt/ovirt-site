---
title: Engine supported Time Zones
authors:
- mbetak
- sabusale
---

# Engine supported Time Zones

Engine default time-zones can be found in `<ENGINE_DEPLOYMENT>/etc/ovirt-engine/timezones/00-defaults.properties`

####Timezones file format:

key must be valid General timezone from tz database, value must be a valid Windows timezone
*   General - time zones used for non-Windows OS types, that follows the standard [tz format](http://en.wikipedia.org/wiki/Tz_database) e.g. 'Etc/GMT' or 'Asia/Jerusalem'

*   Windows - time zones specifically supported in [Windows](http://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx) e.g. 'GMT Standard Time' or 'Israel Standard Time'


for example, see [here](https://github.com/oVirt/ovirt-engine/blob/ovirt-engine-4.4.8.4/packaging/conf/timezones-defaults.properties#L12)


## Extending the time zone list:
ovirt users can extend the default time zone list and add their own timezones

In order to do that:
- add new file in `<ENGINE_DEPLOYMENT>/etc/ovirt-engine/timezones`, for example: `10-timezones.properties`
- add your own time zone with correct format (as described above)
- restart the engine

After following this steps new time zone should appear on the engine and can be used