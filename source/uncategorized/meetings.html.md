---
title: Meetings
authors: abaron, bproffitt, danken, dneary, lpeer, mburns, quaid, rbergeron, rmiddle,
  sandrobonazzola, sgordon
wiki_title: Meetings
wiki_revision_count: 141
wiki_last_updated: 2014-11-19
---

# Meetings

This is the page for meeting information.

## oVirt Weekly Sync Meeting

oVirt has a weekly sync meeting on IRC (occasionally phone).

### Agenda

#### Weekly project sync meeting

This is the agenda for the 2012-10-31 meeting:

*   Status of Next Release (Feature Status, F17/F18 support)
*   Sub-project reports (engine, vdsm, node, infra)
*   Workshop Report

### Meeting Time and Place

*   oVirt Weekly Sync
    -   Wednesdays @ 15:00 UTC (may change during DST changes) - always at 7:00am US Pacific, 10:00am US Eastern.
    -   To see in your timezone '''date -d 'WEDNESDAY 1000 EDT' **\1**date -d 'TUESDAY 0900 EDT' **\1**date -d 'TUESDAY 1000 EDT' **\1**date --date='TZ="Asia/Jerusalem" 16:00 next Wed' '''
    -   To see if this is a week with a meeting,

      ` wk=`date --date='TZ="Asia/Jerusalem" 16:30 next Wed' +"%W"`; `
      if [ $(($wk % 2)) == 1 ]; then
        echo "Meeting next Wednesday";
      else
        echo "No meeting next Wednesday";
      fi

*   -   On IRC: #ovirt on irc.oftc.net
    -   Intercall (see [here](intercall) for more info) conference ID: 1814335863
*   VDSM Bi-Weekly Sync
    -   Monday (bi-weekly) @ 14:30 UTC (may change during DST changes) - always at 16:30 Israel.
    -   To see in your timezone '''date --date='TZ="Asia/Jerusalem" 16:30 next Mon' '''
    -   To see if this is a week with a meeting,

      ` wk=`date --date='TZ="Asia/Jerusalem" 16:30 next Mon' +"%W"`; `
      if [ $(($wk % 2)) == 1 ]; then
        echo "Meeting next Monday";
      else
        echo "No meeting next Monday";
      fi

*   -   On IRC: #vdsm on chat.freenode.net
    -   Intercall (see [here](intercall) for more info) conference ID: 842-597-391-5

### MeetBot

There is a bot (ovirtbot) in the #ovirt IRC channel that can be used for running IRC meetings. For information on using it, see [here](http://wiki.debian.org/MeetBot)

### oVirt Weekly Sync Meeting Minutes and Logs

#### 2012

*   2012-11-14
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-11-14-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-11-14-14.00.log.html)
*   2012-11-07 -- Cancelled
*   2012-10-31
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-31-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-31-14.00.log.html)
*   2012-10-24
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-24-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-24-14.00.log.html)
*   2012-10-17
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-17-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-17-14.00.log.html)
*   2012-10-10
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-10-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-10-14.00.log.html)
*   2012-10-03
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-03-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-03-14.00.log.html)
*   2012-09-26
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-26-14.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-26-14.01.log.html)
*   2012-09-19
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-19-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-19-14.00.log.html)
*   2012-09-12
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-12-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-12-14.00.log.html)
*   2012-09-05
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-05-14.07.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-09-05-14.07.log.html)
*   2012-08-29 -- Cancelled
*   2012-08-22
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-22-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-22-14.00.log.html)
*   2012-08-15
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-15-14.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-15-14.01.log.html)
*   2012-08-08
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-08-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-08-14.00.log.html)
*   2012-08-01
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-01-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-01-14.00.log.html)
*   2012-07-25
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-25-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-25-14.00.log.html)
*   2012-07-18
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-18-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-18-14.00.log.html)
*   2012-07-11
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-11-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-11-14.00.log.html)
*   2012-07-05
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-05-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-05-14.00.log.html)
*   2012-06-27
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-27-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-27-14.00.log.html)
*   2012-06-20
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-20-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-20-14.00.log.html)
*   2012-06-13
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-13-14.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-13-14.01.log.html)
*   2012-06-06
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-06-14.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-06-14.01.log.html)
*   2012-05-30
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-30-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-30-14.00.log.html)
*   2012-05-23
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-23-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-23-14.00.log.html)
*   2012-05-16
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-16-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-16-14.00.log.html)
*   2012-05-09
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-09-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-09-14.00.log.html)
*   2012-05-02
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-02-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-02-14.00.log.html)
*   2012-04-24
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-24-14.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-24-14.00.log.html)
*   2012-04-04
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-04-15.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-04-15.01.log.html)
*   [Meetings_archive](Meetings_archive)

### oVirt Node Weekly Meeting Minutes and Logs

**2012**

*   2012-10-23
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-23-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-23-13.00.log.html)
*   2012-10-16
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-16-13.03.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-10-16-13.03.log.html)
*   2012-08-07
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-07-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-08-07-13.00.log.html)
*   2012-07-31
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-31-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-31-13.00.log.html)
*   2012-07-24
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-24-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-24-13.00.log.html)
*   2012-07-17
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-17-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-17-13.00.log.html)
*   2012-07-10
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-10-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-10-13.00.log.html)
*   2012-07-03
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-03-13.02.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-07-03-13.02.log.html)
*   2012-06-26
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-26-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-26-13.00.log.html)
*   2012-06-19
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-19-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-19-13.00.log.html)
*   2012-06-12
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-12-13.02.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-12-13.02.log.html)
*   2012-06-05
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-05-13.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-06-05-13.01.log.html)
*   2012-05-29
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-29-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-29-13.00.log.html)
*   2012-05-22
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-22-13.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-22-13.01.log.html)
*   2012-05-08
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-08-13.03.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-05-08-13.03.log.html)
*   2012-04-24
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-24-13.01.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-24-13.01.log.html)
*   2012-04-17
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-17-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-17-13.00.log.html)
*   2012-04-03
    -   [Minutes](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-03-13.00.html)
    -   [Full log](http://ovirt.org/meetings/ovirt/2012/ovirt.2012-04-03-13.00.log.html)
*   [Meetings_archive](Meetings_archive)
