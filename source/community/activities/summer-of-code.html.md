---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
wiki_title: Summer of Code
wiki_revision_count: 19
wiki_last_updated: 2015-03-03
---

<!-- TODO: Content review -->

# Summer of Code

For more information about Google Summer of Code (GSoC), please refer to the [official page](https://developers.google.com/open-source/gsoc/).

## Information on oVirt and the Google Summer of Code

### For Students

Please read information about our [application requirements and advice for students](/community/activities/summer-of-code-students/) in addition to reviewing the ideas on this page. This list is not exclusive, and there are other ways you can define your GSoC project idea. It would be a good idea contribute some code for the project you are applying to work on before or during the application process.

The best way to reach out to the oVirt community about the GSoC is through these methods:

*   **Mailing List:** users@ovirt.org
*   **IRC:** #ovirt on OFTC
*   **[ oVirt GSoC Admins](#oVirt_GSoC_Admins)**

### For Mentors

The ideas can be any project that is oVirt-related and can benefit the oVirt community. When adding a project idea, please try to follow those guidelines:

*   Discuss your idea with oVirt community members in #ovirt to get their input and plan collaboration.
*   Consider ideas that consist of manageable and relevant tasks that the student can land in oVirt throughout the internship period.
*   If you're interested in mentoring the idea, put your name. If not, then just leave it blank.
*   Do not list multiple ideas with only one list item. Use multiple items instead.
*   Briefly explain why this would be great for oVirt.
*   Do not write lots of text to explain your idea. If this is going to be long, maybe it's worth creating a page for it?
*   Make sure students who do not know much about oVirt can understand the proposed idea.

When students approach you about the idea you listed:

*   Be clear with them about whether it is suitable for new contributors or for their experience level.
*   Be prepared to give them a simple bug to fix or task to complete for your module and help them along with the setup and questions about the code. Encourage them to continue on fixing more bugs or writing code for the idea they are planning to apply for.
*   If you already have a strong student applying to work on the idea, redirect other students to find other ideas to propose instead or in addition to your idea.
*   If you already have as many strong students applying to work on the ideas you plan to mentor as you can handle, redirect other students to find other ideas and mentors.
*   If you are redirecting students from your idea, please add [No longer taking applicants] to its title in the list below.
*   Don't hesitate to reach out to the oVirt GSoC admins if you need help redirecting students.

## oVirt Ideas for Google Summer of Code 2017

### **Idea:** ovirt4cli

**Description:** A configshell-based CLI for oVirt 4.x. Uses the new Python SDK (utilizing v4 REST API).

**Expected results:** A more robust command-line interface for oVirt 4.1 and beyond.

**Knowledge Prerequisite:** Python

**Mentor:** [Yaniv Kaul](mailto:ykaul@redhat.com)

### **Idea:** Packer/oVirt Integration

**Description:** Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. This project would integrate Packer features into oVirt.

**Expected results:** Creating identical machine images within oVirt

**Mentor:** [Yaniv Kaul](mailto:ykaul@redhat.com)

### **Idea:** Configuring a backup storage in oVirt

**Description:** Backup storage will eventually replace the export storage domain in oVirt.

**Expected results:** The idea behind this feature is that the user will be able to configure any storage domain as backup storage domain so other platforms can use this storage domain as backup and copy VMs and data from it.

Once the storage domain is configured as backup the engine will block any running VMs or any changes that might be in the storage domain.

Eventually after this change we will be one step closer to a suitable alternative solution for the export domain.

**Mentor:** [Maor Lipchuk](mailto:mlipchuck@redhat.com)

### **Idea:** ovirt-updater tool

**Description:** CLI tool for oVirt Hypervisors which provides easy upgrade and downgrade mechanism to any supported oVirt version.

**Expected results:** The tool allows manual hypervisor upgrade to any cluster level support. i.e. "ovirt-updater --version 3.6" will install the required yum repositories that fits cluster oVirt-3.6 and will upgrade the required system's packages using yum Python sdk. The tool will provide fallback flow when upgrade fails - this helps to stablize the upgrade process and reduces the risks before upgrading.

**Knowledge Prerequisite:** Python

**Mentor:** [Yaniv Bronhaim](mailto:ybronhei@redhat.com)

### **Idea:** Test-Kitchen/oVirt Integration

**Description:** Test Kitchen (http://kitchen.ci/ ) is an integration tool for developing and testing infrastructure code and software on isolated target platforms.

**Expected results:** A driver that uses the ovirt ruby sdk gem to provision and destroy oVirt instances for your infrastructure testing.

**Knowledge Prerequisite:** Python

**Mentor:** [Marc Young](mailto:3vilpenguin@gmail.com)

### Idea: Host reservation system for testing multiple oVirt instances

**Description:** Community of QE is in need of a tool that would be able to pool hosts as a resource. Idea of this web service reservation system  is to maintain unused activated hosts within assigned engines and be able to move them
from one engine to another. This orchestration on top of data centers would enable oVirt community easier development and testing on multiple oVirt instances.

**Expected results:** Tool to enable host pooling between different instances of oVirt.

**Knowledge Prerequisite:** Ansible, Web development

**Mentor:** [Lukas Svaty](mailto:lsvaty@redhat.com)

### Idea: Ansible playbooks for ovirt deployment with remote resources

**Description:** Ansible playbooks which are able to setup, upgade, cleanup, collect logs oVirt engine already exist, however at the moment these are lacking support for engine with resources on remote servers (database, history  aggregation service). Purpose of this project is to align currently created roles with scenarious of remote resources mentioned above.

**Expected results:** Ansible playbooks for ovirt-engine with remote resources such as databases or dwh service.

**Knowledge Prerequisite:** Ansible

**Mentor:** [Lukas Svaty](mailto:lsvaty@redhat.com)

## oVirt Ideas for Google Summer of Code 2015

### **Idea:** Probe Network Configuration

**Description:** An oVirt cluster contains multiple hosts that may be very different from one another when it comes to their network connectivity. Host A may have network Red and Blue connected to its `eth0` and `eth1` cards respectively, while in Host B both networks are reachable via `eth7`. When adding a fresh host C to this cluster, telling which network should be defined on which host may be quite a headache.

I'd like to see a semi-automatic configuration flow, where upon request, and existing host is asked to broadcast its network definition on top of its configured LANs. A broadcast message with the payload "Red" would be sent on top of `eth0` to neighboring hosts. If host C is connected to this network, and can sniff "Red" on its `em1` interface, it should report to Engine that network "Red" should better be configured on top of `em1`.

**Expected results:** After adding a new host to the system, Engine should be able to tell which networks does the new host see and on which interface.

**Knowledge Prerequisite:** Python

**Mentor:** [Dan Kenigsberg](mailto:danken@redhat.com)

### **Idea:** Support DNS configuration with static IP

**Description:** oVirt allows to configure the IPv4 address of network interfaces of the hosts it controls. Addresses can be acquired via DHCP are specified explicitly (static addresses). A DHCP server can (and normally does) supply address(es) of DNS (domain name server). We would like to specify primary and secondary DNS addresses for the management network, when it is set to use a static address.

**Expected results:** Vdsm API is augmented to accept a list of DNS addresses for one network. These addresses would be added to the host /etc/resolv.conf (most probably needs integration with systemd-resolved.service and/or NetworkManager). Engine API and GUI would be augmented too, to support adding these addresses, and use the new Vdsm API to set them on hosts.

**Knowledge Prerequisite:** Python (for Vdsm side), Java (for the Engine side)

**Mentor:** [Dan Kenigsberg](mailto:danken@redhat.com)

## oVirt Ideas for Google Summer of Code 2014

### **Idea:** Gerrit add potential reviewers

**Description:** In the open source world, when a contributor want to contribute a code to a project, he/she must gets the acknowledgement of the project maintainers for your code.
Most of the time, the review process is being done by gerrit, a web based code review and project management for Git based projects.
When the contributor submit the patch in Gerrit, he/she should add reviewers so the review process will take place, but sometimes the contributor can't be sure which reviewers will be best to add for the patch.
The contributor will sometime use the blame function to check which contributor changed most of the module recently, or any other method he thinks will be best.
The proposed project is to add to the git-review, a command-line tool for Git, an option for adding a potential reviewers to the contributor's patch.
After the contributor will submit his patch, he can use the git-review to add a potential reviewers by a specific method he will choose (blame on changed code, blame on module...)

**Expected results:** The user will add the potential reviewers he will think will be best to review his patch.

**Knowledge Prerequisite:** Python, git-review, git, gerrit

**Mentor:** [Maor Lipchuk](mailto:mlipchuk@redhat.com)

## oVirt GSoC Admins

*   [Brian Proffitt](mailto:bkp@redhat.com)
