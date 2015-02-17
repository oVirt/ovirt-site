---
title: Engine Setup
authors: didi
wiki_title: Engine Setup
wiki_revision_count: 3
wiki_last_updated: 2015-02-17
---

# Engine Setup

Some information about engine-setup and related tools - this currently includes engine-setup, engine-cleanup and [ovirt-engine-rename](Changing_Engine_Hostname).

These tools are based on [Otopi](Otopi).

### Configuration

These tools share the following:

#### /etc/ovirt-engine-setup.conf.d/\*.conf

All of these tools read all of the configuration files /etc/ovirt-engine-setup.conf.d/\*.conf .

Generally speaking, users should not touch these files. Some of them are shipped inside the rpm packages, and some are maintained by the tools themselves - keeping state needed between runs of these tools.

#### Answer files

All of these tools generate upon completion an answer file, named '/var/lib/ovirt-engine/setup/answers/\*.conf', and mention that in their output.

The expected way to use these answer files is:

1.  Have a system A in some state S0
2.  Run one of the tools interactively, answer its questions as needed, let it create an answer file Ans1.
3.  System A is now in state S1.
4.  Have some other system B in state S0, that you want to bring to state S1.
5.  Run there the same tool with --config-append=Ans1

Manually editing such an answer file is generally not supported/expected. You might do that to achieve special non-standard goals. If you do that, you should thoroughly verify that it works for you, and use in a controller environment - same known initial state, same versions of relevant stuff, etc.

Just as an example for a simple and useful violation, if during testing you often run engine-setup on systems with little RAM, and want to get rid of the question if you want to continue with not enough RAM, you can create a file e.g. /etc/ovirt-engine-setup.conf.d/99-my-stuff.conf with content:

      [environment:default]
      OVESETUP_SYSTEM/memCheckEnabled=bool:False
