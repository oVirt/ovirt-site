---
title: Cli-changelog
authors: michael pasternak
wiki_title: Cli-changelog
wiki_revision_count: 17
wiki_last_updated: 2013-11-14
---

# Cli-changelog

         * Wed Oct  9 2013 Michael Pasternak `<mpastern@redhat.com>` - 3.3.0.5-1
         - incorrect property to python built-in symbol encapsulation #1015975
         - make ctrl-c breaking the command rather than existing shell #869269
         - unclear error message when logging into cli with bad formatted url #960876
         - update power management agent type via CLI failed #1005751
         - fix session_timeout help #1005749

         * Tue Jul  16 2013 Michael Pasternak `<mpastern@redhat.com>` - 3.3.0.3-1
         - refactor "connect" command help
         - remove support for --password option #983713
         - add option to define auto connect #918908
         - "exit" command fails after "disconnect" from script #971285
         - list permits format better error when not enough parameters #962472
         - ovirt-shell should contain the hostname of the system #866319
         - certificate file keys are not exposed in .ovirtshellrc #960983
         - add brick operation fails from ovirt-shell #923169

         * Wed May  1 2013 Michael Pasternak `<mpastern@redhat.com>` - 3.3.0.2-1
         - datetime.datetime object has no attribute __dict__ #957519
         - remove pexpect dependency
         - Ping command success message need to be rephrased #918749
         - spicec does not pass cert_file #953582
         - Error in "update network --cluster-identifier --usages-usage" #950993
         - List/Show suggests parent+child as single param #950398
         - Error type "brick" does not exist." on replace brick #923196
         - Implement Session-TTL header support #928314
         - unclear error message when using unsupported 2 levels attribute #949642
         - correlation_id is not attached to update command #950441
         - connect --help will log the user out of the disconnected cli #890340
         - "help add" fails to format the error when number of provided args in incorrect #922018

         * Tue Apr  2 2013 Michael Pasternak `<mpastern@redhat.com>` - 3.3.0.1-1
         - at vm.start() --vm-os-boot doesn't send the order of devices #921464
         - rephrase status command help
         - add option to retrieve system summary #854369
         - accept IP address as FQ argument rather than string #886067
         - fix broken pipe
         - Bad error message when trying to create a new Role #908284
         - add flag --dont-validate-cert-chain #915231
         - collection-based-options could be passed in 2 ways #859684
         - make NO_SUCH_ACTION error a bit more clear
         - ovirt-cli DistributionNotFound exception on f18 #881011
         - ovirt-shell misleading help for command "connect" #907943
         - show event -id accept strings instead of numeric values #886786
         - Use vncviewer passwordFile instead of passwdInput
         * Sun Jan  13 2013 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.9-1
         - ovirt-cli DistributionNotFound exception on f18 #881011
         - adding to help message ovirt-shell configuration details #890800
         - wrong error when passing empty collection based option #890525
         - wrong error when passing empty kwargs #891080

         * Sun Dec  30 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.8-1
         - typo in help update manual #890368
         - "remove permit" doesnt work by-id #887805
         - wrong response for suspend VM #886944
         - auto complete suggests --from_event_id while it shouldnt #886792
         - negative numbers wrapped as strings #880216
         - missing acknowledgement for remove commands #886941
         - update prompt status upon "Connection failure" #880559
         - Wrong name of section in .ovirtshell causes to traceback #880641

         * Sun Nov  18 2012 Michael Pasternak `<mpastern@redhat.com>` - 3.2.0.7-1
         - disable output redirection via config #866853
         - CTRL+C signal while password prompt appears causes cli to fall #868647
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
