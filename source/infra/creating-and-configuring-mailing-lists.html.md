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

1.  Run 'sudo /usr/lib/mailman/bin/newlist $listname' to create a new list.
    -   Fill out details as requested by Mailman, noting the password.

2.  Add the sections Mailman outputs to '/etc/aliases' for each mailing list, then run 'sudo newaliases'.
3.  Add the list administrator password to the file '/root/passwords'.
4.  Email the list owner(s) with the list password.
    -   Do this before or after configuring the list, making sure to inform them of the special configuration details.

## Configure the list

1.  

### Individual list-type configurations

Configuration for -commits list:

*   Set max_message_size to 0
*   Set accept_these_nonmembers ???

Configuration for -devel (discussion) list:

*   Archives public
*   Subscription confirmation-only

Configuration for a -private list:

*   Archives private
*   Subscription requires permission
*   Must display in list-of-lists - it's private but not kept a secret

[Category:Infrastructure docs](Category:Infrastructure docs) [Category:Infrastructure SOP](Category:Infrastructure SOP) <Category:Infrastructure> [Category:How to](Category:How to)
