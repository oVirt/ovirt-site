---
title: Meetings
authors: abaron, bproffitt, danken, dneary, lpeer, mburns, quaid, rbergeron, rmiddle,
  sandrobonazzola, sgordon
---

<!-- TODO: Content review -->

# Meetings

This is the page for meeting information.

## oVirt Weekly Sync Meeting

oVirt has a weekly sync meeting on IRC (occasionally phone).

### Agenda

#### Weekly project sync meeting

This is the usual agenda for the weekly sync meetings:

*   Agenda and Roll Call
*   Infra update
*   3.5.z updates
*   3.6 status
*   Conferences and Workshops
*   Other Topics

### Meeting Time and Place

*   oVirt Weekly Sync
    -   Wednesdays @ 16:00 CET - always at 10:00am US Eastern.
    -   To see in your timezone '''date -d 'WEDNESDAY 1600 CET' **\1**date -d 'TUESDAY 0900 EST' **\1**date -d 'Monday 1000 EST' **\1**date --date='TZ="Asia/Jerusalem" 16:00 next Wed' '''
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
    -   To see in your timezone '''date --date='TZ="Asia/Jerusalem" 16:30 next Tue' '''
    -   To see if this is a week with a meeting,

      ` wk=`date --date='TZ="Asia/Jerusalem" 16:30 next Tue' +"%W"`; `
      if [ $(($wk % 2)) == 1 ]; then
        echo "Meeting next Tuesday";
      else
        echo "No meeting next Tuesday";
      fi

*   -   On IRC: #vdsm on chat.freenode.net
    -   Intercall (see [here](intercall) for more info) conference ID: 353-86-075-901

### MeetBot

There is a bot (ovirtbot) in the #ovirt IRC channel that can be used for running IRC meetings. For information on using it, see [here](http://wiki.debian.org/MeetBot)

### oVirt Weekly Sync Meeting Minutes and Logs

#### 2013

*   2013-04-10
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-04-10-14.01.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-04-10-14.01.log.html)
*   2013-04-03
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-04-03-14.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-04-03-14.00.log.html)
*   2013-03-27
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-03-27-14.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-03-27-14.00.log.html)
*   2013-03-20
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-03-20-14.02.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-03-20-14.02.log.html)
*   2013-03-13
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-03-13-14.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-03-13-14.00.log.html)
*   2013-03-06
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-03-06-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-03-06-15.00.log.html)
*   2013-02-27
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-02-27-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-02-27-15.00.log.html)
*   2013-02-20
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-02-20-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-02-20-15.00.log.html)
*   2013-02-13
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-02-13-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-02-13-15.00.log.html)
*   2013-02-06
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-02-06-15.01.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-02-06-15.01.log.html)
*   2013-01-30
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-01-30-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-01-30-15.00.log.html)
*   2013-01-23
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-01-23-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-01-23-15.00.log.html)
*   2013-01-16
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-01-16-15.00.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-01-16-15.00.log.html)
*   2013-01-09
    -   [Minutes](/meetings/ovirt/2013/ovirt.2013-01-09-15.01.html)
    -   [Full log](/meetings/ovirt/2013/ovirt.2013-01-09-15.01.log.html)
*   2013-01-02 -- Cancelled

#### 2012

*   2012-12-26 -- Cancelled
*   2012-12-19
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-12-19-15.02.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-12-19-15.02.log.html)
*   2012-12-12
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-12-12-15.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-12-12-15.00.log.html)
*   2012-12-05
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-12-05-15.02.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-12-05-15.02.log.html)
*   2012-11-28
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-11-28-15.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-11-28-15.00.log.html)
*   2012-11-21
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-11-21-15.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-11-21-15.00.log.html)
*   2012-11-14
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-11-14-15.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-11-14-15.00.log.html)
*   2012-11-07 -- Cancelled
*   2012-10-31
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-31-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-31-14.00.log.html)
*   2012-10-24
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-24-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-24-14.00.log.html)
*   2012-10-17
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-17-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-17-14.00.log.html)
*   2012-10-10
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-10-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-10-14.00.log.html)
*   2012-10-03
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-03-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-03-14.00.log.html)
*   2012-09-26
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-09-26-14.01.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-09-26-14.01.log.html)
*   2012-09-19
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-09-19-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-09-19-14.00.log.html)
*   2012-09-12
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-09-12-14.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-09-12-14.00.log.html)
*   2012-09-05
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-09-05-14.07.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-09-05-14.07.log.html)

<!-- -->

*   [Meetings_archive](/community/about/meetings-archive/)

### oVirt Node Weekly Meeting Minutes and Logs

**2012**

*   2012-10-23
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-23-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-23-13.00.log.html)
*   2012-10-16
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-10-16-13.03.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-10-16-13.03.log.html)
*   2012-08-07
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-08-07-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-08-07-13.00.log.html)
*   2012-07-31
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-07-31-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-07-31-13.00.log.html)
*   2012-07-24
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-07-24-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-07-24-13.00.log.html)
*   2012-07-17
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-07-17-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-07-17-13.00.log.html)
*   2012-07-10
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-07-10-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-07-10-13.00.log.html)
*   2012-07-03
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-07-03-13.02.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-07-03-13.02.log.html)
*   2012-06-26
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-06-26-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-06-26-13.00.log.html)
*   2012-06-19
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-06-19-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-06-19-13.00.log.html)
*   2012-06-12
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-06-12-13.02.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-06-12-13.02.log.html)
*   2012-06-05
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-06-05-13.01.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-06-05-13.01.log.html)
*   2012-05-29
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-05-29-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-05-29-13.00.log.html)
*   2012-05-22
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-05-22-13.01.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-05-22-13.01.log.html)
*   2012-05-08
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-05-08-13.03.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-05-08-13.03.log.html)
*   2012-04-24
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-04-24-13.01.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-04-24-13.01.log.html)
*   2012-04-17
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-04-17-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-04-17-13.00.log.html)
*   2012-04-03
    -   [Minutes](/meetings/ovirt/2012/ovirt.2012-04-03-13.00.html)
    -   [Full log](/meetings/ovirt/2012/ovirt.2012-04-03-13.00.log.html)
*   [Meetings_archive](/community/about/meetings-archive/)
