---
title: Engine Setup
authors: didi
---

# Engine Setup

Some information about engine-setup and related tools - this currently includes engine-setup, engine-cleanup and [ovirt-engine-rename](/develop/networking/changing-engine-hostname.html).

These tools are based on [Otopi](/develop/developer-guide/engine/otopi.html).

## Configuration

These tools share the following:

### /etc/ovirt-engine-setup.conf.d/\*.conf

All of these tools read all of the configuration files /etc/ovirt-engine-setup.conf.d/\*.conf .

Generally speaking, users should not touch these files. Some of them are shipped inside the rpm packages, and some are maintained by the tools themselves - keeping state needed between runs of these tools.

### Answer files

All of these tools generate upon completion an answer file, named '/var/lib/ovirt-engine/setup/answers/\*.conf', and mention that in their output.

The expected way to use these answer files is:

1.  Have a system A in some state S0
2.  Run one of the tools interactively, answer its questions as needed, let it create an answer file Ans1.
3.  System A is now in state S1.
4.  Have some other system B in state S0, that you want to bring to state S1.
5.  Run there the same tool with --config-append=Ans1

"S0" in this sense includes basically everything relevant - versions of relevant packages, enabled repos, history (such as previous runs of these tools, other data accumulated over time, etc), other manual configuration, etc.

When used this way, the tools should run unattended. If they still ask questions, it's generally considered a bug.

Manually editing such an answer file is generally not supported/expected and should not be needed. You might do that to achieve special non-standard goals. If you do that, you should thoroughly verify that it works for you, and use in a controlled environment - same known initial state, same versions of relevant stuff, etc.

Just as an example for a simple and useful violation, if during testing you often run engine-setup on systems with little RAM, and want to get rid of the question if you want to continue with not enough RAM, you can create a file e.g. /etc/ovirt-engine-setup.conf.d/99-my-stuff.conf with content:

      [environment:default]
      OVESETUP_SYSTEM/memCheckEnabled=bool:False

### Postinstall file

The postinstall file, ```/etc/ovirt-engine-setup.conf.d/20-setup-ovirt-post.conf```, seems like an answerfile, and has exactly the same syntax and semantics, but is very different: It serves as the place where engine-setup saves its internal data, the things it needs to remember for the next time it is ran, usually for upgrades. These generally include things like whether some feature/component is enabled.

In principle, it should never be touched manually, by any means other than running engine-setup itself.

### Otopi Environment
As mentioned above, engine-setup is mainly a set of plugins for [Otopi](/develop/developer-guide/engine/otopi.html).
Both postinstall (if exists) and answerfile (if provided) are simply used to set values in Otopi's environment.

Postinstall is always written in the end of a successful run, and is read, if exists, on start of run.

Answerfiles are written too, a unique one per each run, and are only read if provided using --config-append.

How does engine-setup decide what env keys/values to write to postinstall/answerfile? There are several "constants" files (not real constants, because python does not have any, but we treat them that way), and the ones that need to be written to postinstall/answerfile are actually functions with special decorators that mark this, for example:
```
@util.export
@util.codegen
@osetupattrsclass
class CoreEnv(object):
...
    @osetupattrs(
        postinstallfile=True,
    )
    def GENERATED_BY_VERSION(self):
        return 'OVESETUP_CORE/generatedByVersion'
```

So, in this example, GENERATED_BY_VERSION is a "constant", that has a value `'OVESETUP_CORE/generatedByVersion'`, and is marked to be written to the postinstall file.

### How does engine-setup decides what to do

(TODO perhaps write something more broad about engine-setup's internals. Current text is written mainly so that I can refer to it when reviewing setup code).

1. Each env var, especially ones stored in postinstall/answerfile, should have a very well-defined meaning. In particular, the following are two different meanings, and if both are needed, we need two vars:

    1. A var that indicates that a user wants some feature. Such a var should be set right when we know that the user wants it - either because we asked, or because it was provided in an answerfile. It should be saved in the generated answerfile, and different plugins may want to look it up to check if the user wants this feature. To do that, the event that sets it should have a name=, and other events should be after=(that name). It should _not_ be saved to the postinstall file.

    2. A var that indicates that some feature was enabled/configured/created/installed/etc. Such a var should be set only when that feature was actually handled, usually during STAGE_MISC (not customization). It MAY be saved in postinstall (see below), but _not_ in answerfile. Similarly, of other plugins want to do something after the feature was made available, the event that did that should have a name=, and the other plugins should run after it.

2. How to decide if to handle a feature

    1. Some features are harmless to enable every time. Check for example [ovirt-engine-setup/ovirt-engine/config/protocols.py](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=packaging/setup/plugins/ovirt-engine-setup/ovirt-engine/config/protocols.py;h=6b7a93ae7568bbd9b272800187e756ea47fcaabf;hb=HEAD). We always write out OVIRT_ENGINE_SERVICE_CONFIG_PROTOCOLS=`10-setup-protocols.conf` - in principle this is harmless, in practice this is optimized-out by otopi (it does not write the file if it already has the contents we want to write there).

    2. Others we do not want to enable/handle twice, but can check "internally" if they already are. "internally" meaning that we can check the feature itself and see if it's handled already or not. Example: We do not want to create the database if it exists. So we have code [ovirt-engine-common/ovirt-engine/db/connection.py](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=packaging/setup/plugins/ovirt-engine-common/ovirt-engine/db/connection.py;h=0d4668e5966076c3f5ff210e2328ed72a0603ada;hb=HEAD) to set NEW_DATABASE to False if it exists, and code [ovirt-engine-setup/ovirt-engine/provisioning/postgres.py](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=packaging/setup/plugins/ovirt-engine-setup/ovirt-engine/provisioning/postgres.py;h=6bb891dfd15b230e40751e5e25bf7b90f88cbcba;hb=HEAD) that creates the database, which checks if NEW_DATABASE is set, before it even asks the user.

    3. Yet others we do not want to enable/handle twice, and also can't (or don't want to, or simply didn't think about this) check internally. For these, we use vars of style (1.2.) above. An example is ApacheEnv.CONFIGURED, set in [ovirt-engine-setup/ovirt-engine-common/apache/misc.py](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=packaging/setup/plugins/ovirt-engine-setup/ovirt-engine-common/apache/misc.py;h=c43680e8a50839389ee75b77e8c131ba19ae85ae;hb=HEAD), used by [ovirt-engine-setup/ovirt-engine-common/apache/ssl.py](https://gerrit.ovirt.org/gitweb?p=ovirt-engine.git;a=blob;f=packaging/setup/plugins/ovirt-engine-setup/ovirt-engine-common/apache/ssl.py;h=de37bc2482ef107254f09f80ea5114d75da8a639;hb=HEAD).

### Secret Knobs

Some env vars are like "Secret buttons", that were not designed to be used easily, thus not asked about nor can be controlled with command line options or similar. This is usually because when adding them, we either considered them risky to change, yet wanted to have the option, or we simply expected almost no-one to need to change them, and didn't want to bother users with even more questions.

These are usually not tested routinely, and officially are unsupported and should not be set. They are usually documented in the relevant bugzilla bug for which they were added, or at least in the message of the git commit that added them. And of course, this is Open Source, you can always read the code and see what they do!

Some examples:

- Vars to control the size of database dumps taken by engine-setup to allow rollback (not to be confused with engine-backup) and the speed of backup/restore. These were added for [bug #1188132](https://bugzilla.redhat.com/show_bug.cgi?id=1188132), some details are in the commit message (https://gerrit.ovirt.org/39190).

- A variable to allow ignoring checks of PostgreSQL configuration options, might be useful if using a remote database and you have your own opinion about how some of them should be set. Added for [bug #1573091](https://bugzilla.redhat.com/show_bug.cgi?id=1573091), see [comment 6](https://bugzilla.redhat.com/show_bug.cgi?id=1573091#c6) there for details.
