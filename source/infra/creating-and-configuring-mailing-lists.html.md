---
title: Creating and configuring mailing lists
category: infra
authors: djorm, quaid, wikisysop
wiki_category: Infrastructure documentation
wiki_title: Creating and configuring mailing lists
wiki_revision_count: 15
wiki_last_updated: 2013-06-25
---

# Creating and configuring mailing lists

This standard operating procedure (SOP) describes how to create and configure a Mailman mailing list on lists.ovirt.org.

## Create the list

1.  Run `sudo /usr/lib/mailman/bin/newlist $listname` to create a new list.
    -   Fill out details as requested by Mailman, noting the password.

2.  Add the sections Mailman outputs to */etc/aliases* for each mailing list, then run `sudo newaliases`.
3.  Add the list administrator password to the file */root/passwords*.
4.  Email the list owner(s) with the list password.
    -   Do this before or after configuring the list, making sure to inform them of the special configuration details.

## Configure the list

1.  Use the administrator password to log in to the admin web interface.
2.  Add additional administrators, if applicable.
3.  Configure the list as per the [#Individual list-type configurations](#Individual_list-type_configurations) section.

### Individual list-type configurations

#### Configuration for -commits list

*   Set *max_message_size* to 0
*   Set *accept_these_nonmembers* ???

#### Configuration for a -patches list

*   Set *max_message_size* to 4000
*   Set *private_roster* to *List members*

#### Configuration for -devel (discussion) list:

*   Archives public
*   Subscription confirmation-only

#### Configuration for a -private list

*   Archives set to private
*   Subscription requires approval
*   Must display in list-of-lists - it's private but not kept a secret
*   For private discussion lists, posts require approval if not from a list member

#### Configuration for a no-archives -private list

This is a rare configuration, usually reserved for security-related issues.

*   Archives disabled and set to private
*   Subscription requires approval
*   Must display in list-of-lists - it's private but not kept a secret
*   For private discussion lists, posts require approval if not from a list member

#### Configuration for an open-sender list

*   Set *accept_these_nonmembers* to `^.*` - i.e., a regular expression meaning "every possible incoming email address."

[Category:Infrastructure documentation](Category:Infrastructure documentation) [Category:Infrastructure SOP](Category:Infrastructure SOP)
