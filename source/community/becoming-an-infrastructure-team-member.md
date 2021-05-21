---
title: Becoming an Infrastructure team member
category: community
authors:
  - dneary
  - quaid
  - sandrobonazzola
---

# Becoming an Infrastructure team member

This page describes the process for becoming a member of the Infrastructure team (a [maintainer](/develop/dev-process/becoming-a-maintainer.html).)

## Step 1: Get involved

The Infrastructure team primarily uses three resources to get stuff done:

* [The infra mailing list](https://lists.ovirt.org/archives/list/infra@ovirt.org/) for asynchronous communication
* [oVirt infra Jira](https://ovirt-jira.atlassian.net/browse/OVIRT) for issue tracking

In general, the team hangs out on the general `#ovirt` IRC channel on OFTC (`irc.oftc.net`).

To start getting involved in the Infrastructure team, introduce yourself on the mailing list.
Your self-introduction should include your name, relevant experience, and why you are interested in helping with oVirt infrastructure.

In step 1, you should get familiar with
* [the team goals](/develop/infra/infrastructure-documentation.html) 
* [the team members](/develop/infra/infrastructure-team-administrators.html)
* the skills we have
* the infrastructure we use (such as [git](/develop/infra/infrastructure-git-repository.html) and [puppet](/develop/infra/infrastructure-puppet-details.html))
* [the things we have on our agenda to accomplish](https://ovirt-jira.atlassian.net/browse/OVIRT).
* our team [documentation](/develop/infra/infrastructure-documentation.html)
* our [standard procedures](/develop/infra/infrastructure-sop.html).

Perhaps you have the time and skills to make suggestions as to how something might be accomplished or research possible solutions to a problem and make a proposal,
to allow other team members to put a solution in place quickly?
Perhaps you've noticed something which can be improved, and you would like to add an issue to our Jira instance to help ensure it gets done.

## Step 2: Propose changes - build trust

After a few weeks participating in the mailing list, you will begin to build trust in the team.
Patch proposals, and showing good judgement in the changes you propose, will accelerate the trust process.

There are several ways you can get directly involved:

* Get a limited shell (ssh) access to one or more hosts.
  Use this access to look around and understand intimately how services and hosts are constructed and configured.
* Get a limited admin access to one or more web services, such as Foreman, for another view in to how the infrastructure is handled.
* As the team defines and designs them, take on a sub-role with limited sudo access to perform specific tasks on machines,
  such as log analysis or checking backups and cronjobs occurred properly, etc.
* All of the above gives most of what is needed to troubleshoot any active issues that occur in the oVirt infrastructure.
  It's possible to help maintainers by identifying problems and suggesting fixes, which builds trust in your skills and ideas.
* As you begin to understand how the infrastructure and processes work, propose full features or fixes on the mailing list, and work with maintainers to make the changes happen.
* Start off a new service or instance of a service using our virtualized infrastructure to
  [become an administrator of a virtual machine](/develop/infra/adding-a-new-system-administrator-to-a-host.html).
  As an apprentice administrator, the service will be in incubation for a period of time, during which your administration and promotion of the service will be observed.

When you begin all this work with the intention of joining the team, you will be given the status of *apprentice*.

## Step 3: Apprentive to maintainer

After an incubation period, whose length will depend on the quality and quantity of your contributions, and your cultural fit with the team,
you will become [a core team member](/develop/infra/infrastructure.html#team). Congratulations!

