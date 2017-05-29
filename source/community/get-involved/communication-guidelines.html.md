---
title: Communication Guidelines
---

# Communication Guidelines

This page lists best practices for communicating on the mailing lists, IRC, Bugzilla, and Gerrit.

## Mailing list guidelines

*   Keep it short - an email to a mailing list is asking a lot of people for their time to read it. Please be concise.
*   Send the email to the correct list: Please only send emails that are on-topic for the list(s) receiving it. You can find a description of the most important community mailing lists on the [mailing lists](mailing lists) page.
*   Cross-posting is accepted in the oVirt project when appropriate - if you want to ask a question which is relevant to project developers, which will need support of the infrastructure team, then cross-posting to arch@ovirt.org and infra@ovirt.org is fine.

## IRC guidelines

*   We hold IRC meetings in the oVirt project - please see [meetings](meetings) for the agenda for team meetings. During meetings, please respect meeting participants and stay on-topic. We use [MeetBot](http://wiki.debian.org/MeetBot) to generate meeting minutes - if you would like to assist with minute taking, you can request "chair" status from the meeting leader.
*   Please use [fpaste](http://fpaste.org/) or [pastebin](http://pastebin.com/) if you would like to share long texts (longer than ~3-4 lines)
*   Answer questions if you can - don't be shy about answering questions, even if the answer is "I don't know". It is always helpful, and like many IRC channels, there can be long periods when not many people are around. So you might be the only person to see the question in real time.
*   Use someone's IRC nick when talking to them. Many IRC clients highlight messages which include their IRC nick, making it easier for them to see when someone has something specific to ask them.
*   Be patient - when asking questions, be aware that perhaps no-one is around. Sometimes answers will arrive only after a few minutes.


## Bug reporting guidelines

*   Before reporting your bug, please [search the bug tracker](https://bugzilla.redhat.com/query.cgi?product=oVirt) to see if it has been reported already. A comment added to an existing bug report is also very useful.
*   To report an issue with oVirt, you first need [an account on our bug tracker](https://bugzilla.redhat.com/createaccount.cgi).
*   Once you have confirmed your email address and are logged in, you can [create a bug against the oVirt product](https://bugzilla.redhat.com/enter_bug.cgi?product=ovirt).
*   If you know which component is causing your problem, then choose that component. Otherwise, if your problem is related to a hypervisor node, choose the "ovirt-node" component. If it is related to the engine, choose "ovirt-engine-core". If you are unsure, choose "ovirt-engine-core", and one of the oVirt developers will reassign the bug for you.
*   When commenting on bugs, please bear in mind that the bug reporter may not know the project as well as possible. If a bug has been reported against the wrong component or product, or if the behaviour observed is expected, please be kind in your comments and explain any changes you make. If you feel the report is not a bug, try to figure out why the expected behaviour is causing problems for the reporter, and suggest a work-around.
*   Above all, be nice. Bug trackers can be emotional places. Separate the person from the problem.

## Code submission guidelines

oVirt uses [Gerrit](http://gerrit.ovirt.org) to manage code submissions.

*   To get started, follow the instructions for [working with oVirt Gerrit](working with oVirt Gerrit)
*   When reviewing a patch, if you are unsure whether the code meets project standards, do not score the patch "-1" or "+1".
*   In comments please be considerate toward the work which the patch submitter has done to submit the patch.
*   For patch submitters: Please familiarise yourself with project coding conventions before submitting a patch. Here are the [Backend Coding Standards](Backend Coding Standards) for all the project parts.

Coding conventions for [ VDSM](Vdsm Developers#Code_Style) are in the wiki, and are included in [ the Maven build process](Building oVirt Engine/IDE) for oVirt Engine.
