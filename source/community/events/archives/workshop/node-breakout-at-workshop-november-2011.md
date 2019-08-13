---
title: Node breakout at oVirt workshop November 2011
category: event/workshop
authors: apevec, mburns
---

# Node breakout at oVirt workshop November 2011


      Node Breakout Session

      Suse studio -- web based (openid)
      Create a new appliance
          base template -- predefined sets of packages/config
          choose architecture
          give name
      Editor
          Tabs
              software -- choose packages
                  shows dependencies that are pulled
                  ability to add additional repositories
                  can build multiple distros
              Configuration
                  General
                      locale, time
                      firewall
                      networking
                      users/groups
                      prompts with problems in package selection
                  Options to change personalization, startup, server opens (postgres), desktop, appliance configuration, lvm
                  scripts to run at end of build or firstboot
              Files
                  drop jboss as jboss, etc...
              Build
                  trigger build
                  multiple formats include usb, iso, etc
              Share 
                  publish to suse gallery
                  
          Test Drive -- starts appliance you just built
              Ability to see what changed since boot (how it works: http://nat.org/blog/2009/07/linux-in-the-browser/)
              selectively add changes to the appliance definition
      Kiwi is backend of Suse Studio
          can export appliance as kiwi config
          
          
      openbuildservice.org
      susestudio.com
      KIWI: 

          http://opensuse.github.com/kiwi/

          http://en.opensuse.org/Portal:KIWI

          https://github.com/opensuse/kiwi

          https://github.com/openSUSE/kiwi/tree/master/template/ix86/rhel-05.4-JeOS

      ovirt-node.git walkthrough
      - boot process
        ovirt-early
        ovirt-firstboot
        (there are legacy scripts from previous ovirt-server project, need to cleanup)
      SUSE resources on liveCD:

          http://gitorious.org/opensuse/clicfs/trees/master

          http://lizards.opensuse.org/2009/05/15/livecd-performance-clicfs-vs-squashfs/

          http://lizards.opensuse.org/2009/04/28/whats-behind-lzma-compressed-livecds/

      TODO

          start discussion on node-devel if kiwi XML can be used as a distro neutral recipe format?

          define "VirtualizationMinimal" package group for each distro

          cleanup current recipe

          clean current scripts, mark distro specific parts

          Roadmap for Stateless

          Convert to distro neutral configuration changes (netcf, etc...)

[Category:Workshop November 2011](/community/events/archives/workshop/workshop-november-2011/)
