---
title: Infrastructure
category: infra
authors: dcaroest, dneary, eedri, ekohl, eyale, herrold, knesenko, ngoldin, quaid,
  rmiddle
---

# Infrastructure 基础设施

Here is the Infrastructure Team and what we work on for the [oVirt project](/).

## Mission Statement 使命宣言

oVirt Infra团队是通过遵循开源的原则和公认的系统管理员的专业标准来提供社区基础设施服务的志愿者。

## Team

基础设施项目的维护者是：

*   **Infrastructure Lead:** David Caro (Dcaroest),Anton Marchukov (amarchuk)
*   **Release Manager:** Sandro Bonazzola (Sbonazzo)
*   **CI Leads:** Eyal Edri (Eyal), David Caro (Dcaroest),Anton Marchukov (amarchuk)
*   **Repositories/Build Lead:** Sandro Bonazzola (Sbonazzo), David Caro (Dcaroest)
*   **Gerrit Admins:**Eyal Edri (eedri), David Caro (Dcaroest), Anton Marchukov (amarchuk)
*   **Puppet and Foreman Lead:** Ewoud Kohl van Wijngaarden (Ekohl), David Caro (Dcaroest),Barak Korren (Bkorren)
*   **Mail Servers** Karsten Wade (Quaid),Michael Scherer (Misc)

Read [Becoming an Infrastructure team member](/develop/infra/becoming-an-infrastructure-team-member/) for details on joining this project.

Read [Infrastructure team assignments](/develop/infra/infrastructure-team-administrators/) for information about who has access to which parts of the oVirt infrastructure.

### Apprentices and journeyfolk 学徒和熟练工？

In addition to the maintainers, there are newer Infrastructure team members who have not yet become maintainers. They are at the very beginning (apprentices) or nearing the end (journeyfolk):
除了维护人员之外，还有更新的基础结构团队成员，他们还没有成为维护人员。他们在最开始(学徒)或接近尾声(熟练):

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

## Type of tasks 任务类型

As a devops team, our tasks varies and includes multiple possible ways of coding or maintaining the oVirt infra, some examples: 作为一个devops团队，我们的任务是多样的，包括各种可能的开发或者维护ovirt基础设施，举例：

*   Writing puppet manifests  编写puppet manifests
*   Writing yaml code via jenkins job builder to add new jobs 编写yaml代码，通过jenkins任务构建系统来添加新的任务
*   Installing a new service / server  安装一个新的服务、服务器
*   Helping users on the list, usually with gerrit or jenkins issues 帮助列表中的用户，通常是使用gerrit【代码审核】和jenkins【持续集成】的问题
*   Helping to develop tools (we've got plenty!)  帮助开发工具（我们有很多！）

## How we work 我们如何工具

This is a [community services infrastructure](http://fedorahosted.org/csi/) team. That means the project infrastructure is maintained to a [professional level](http://mmcgrath.fedorapeople.org/html-single/) by a group of system administrators who are contributing their time. (That time may be contributed as part of their job role, it might be part of a class or workshop, it might be purely voluntary, and so forth.)

People who come to work on this project are *not* already experts, but they might be. You are welcome to learn with us.

### Opening tickets to the Infra team

*   Email infra-support@ovirt.org, this will automatically open a ticket on our [Jira instance](https://ovirt-jira.atlassian.net/secure/RapidBoard.jspa?rapidView=1&projectKey=OVIRT). If you don't have a user, it will automatically send you a registration email and set you as a watcher on the ticket.

### Joining

*   To gain access to systems - think of them as keys to doors - we match your skill and the trust you have built with the project. This is part of being a [meritocracy](/community/about/governance/).
*   Interested to join the Infrastructure Team ? [Click here](/develop/infra/becoming-an-infrastructure-team-member/)

### Communication

The main thing is, come [communicate with us](#Communication) if you have any questions, are interested in learning more, or what to participate in supporting oVirt infrastructure.

*   [Mailing list infra@ovirt.org](http://lists.ovirt.org/mailman/listinfo/infra)
*   [IRC channel #ovirt on OFTC](irc://irc.oftc.net/#ovirt)

### Meetings

[Infrastructure Meetings](/develop/infra/infrastructure-team-meetings/)

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

We're currently working on migrating all our infra into a new datacenter. check [Infra Migration Plan](/develop/infra/services-migration-plan/) for details.

### oVirt Instances

We have some oVirt instances installed and we use them for our infrastructure. For more information please click [here](/develop/infra/infrastructure-instances/)

### Documentation

We are in the process of moving all our documentaion to be inside our git repos, and published as HTML. You can find the published docs at: <http://ovirt-infra-docs.readthedocs.org/en/latest/>
