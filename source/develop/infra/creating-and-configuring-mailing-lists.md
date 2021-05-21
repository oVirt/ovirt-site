---
title: Creating and configuring mailing lists
category: infra
authors:
  - djorm
  - quaid
---

# Creating and configuring mailing lists

This standard operating procedure (SOP) describes how to create and configure a Mailman mailing list on *lists.ovirt.org*.

To create a new list or modify lists configuration, since Mailman 3 you can do everything using [the administration interface](https://lists.ovirt.org/admin/lists/).

## Mailman 3 administrative interface shortcomings

* It is not yet possible to [define a custom rejection notice](https://gitlab.com/mailman/postorius/issues/17); the following configurations would then use a generic notice.

* There is also [a bug with the 'Acceptable aliases' field](https://gitlab.com/mailman/postorius/issues/58) preventing from saving the settings; if the list of aliases is empty you can simply empty the field before saving.

* It is [not possible to add non-members](https://gitlab.com/mailman/postorius/issues/265); instead subscribe the sender and in *Members* > *Subscribers* > sender's *Member Options* set *Delivery status* to 'Disabled'.

## Individual list-type configurations

These settings have been adapted to Mailman 3; they may require some adjustment. Please update this page if you find more appropriate settings.

### Configuration for -commits list

* in *Settings* > *Message acceptance* set *Maximum message size* to 0
* the sender address should be added to non-members and allowed to post; because of a bug this is not possible, use the alternative method listed in chapter [Mailman 3 administratice interface shortcomings](#mailman-3-administrative-interface-shortcomings)
* in *Message acceptance*, set *Default action to take when a non-member posts to the list* to 'Discard (no notification)'
* in *Subscription Policy* set to 'Confirm then Moderate'

### Configuration for a -patches list

* in *Settings* > *Message acceptance* set *Maximum message size* to 4000
* on the same page, set *Default action to take when a non-member posts to the list* to 'Discard (no notification)'
* in *Subscription Policy* set to 'Confirm then Moderate'

### Configuration for -devel (discussion) list:

* in *Settings* > *Subscription Policy* set to 'Confirm'
* in *Message acceptance*, set *Default action to take when a non-member posts to the list* to 'Hold for moderation'

### Configuration for a -private list

* in *Settings* > *Subscription Policy* set to 'Confirm then Moderate'
* in *Message acceptance*, set *Default action to take when a non-member posts to the list* to 'Discard (no notification)'
* in *Archiving* set *Archive policy* to 'Private archives'
* in *List Identity* keep *Show list on index page* to 'Yes', it's private but not kept a secret

### Configuration for a no-archives -private list

This is a rare configuration, usually reserved for security-related issues. Same settings as a -private list except for:

* in *Archiving* set *Archive policy* to 'Do not archive this list'

### Configuration for an open-sender list

This should be avoided for SPAM reasons.

* in *Message acceptance*, set *Default action to take when a non-member posts to the list* to 'Accept immediately (bypass other rules)'

### Configuration for an announcement mailing list

* in *Settings* > *Subscription Policy* set to 'Confirm'
* in *Message acceptance*, set *Default action to take when a non-member posts to the list* to 'Reject (with notification)', and insert a text explaining it is an announcement only list and gives at least one contact email address for questions and comments
* on the same page, set *Default action to take when a member posts to the list* to 'Hold for moderation'
* in *Message acceptance*, you may restrict the *Maximum message size* (be careful to allow for images and such in announcements, ~300kb should be fine for most usage)

### Configuration for closing a list permanently

If you need to close a mailing list, either to direct to a new location or because it is no longer needed, take these steps to hide the list (if needed) and notify senders of what to do. (You may also want to unsubscribe all members, if that is appropriate.)

* in *Settings* > *List Identity* > *Show list on index page* set to 'No'
* on the same page, update the *Description* and *Information* fields accordingly
* in *Subscription Policy* set to 'Confirm then Moderate'
* in *Message Acceptance* set both 'Default action to take…' settings to 'Reject (with notification)' and insert a text explaining the situation

[Category:Infrastructure documentation](/develop/infra/infrastructure-documentation.html) [Category:Infrastructure SOP](/develop/infra/infrastructure-sop.html)
