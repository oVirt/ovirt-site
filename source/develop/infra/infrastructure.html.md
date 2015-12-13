---
title: Infrastructure
category: infra
authors: dcaroest, dneary, eedri, ekohl, eyale, herrold, knesenko, ngoldin, quaid,
  rmiddle
wiki_title: Category:Infrastructure
wiki_revision_count: 30
wiki_last_updated: 2016-02-08
---

# Infrastructure

Here is the Infrastructure Team and what we work on for the [oVirt project](http://ovirt.org).

## Mission Statement

The oVirt Infra Team is a volunteer effort to provide community infrastructure services by following the tenets of open source and accepted professional standards of system administrators.

## Team

The maintainers of the Infrastructure project are:

*   **Infrastructure Lead:** [David Caro](User:Dcaroest),[Anton Marchukov](User:amarchuk)
*   **Release Manager:** [Sandro Bonazzola](User:Sbonazzo)
*   **CI Leads:** [Eyal Edri](User:Eyal), [David Caro](User:Dcaroest),[Anton Marchukov](User:amarchuk)
*   **Repositories/Build Lead:** [Sandro Bonazzola](User:Sbonazzo), [David Caro](User:Dcaroest)
*   **Gerrit Admins:**[Itamar Heim](User:Iheim), [David Caro](User:Dcaroest), [Anton Marchukov](User:amarchuk)
*   **Puppet and Foreman Lead:** [Ewoud Kohl van Wijngaarden](User:Ekohl), [David Caro](User:Dcaroest),[Barak Korren](User:Bkorren)
*   **Mail Servers** [Karsten Wade](User:Quaid),[Michael Scherer](User:Misc)

Read [Becoming an Infrastructure team member](Becoming an Infrastructure team member) for details on joining this project.

Read [Infrastructure team assignments](/develop/infra/infrastructure-team-administrators/) for information about who has access to which parts of the oVirt infrastructure.

### Apprentices and journeyfolk

In addition to the maintainers, there are newer Infrastructure team members who have not yet become maintainers. They are at the very beginning (apprentices) or nearing the end (journeyfolk):

*   [Alexander Rydekull](User:Rydekull)
*   [Michael Scherer](User:Misc)
*   [Paz Dangur](User:Pdangur)
*   [Max Kovgan](User:Mkovgan)
*   [Sagi Shnaidman](User:Sshnaidm)
*   [Vishnu Sreekumar](User:Vissree)
*   [Nadav Goldin](User:ngoldin)
*   [Sharon Naftaly](User:snaftaly)
*   [Shane Pike](User:spike)
*   [Somansh Arora](User:sarora)

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

*   Email infra-support@ovirt.org, this will automatically open a ticket on our [Jira instance](https://ovirt-jira.atlassian.net/secure/RapidBoard.jspa?rapidView=1&projectKey=OVIRT). If you don't have a user, it will automatically send you a registration email and set you as a watcher on the ticket.

### Joining

*   To gain access to systems - think of them as keys to doors - we match your skill and the trust you have built with the project. This is part of being a [meritocracy](Governance).
*   Interested to join the Infrastructure Team ? [Click here](Becoming_an_Infrastructure_team_member)

### Communication

The main thing is, come [communicate with us](#Communication) if you have any questions, are interested in learning more, or what to participate in supporting oVirt infrastructure.

*   [Mailing list infra@ovirt.org](http://lists.ovirt.org/mailman/listinfo/infra)
*   [IRC channel #ovirt on OFTC](irc://irc.oftc.net/#ovirt)

### Meetings

[ Infrastructure Meetings](Infrastructure_team_meetings)

### Decision process

* The Infra team generally follows the principle that if it didn't get discussed on the [mailing list](http://lists.ovirt.org/mailman/listinfo/infra), it didn't really happen.
* This means all important or broad-reaching decisions are discussed and decided on the mailing list.
* The team uses the same [collaborative decision process](https://blogs.apache.org/comdev/entry/how_apache_projects_use_consensus) that other oVirt teams use, with some lightweight elements added to move along minor votes.
  * +1 is a vote in favor of a proposition 
  * -1 is a vote against a proposition, must be accompanied with an explanation of the negative vote.
  * +/-0 is an abstention
  * 3 or more +1 votes are required for anything substantial, important, or far-reaching
  * 0 or more votes will pass a minor proposition - "If no one objects, it passes."

## Our Architecture

An overview of our technical architecture is available [online](http://monitoring.ovirt.org). If you have a question or comment about our architecture please send an e-mail to **infra@ovirt.org** inbox or stop by the [IRC channel #ovirt on OFTC](irc://irc.oftc.net/#ovirt).
As part of an effort to map all oVirt infra resources, an online pad was created [2](http://etherpad.ovirt.org/p/service_list_ovirt).
once the list will be ready and finalized, we'll update the wiki accordingly.

### Architechture migration plan

We're currently working on migrating all our infra into a new datacenter. check [Infra Migration Plan](http://www.ovirt.org/Infra/Services_Migration_Plan) for details.

### oVirt Instances

We have some oVirt instances installed and we use them for our infrastructure. For more information please click [here](Infrastructure oVirt Instances)

### Documentation

We are in the process of moving all our documentaion to be inside our git repos, and published as HTML. You can find the published docs at: <http://ovirt-infra-docs.readthedocs.org/en/latest/>
