---
title: Creating and configuring mailing lists
category: infra
authors: djorm, quaid, wikisysop
---

# Creating and configuring mailing lists

This standard operating procedure (SOP) describes how to create and configure a Mailman mailing list on lists.ovirt.org.

## Create the list

1.  Run `sudo /usr/lib/mailman/bin/newlist $listname` to create a new list.
    -   Fill out details as requested by Mailman, noting the password.
        -   There appears to be a length of 12 characters for admin passwords in Mailman 2

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
*   Set *respond_to_post_requests* to *No*.

#### Configuration for -devel (discussion) list:

*   Archives public
*   Subscription confirmation-only
*   Set *respond_to_post_requests* to *No*.

#### Configuration for a -private list

*   Archives set to private
*   Subscription requires approval
*   Must display in list-of-lists - it's private but not kept a secret
*   For private discussion lists, posts require approval if not from a list member
    -   You may want to set *respond_to_post_requests* to *No* unless you specifically want posters to know they are held for moderation.

#### Configuration for a no-archives -private list

This is a rare configuration, usually reserved for security-related issues.

*   Archives disabled and set to private
*   Subscription requires approval
*   Must display in list-of-lists - it's private but not kept a secret
*   For private discussion lists, posts require approval if not from a list member

#### Configuration for an open-sender list

*   Set *Privacy* > *Sender* > *accept_these_nonmembers* to `^.*` - i.e., a regular expression meaning "every possible incoming email address."
*   Set *General* > *respond_to_post_requests* to *No*.

#### Configuration for an announcement mailing list

*   *Privacy* > *Sender* set 'default_member_moderation' to 'Yes'
*   *Privacy* > *Sender* set 'member_moderation_action' to 'Reject' and put in text in 'member_moderation_notice' that explains it is an announcement only list and gives at least one contact email address for questions and comments.
    -   Set up the same thing for 'generic_nonmember_action' and 'nonmember_rejection_notice'.
*   *General* set 'max_message_size' to 150KB or more to allow for images and such in announcements.

#### Configuration for closing a list permanently

If you need to close a mailing list, either to direct to a new location or because it is no longer needed, take these steps to hide the list (if needed) and notify senders of what to do. (You may also want to unsubscribe all members, if that is appropriate.)

*   <http://lists.ovirt.org/mailman/admin/LISTNAME/members> - bottom of this page set everyone's moderation bit. (There is also an emergency moderation bit on the general page, but that is an overriding setting rather than setting all current users to moderated - probably functionally the same, but I'm not sure what is better.)
*   <http://lists.ovirt.org/mailman/admin/LISTNAME/general> - set 'description' and 'info' to point to new URL, with brief text saying the list is closed.
*   <http://lists.ovirt.org/mailman/admin/LISTNAME/privacy/sender> - in the top section for "Member filters", set 'default_member_moderation' to 'Yes', set 'member_moderation_action' to 'Reject', and then put in some text in 'member_moderation_notice' that points people at the new mailing list. Set up the same thing for 'generic_nonmember_action' and 'nonmember_rejection_notice'.
*   <http://lists.ovirt.org/mailman/admin/LISTINFO/privacy/subscribing> - set 'advertized' to 'No', set 'subscribe_policy' to 'Require approval', and set 'private_roster' to 'List admin only'.

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation/) [Category:Infrastructure SOP](/develop/infra/infrastructure-sop/) [Category:Mailing lists](Category:Mailing lists)
