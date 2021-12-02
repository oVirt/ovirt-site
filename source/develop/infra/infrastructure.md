---
title: Infrastructure
category: infra
authors:
  - dcaroest
  - dneary
  - eedri
  - ekohl
  - eyale
  - herrold
  - knesenko
  - ngoldin
  - quaid
  - rmiddle
---

# Infrastructure

Here is the Infrastructure Team and what we work on for the [oVirt project](/).

## Mission Statement

The oVirt Infra Team is a volunteer effort to provide community infrastructure services by following the tenets of open source and accepted professional standards of system administrators.

## Team

The maintainers of the Infrastructure project are:

*   **Infrastructure Lead:** David Caro (Dcaroest),Anton Marchukov (amarchuk)
*   **Release Manager:** [Sandro Bonazzola](https://github.com/sandrobonazzola)
*   **CI Leads:** Eyal Edri (Eyal), David Caro (Dcaroest),Anton Marchukov (amarchuk)
*   **Repositories/Build Lead:** [Sandro Bonazzola](https://github.com/sandrobonazzola), David Caro (Dcaroest)
*   **Gerrit Admins:**Eyal Edri (eedri), David Caro (Dcaroest), Anton Marchukov (amarchuk)
*   **Puppet and Foreman Lead:** Ewoud Kohl van Wijngaarden (Ekohl), David Caro (Dcaroest),Barak Korren (Bkorren)
*   **Mail Servers** Karsten Wade (Quaid),Michael Scherer (Misc)

Read [Becoming an Infrastructure team member](/community/becoming-an-infrastructure-team-member.html) for details on joining this project.

Read [Infrastructure team assignments](/develop/infra/infrastructure-team-administrators.html) for information about who has access to which parts of the oVirt infrastructure.

### Apprentices and journeyfolk

In addition to the maintainers, there are newer Infrastructure team members who have not yet become maintainers. They are at the very beginning (apprentices) or nearing the end (journeyfolk):

*   Alexander Rydekull (Rydekull)
*   Michael Scherer (Misc)
*   Shlomi Ben David (Sbendavid)
*   Paz Dangur (Pdangur)
*   Max Kovgan (Mkovgan)
*   Sagi Shnaidman (Sshnaidm)
*   Vishnu Sreekumar (Vissree)
*   Nadav Goldin (ngoldin)
*   Daniel Belenky (dbelenky)
*   Gal Ben Haim (gbenhaim)
*   Gil Shinar (gshinar)
*   Shane Pike (spike)
*   Somansh Arora (sarora)

## Type of tasks

As a devops team, our tasks varies and includes multiple possible ways of coding or maintaining the oVirt infra, some examples:

*   Writing puppet manifests
*   Writing yaml code via jenkins job builder to add new jobs
*   Installing a new service / server
*   Helping users on the list, usually with gerrit or jenkins issues
*   Helping to develop tools (we've got plenty!)

## How we work

This is a [community services infrastructure](http://fedorahosted.org/csi/) team. That means the project infrastructure is maintained to a [professional level](http://mmcgrath.fedorapeople.org/html-single/) by a group of system administrators who are contributing their time. (That time may be contributed as part of their job role, it might be part of a class or workshop, it might be purely voluntary, and so forth.)

People who come to work on this project are *not* already experts, but they might be. You are welcome to learn with us.

### Opening tickets to the Infra team

You can open a ticket on [the infra ticketing system](https://issues.redhat.com/projects/CPDEVOPS/summary).

Please note that sending an email to infra-support@ovirt.org will automatically open a ticket on
the deprecated [oVirt Jira Atlassian instance](https://ovirt-jira.atlassian.net/secure/RapidBoard.jspa?rapidView=1&projectKey=OVIRT)
which is not monitored anymore. Please don't use the infra-support@ovirt.org until it is redirected
to the new [infra ticketing system](https://issues.redhat.com/projects/CPDEVOPS/summary).

### Joining

*   To gain access to systems - think of them as keys to doors - we match your skill and the trust you have built with the project.
*   Interested in joining the Infrastructure Team ? [Click here](/community/becoming-an-infrastructure-team-member.html)

### Communication

The main thing is to communicate with us if you have any questions, are interested in learning more, or want to participate in supporting oVirt infrastructure.

*   [Mailing list infra@ovirt.org](https://lists.ovirt.org/archives/list/infra@ovirt.org/)
*   [IRC channel #ovirt on OFTC](irc://irc.oftc.net/#ovirt)

### Meetings

[Infrastructure Meetings](/develop/infra/infrastructure-team-meetings.html)

### Decision process

* The Infra team generally follows the principle that if it wasn't discussed on the [mailing list](https://lists.ovirt.org/archives/list/infra@ovirt.org/) it didn't really happen.
* This means all important or broad-reaching decisions are discussed and decided on the mailing list.
* The team uses the same [collaborative decision process](https://blogs.apache.org/comdev/entry/how_apache_projects_use_consensus) that other oVirt teams use, with some lightweight elements added to move along minor votes
  * +1 is a vote in favor of a proposition
  * -1 is a vote against a proposition, must be accompanied with an explanation of the negative vote
  * +/-0 is an abstention
  * 3 or more +1 votes are required for anything substantial, important, or far-reaching
  * 0 or more votes will pass a minor proposition - "If no one objects, it passes."

## Our Architecture

An overview of our technical architecture is available [online](https://monitoring.ovirt.org/nagios){:data-proofer-ignore=''}. If you have a question or comment about our architecture please send an e-mail to **infra@ovirt.org** inbox or stop by the [IRC channel #ovirt on OFTC](irc://irc.oftc.net/#ovirt).

### Architecture migration plan

We're currently working on migrating all our infra into a new datacenter. check [Infra Migration Plan](/develop/infra/services-migration-plan.html) for details.

### oVirt Instances

We have some oVirt instances installed and we use them for our infrastructure. For more information please click [here](/develop/infra/infrastructure-instances.html)

### Documentation

We are in the process of moving all our documentation to be inside our git repos, and published as HTML. You can find the published docs at: <http://ovirt-infra-docs.readthedocs.org/en/latest/>
