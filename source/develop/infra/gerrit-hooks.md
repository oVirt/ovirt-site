---
title: Gerrit hooks
category: infra
authors: dcaroest, eedri
---

# Gerrit hooks

**Overview of the Gerrit Hooks**

WIP

## Source Code

The source code is hosted in the [gerrit-admin](http://gerrit.ovirt.org/gitweb?p=gerrit-admin.git;a=shortlog;h=HEAD) gerrit project, inside the hooks directory. There you'll find a lib directory, that contains helper bash scripts and python modules used by the hooks. The custom_hooks directory, containing all the available hooks, and the hook-dispatcher file, that is the controller for the hooks execution.

## Flow

All the hooks execution starts on the hook-dispatcher, that's the script that will be called by gerrit itself when an event happens (you can control which events are handled by adding/removing links on *$GERRIT_DIR/hooks* directory to this script).

The hook-dispatcher then detects which type of event was triggered by, and by which project, and from the project's source directory (usually *$GERRIT_SOURCE/$project.git*) will look for a hooks directory and run all the hooks that match the event, that is, all the hooks that start with $event_name (see the event types below). They are ordered in alphanumeric order.

The hooks are run in chains, to know more about it, check the chaining section below. Right now we just need to know that a hook can succeed, fail silently, or break the execution completely.

Each hook will be passed the same parameters that gerrit used to invoke the hook-dispatcher script. And each hook will be required to reply in a specific format (see the hook output section). From that output a Code REview (**CR**) value, and a Verified (**VR**) value will be extracted, along with a comment.

From all the hooks, a **CR** and a **VR** value will be calculated, this is done taking the lowest value that was explicitly specified. A hook can avoid influencing the vote by no passing any **CR** or **VR** value.

After that, all the messages will be aggregated (if the hook did not specify any message, a simple informative one will be generated for it) and the global review will be sent to gerrit.

### Hook Output Format

Each hook output must fit a specific format, defined below (please, check the in-code documentation for the current format, as this wiki might be outdated).

      code_review_value
      verified_value
      multiline_message

The first two lines are optional, you can leave them blank or delete them, if only one suitable voting value passed it will be assumed to be the code review value. Some examples:

      +1
      +1
      This is a simple
      multiline message

This output will generate a **CR** of **+1**, a **VR** of **+1**, and everything else will be interpreted as message. If for example the next hook would return:

      0
      Second hook message

Then the CR punctuation will be flatted to 0, the VR value will be kept intact and the message for this hook will be appended to the global message. And if the last one would be this:

      Third hook 
      ouput message

Then neither of the review values will be changed and only the output message will be appended.

### Chaining

You can create chains, chains are sets of hooks that run in a predefined sequentially flow, and any of them can break the chain to abort that flow and keep with the next chain.

Chains are defined as the second point-separated string in the hooks name, for example if you have the hooks:

      patchset-created.chain1.1.first_hook
      patchset-created.chain1.2.second_hook
      patchset-created.independent_hook
      patchset-created.independent_hook_2

Here we can see that we have 3 chains, *chain1*, *independent_hook* and *independent_hook_2*, if, for example, *patchset-created.chain1.1.first_hook* would return something different than **0** as it's return code, *patchset-created.chain1.2.second_hook* would not be even executed and it will jump to *patchset-created.independent_hook*.

Flow execution is controlled with the return codes of each hook execution, if the hook exited with a return code different than **0**, the chain will be considered as broken and will jump to the next. The breakage of the chain does not imply that the review value must be negative, just that the execution was stopped, the **CR** and **VR** values will be extrapolated from the output of the hooks that were actually executed.

### Event types

There is a limited set of events that gerrit will be able to trigger a hook by, you should take a look on gerrit documentation for all of them, but as the writing of this document, the most important ones are:

*   patchset-created: Run when a new patchset is sent to gerrit
*   change-merged: Run where a patchset is merged into the branch.
*   comment-added: Run when a new comment is sent to any patchset.
*   change-abandoned: Run when a changeset is abandoned.

You must note that all those hooks are run **AFTER** the even has taken place.

### Troubleshooting

If you find yourself stuck with a need to skip a bad hook (for e.g sometimes we don't need to submit to major branch and only z-stream), you can just rerun a working hook by adding comment:

*   Rerun-Hooks: patchset-created.bz.0.has_bug_url

This will remove the -Verified any other hook provided.

## Installation

The hooks are actually manually installed, so I'll explain how is set up right now (it might change in the near future).

### Base Direcotry

Under */home/gerrit2/review_site/hooks* you'll find a copy of the *hooks* folder that's in the source code repository. And also some soft-links (explained under Hook Dispatcher section) and a custom 'config' file.

### Hook Dispatcher

For gerrit to find the hook-dispatcher script, there are some soft-links under the base directory with the name of the default hooks that gerrit will execute, you can just delete or create more if you want to the hook-dispatcher to handle those events or not.

### Custom Hooks

Each custom hook that is written, is placed under $GERRIT_BASE/hooks/custom_hooks, and linked from each source repository that should run them, for example, if we wanted the hook 'patchset-created.myhook' to be run for the ovirt-engine project, we will create a link from $GERRIT_SRC/ovirt-engine.git/hooks/patchset-created.myhook to $GERRIT_BASE/hooks/custom_hooks/patchset-created.myhook, you can modify the links names to create chains or reorder the hooks.

## Configuration

All the hooks can be configured using configuration files, there's some hierarchy and inheritance that I'll explain below. Each configuration file is just a shell script where you declare bash variables, but if you want to be able to use those variables in the python scripts hooks, you'll have to make sure that they do not spawn more than one line, no bash ararays are used and no extra variable expansion is done in the value (that might be improved soon, but there's have been no need yet).

### Global Configuration File

There's a global configuration file that will be used by all the hooks, no matter what. That configuration file is located under $GERRIT_BASE/hooks/config.

### Per Project Configuration File

Each project can have it's own configuration file too, it must be located at $GERRIT_SRC/$project.git/hooks/config, and it will overwrite any value that was declared in the cglobal configuration file.

## Libraries

To ease the development of the hooks and avoid code duplication, some bash and python libraries are provided adding the $GERRIT_BASE/hooks/lib directory to poth the PATH and PYTHONPATH enviroment variables of the hooks when executing them.

**NOTE**: For the latest docs, look the code, this wiki is not yet automatically updated, so it might be outdated.

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html)
