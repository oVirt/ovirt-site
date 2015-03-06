---
title: Outreachy
authors: bproffitt, danken, gshereme, sandrobonazzola, tjelinek
wiki_title: Outreachy
wiki_revision_count: 11
wiki_last_updated: 2015-03-10
---

# Outreachy

![](Outreachy-poster-2015-May-August.png "Outreachy-poster-2015-May-August.png")

oVirt is pleased to announce it will be participating in the May-August 2015 round of [Outreachy](//www.gnome.org/outreachy/), organized by the [GNOME Foundation](//www.gnome.org/foundation/), [Software Freedom Conservancy](//sfconservancy.org/), and [Red Hat](//redhat.com).

Outreachy helps women (cis and trans) and genderqueer get involved in free and open source software. The program provides a supportive community for beginning to contribute any time throughout the year and offers focused internship opportunities twice a year with a number of free software organizations.

## Information for Participants

oVirt, with the help of sponsors, will sponsor internships from May 25 to August 25, 2015. Any woman who has not previously participated in an Outreach Program for Women, Outreachy, or Google Summer of Code internship is welcome to apply, provided she is available for a full-time internship during this time period. This program is open to anyone who was assigned female at birth and anyone who identifies as a woman, genderqueer, genderfluid, or genderfree regardless of gender presentation or assigned sex at birth. Participants must be at least 18 years old at the start date of the internship. Residents or nationals of Iran, Syria, Cuba, Sudan, and North Korea, with whom the GNOME Foundation, Software Freedom Conservancy, and Red Hat, Inc., being U.S. organizations, are prohibited by U.S. law from engaging in commerce, are ineligible to participate.

Because the program is intended to help newcomers and contributors who are relatively new to the FOSS community to get more involved, Outreachy unfortunately can't accept past participants of Outreach Program for Women, Outreachy, or Google Summer of Code internships. However, if you qualify for Google Summer of Code, you are more than welcome to apply for it.

Students in the Southern Hemisphere, for whom the program will align with the large portion of their summer break, are especially invited to apply for the program. Because of the full-time requirement, it is recommended that students in the Northern Hemisphere do not apply for this round of the program, but instead start contributing in their spare time to prepare to apply for the next round of Outreachy or Google Summer of Code, which will have an application deadline in October 2015 and internship dates beginning in December 2015.

The internships offered are not limited to coding, but include user experience design, graphic design, documentation, web development, marketing, translation and other types of tasks needed to sustain oVirt.

The internship is expected to be a full-time effort, meaning that the participants must be able to spend 40 hours a week on their project. Participants will work remotely from home. Because IRC (Internet Relay Chat) is one of the primary means of communication within oVirt, participants should be present on oVirt's IRC (#ovirt @ OFTC) channel while working. You will also be expected to communicate electronically with other project members via other means, including Bugzilla bug tracker comments, mailing list discussion, blog posts, and personal e-mail. Participants will be expected to blog at least once every two weeks about their work and their blog posts will be included on the site that publishes oVirt blog posts, currently [community.redhat.com](//community.redhat.com).

The GNOME Foundation will be administering the payments of the $5,500 (USD) stipends each participant will receive according to the schedule specified here. In addition, a $500 (USD) travel allowance will be available to the interns.

### How to Apply

The application deadline is March 24, 2015. The application process is very interactive, and potential interns are expected to work with program mentors even as they are applying. oVirt mentors will work with participants before and after the application process to help integrate potential interns into the oVirt ecosystem, and continue working with accepted interns as the program progresses.

For more information, visit the [Outreachy application page](//wiki.gnome.org/Outreachy#Submit_an_Application).

## Information for Mentors

1.  Read the [information for mentors](//wiki.gnome.org/Outreachy/Admin/InfoForMentor) to be familiar with the expectations for the application process, contracts, and mentoring during the internships.
2.  Send a brief e-mail with an introduction and a subject starting with [INTRODUCTION] to outreachy-list@gnome.org - Outreachy will subscribe you to the list and everyone will know who you are! This is a private list for organizations' coordinators and mentors, where prospective applicants can send their inquiries and applications. Outreachy will also subscribe you to the announce list, which is a low-traffic list with important coordination e-mails. While the main list can get busy at times and you are only asked to follow up on e-mails reflecting interest in your organization in the subject, Outreachy asks you to keep a close eye on the e-mails sent to the announce list.
3.  (After March 3) sign up as a mentor in the [online application system](//outreachy.gnome.org/) by following the guide for it.
4.  Start hanging out in #outreachy and #outreachy-admin on GIMPNet (irc.gnome.org).
5.  You are welcome to pitch in answering any questions from prospective applicants on the mailing list and the IRC channel.
6.  At any time, please [send Outreachy](//wiki.gnome.org/action/show/Outreachy/Admin?action=show&redirect=OutreachProgramForWomen%2FAdmin#Contact) any feedback about the program, any questions or concerns.

## Mentor Information

Add yourself as a mentor and ideas you are willing to mentor in this section. Please add your information below, including:

### Tomas Jelinek

**Contact Info:** mail: tjelinek@redhat.com, irc: tjelinek in #ovirt channel in irc.oftc.net
**Ideas You Would like to See for oVirt:** The moVirt project (https://github.com/matobet/movirt) is an Android client for the oVirt project currently intended primarily for monitoring. It recently became an official oVirt incubator project. A video showing it in action is available <https://www.youtube.com/watch?v=QnD9v70oefA> I would like to see the host integration in moVirt making it a useful tool for an admin physically in server room. moVirt could act as a bridge between the physical world of servers and the virtual worlds services running on them. Other option is to make a dashboard useful mostly on tablet devices which would show a visually nice overview of the oVirt datacenter (lots of charts, images etc). Third option would be to keep enriching the current monitoring capabilities by e.g. parsing the server generated events.

### Dan Kenigsberg

**Contact Info:** danken@redhat.com, irc: danken on #ovirt@irc.oftc.net
**Ideas I Would like to See for oVirt:**

1.  *Probe Network Configuration*: An oVirt cluster contains multiple hosts that may be very different from one another when it comes to their network connectivity. Host A may have network Red and Blue connected to its eth0 and eth1 cards respectively, while in Host B both networks are reachable via eth7. When adding a fresh host C to this cluster, telling which network should be defined on which host may be quite a headache. I'd like to see a semi-automatic configuration flow, where upon request, and existing host is asked to broadcast its network definition on top of its configured LANs. A broadcast message with the payload "Red" would be sent on top of eth0 to neighboring hosts. If host C is connected to this network, and can sniff "Red" on its em1 interface, it should report to Engine that network "Red" should better be configured on top of em1.
2.  *Eliminate Vdsm network bugs*: We have many [link bugs](https://bugzilla.redhat.com/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&columnlist=short_desc%2Ccomponent%2Cbug_status%2Cflagtypes.name%2Cassigned_to&component=vdsm&f0=OP&f1=OP&f2=status_whiteboard&f3=CP&f4=CP&f5=component&j1=OR&known_name=net&list_id=2893489&o2=substring&o5=notsubstring&product=oVirt&product=Red%20Hat%20Enterprise%20Linux%206&product=Red%20Hat%20Enterprise%20Virtualization%20Manager&query_based_on=net&query_format=advanced&v2=network&v5=Guide). I'd love to sqush them all, big and small, simple and complex.

### Greg Sheremeta

**Contact Info:** mail: gshereme@redhat.com, irc: gshereme in #ovirt channel in irc.oftc.net
**Ideas You Would like to See for oVirt:** A small, perhaps mobile-friendly client using oVirt.js.

### Dan Kenigsberg

**Contact Info:** mail: danken@redhat.com, irc: danken in #vdsm@irc.freenode.net and #ovirt@irc.oftc.net
**Ideas:**

*   Add [teaming](http://fedoraproject.org/wiki/Features/TeamDriver) support to Vdsm. You would add a new network configurator named ifcfg.team which is just like the ifcfg configurator, but implements a "bond" with a team device.
*   Add a before_ifcfg_write hook point, to let hook writers modify ifcfg files before it is written. Stop passing random kwargs to ifcfg files, and drop the silly "force" argument from the API.

### Sandro Bonazzola

**Name:** Sandro Bonazzola
**Contact Info:** mail: sbonazzo@redhat.com, irc: sbonazzo in #centos-devel@irc.freenode.net, #fedora-devel@irc.freenode.net and #ovirt@irc.oftc.net
**Ideas You Would like to See for oVirt:**

*   Google Web Toolkit properly packaged for Fedora and CentOS 7. It's a pre-requisite to packaging oVirt Engine properly for Fedora and CentOS 7 and can be broken in several minor tasks packaging missing dependencies for GWT.

### Your name here

**Name:**
**Contact Info:**
**Ideas You Would like to See for oVirt:**
