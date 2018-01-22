---
title: Summer of Code
authors: bproffitt, danken, fsimonce, mlipchuk, nsoffer
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
*   **[oVirt GSoC Admins](#ovirt-gsoc-admins)**

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

## oVirt Ideas for Google Summer of Code 2018
<<<<<<< 0478b5a29dbb0b9207627af4ad0aaa6610f32266
=======

### **Idea** KubeVirt/qemu-guest-agent

**Description** The qemu-guest-agent is a useful tool to to communicate directly 
with the guest operating system and KubeVirt project will benefit from
it the same as ovirt does. This project aims to implement support
for qemu-guest-agent in KubeVirt.

**Expected results** The Kubevirt is able to communicate with the qemu-guest-agent: 
send commands to it and read its messages.

**Knowledge Prerequirements** Basic knowledge of Kubernetes, Golang

**Suitable for** first time contributors willing to learn new things

**Mentor** [Petr Kotas](mailto:pkotas@redhat.com)

## oVirt Ideas for Google Summer of Code 2017
>>>>>>> Add new gsoc 2018 proposal

### **Idea:** webadmin localization (reduce GWT permutations)

**Description:** Runtime localization (changing of languages) for oVirt webadmin

**Expected results:** The oVirt webadmin uses the standard GWT tools for localization. GWT uses the concept of "permutations." Since we support 3 browsers and
8 languages, this causes webadmin's GWT compile to run 3 x 8 permutations, which means 24 (very time consuming) compiles. This is very painful for both developers and oVirt's CI systems.

We would like to instead do localization at runtime, reducing the number of GWT permutations to 3.

**Knowledge Prerequisite:** Java

**Mentor:** [Greg Sheremeta](mailto:gshereme@redhat.com)

### **Idea:** port ovirt-web-ui to KubeVirt

**Description:** ovirt-web-ui is a modern, lightweight UI for oVirt. We would like it to work with KubeVirt (a virtual machine management add-on for Kubernetes) as well.

**Expected results:** ovirt-web-ui (already Dockerized) should be adapted to run in Kubernetes. ovirt-web-ui's API should be enhanced or replaced so it works with KubeVirt to start, stop, and console-to virtual machines.

**Knowledge Prerequisite:** JavaScript (react, webpack, etc.), Go (?), Kubernetes

**Mentor:** [Greg Sheremeta](mailto:gshereme@redhat.com)



## oVirt GSoC Admins

*   [Tomas Jelinek](mailto:tjelinek@redhat.com)
*   [Greg Sheremeta](mailto:gshereme@redhat.com)
