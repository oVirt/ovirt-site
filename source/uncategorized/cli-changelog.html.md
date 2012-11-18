---
title: Cli-changelog
authors: michael pasternak
wiki_title: Cli-changelog
wiki_revision_count: 17
wiki_last_updated: 2013-11-14
---

# Cli-changelog

         * Sun Nov  18 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.7-1
         - disable output redirection via config #866853
         - CTRL+C signal while password prompt appears causes to cli to fall #868647
         - adapt to sdk #853947 fix

         * Thu Nov  1 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.6-1
         - adapt to sdk restriction of .get() to id/name

         * Mon Sep  24 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.5-1
         - storagedomain option appears in all vm actions #856164
         - disallow specifying app internal options

         * Thu Sep  20 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.4-1
         - add the kitchen build/runtime require

         * Thu Sep  20 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.3-1
         - valid UUIDs are treated as syntax error #854391
         - change collection based arguments syntax help #854506
         - rename "create" command with "add" #855773
         - remove --show-all option from /show command #855749
         - Raise an error if identifier is not specified in /show command #855750
         - Rename /delete command with /remove #855769
         - valid UUIDs are treated as syntax error #854391
         - history command does not support pipe redirection #854486
         - do not log /connect command in history
         - disable /history while not  connected
         - add username/password prompt/conf-file functionality

         * Sun Sep  9 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.1-1
         - do not load/save example_config. file
         - subcollection are not shown #854047
         - change NoCertificatesError message to ask only for ca_file
         - implement /filter flag
         - do not write to file i/o during script execution
         - shell does not exit when using /exit/ command in script

         * Tue Jul 21 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.8-1
         - implement insecure flag #848046
         - implement server identity check
         - collection-based-options definition doesnt look like cli format #833788
         - support utf-8 encoding

         * Sun Jul 15 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.6-1
         - support python 2.6 version format

         * Sun Jul 15 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.5-1
         - refactor /status/ command
         - do not force credentials check on sdk > 3.1.0.4
         - implement /info/ command
         - implement generic parameters processing for /list/ command

         * Mon Jul 9 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.4-1
         - use host-subject (certificate) to validate host identity during spice initiation
         - implement syntax error
         - recognize RequestError as command failure
         - do not sort command options in /help/ commands

         * Mon Jun 25 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.3-1
         - expend nested types as parameters overloads
         - refactor /help/ to support parameters overload
         - do not clear screen on sys.error
         - refactor auto-completion to support 3+ deep collections/resources
         - cli does not support 3+ deep collections/resources #827845

         * Thu Jun 7 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.2-1alpha
         - Implement history browsing mechanism #823512, new capabilities:
             - persistent history stack
             - recursive history search - ctrl+r
             - history listing - history
             - history slide retrieval - history N
         - Implement pipe redirection to linux shell #823508
         - exit on incorrect option
         - miss-type in "help list" command #803399

         * Wed May 16 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.1.0.1-1alpha
         - add basic scripting capabilities
         - Support multiline input #815684
         - Version format refactoring to align with oVirt version schema 
         - Alpha release

         * Thu May 10 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.6-1
         - Remove pregenerated parsing tables
         - Allow quoting of strings with single or double quotes
         - Don't add -s option to spicec when SSL is disabled (#812299)

         * Wed Mar 28 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.5-1
         - use OrderedDict instead of papyon odict
         - get rid of papyon dep.

         * Wed Mar 21 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.4-1
         - no auto completion for connect command #803312

         * Wed Mar 14 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.3-1
         - remove codegen.doc.documentation import

         * Tue Mar 13 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.2-1
         - do not consider empty string as a command (see 2.1.1-1 changes for 2.1.X rpm diffs)

         * Tue Mar 13 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.1.1-1
         - do not expose commands other than /connect,help,exit/ when disconnected
         - a user can use Status option as action while it doesnt exist #800047
         - cli: console command not function #800052
         - support auto-completion on /update/ command
         - implement collection based parameters support
         - support parameters_set overloads in help
         - implement support for multi-argument methods in sdk
         - call sys.exit() on Ctrl+C signal

         * Wed Feb 15 2012 Michael Pasternak `<mpastern@redhat.com>` - 2.0-1
         - New application core
         - Added support for commands history stack
         - Added support for context aware auto-competition
         - Dynamic ovirt-engine-sdk meatdata discovering
         - Removed restriction for specific version of ovirt-engine-sdk
           from 1.5 and further ovirt-engine-cli can work with any
           version of sdk (unless sdk introduced cli incompatible change)
         - same naming convention in ovirt-engine-cli and ovirt-engine-sdk
         - reformatted output to support reduced and expended modes in
           list in show commands by --show-all argument 
         - object fields formatting
         - added support for linux shell commands redirection
         - shell output redirection support
         - added SSL arguments to connect command
         - added ovirt-engine-api version discovering mechanism

         * Thu Jan 19 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.2-1
         - unable to add host #782734
`     `[`https://bugzilla.redhat.com/show_bug.cgi?id=782734`](https://bugzilla.redhat.com/show_bug.cgi?id=782734)
         - unable to add new cluster #782707
`     `[`https://bugzilla.redhat.com/show_bug.cgi?id=782707`](https://bugzilla.redhat.com/show_bug.cgi?id=782707)

         * Mon Jan 16 2012 Michael Pasternak `<mpastern@redhat.com>` - 1.1-1
         - unable to create data-center: problem with --version param #781834
`     `[`https://bugzilla.redhat.com/show_bug.cgi?id=781834`](https://bugzilla.redhat.com/show_bug.cgi?id=781834)
         - authentication show as succeeded with bad password (text only) #781820
`     `[`https://bugzilla.redhat.com/show_bug.cgi?id=781820`](https://bugzilla.redhat.com/show_bug.cgi?id=781820)
