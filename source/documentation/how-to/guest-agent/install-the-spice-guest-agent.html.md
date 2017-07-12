---
title: How to install the spice guest agent
category: howto
authors: nkesick
---

# How to install the spice guest agent

Installing the Spice Guest Agent in a Linux virtual machine is fairly simple and will provide a better guest console experience. For more information, see the [Spice Agent](/documentation/internal/guest-agent/understanding-guest-agents-and-other-tools/#spice-agent) section. In many recent Linux distibutions, the Spice Guest Agent is installed by default with the desktop install. If you performed a custom install or have an older distribution, these directions will still apply. The process has one main step which is installing the spice-vdagent package.

## Methods for Installation

There are two methods you can use. The easiest is to use a terminal prompt or through the Software Center application, where available. This requires that the virtual machine has access to the internet or at least to a repository mirror.

### Fedora

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
Installing on a Fedora guest? Click to expand this section.

<div class="mw-collapsible-content">

1 Open Terminal

2 Run the following command

<!-- -->

    sudo yum install spice-vdagent

</div>
</div>
### Centos/RHEL 5,6,7

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
Installing on a Centos guest? Click to expand this section.

<div class="mw-collapsible-content">
Note: Available for RHEL/CentOS 5, 6 and 7 in [EPEL](https://fedoraproject.org/wiki/EPEL) **Centos 6.x**

**Centos 7.x**

1 Open Terminal

2 Run the following command

<!-- -->

    sudo yum install spice-vdagent

</div>
</div>
### Ubuntu

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
Installing on a Ubuntu? Click to expand this section.

<div class="mw-collapsible-content">
Ubuntu 14.04 LTS and Newer

1 Open Terminal

2 sudo apt-get install spice-vdagent

</div>
</div>
### Debian

<div class="toccolours mw-collapsible mw-collapsed" style="width:800px">
Installing on a Debian 7+ guest? Click to expand this section.

<div class="mw-collapsible-content">
**Via Add/Remove Software**

1 Click Applications > System Tools > Add/Remove Software

2 Search for "spice-vdagent"

3 Check the box below the spice-vdagent package and press apply to install.

**Via Terminal** (rough draft - in default repos or refer to external repo?)

1 Open Terminal

2 Run the following commands

<!-- -->

    # su -
    # apt-get install spice-vdagent

</div>
</div>
### OpenSUSE

OpenSUSE does not appear to have the spice-vdagent package at this time.
