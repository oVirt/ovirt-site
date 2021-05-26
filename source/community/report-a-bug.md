---
title: Reporting a bug
category: community
authors:
  - dneary
  - sandrobonazzola
---

# Reporting a Bug in oVirt

For reporting bugs, the oVirt project uses the Bugzilla bugtracker and testing tool.

For reporting security issues please follow the [security reporting procedure](/community/security.html).

## How to create a Bugzilla account

If you don’t have a Redhat Bugzilla account, you can easily create one by following these steps:

1. Visit the [Create a new account](https://bugzilla.redhat.com/createaccount.cgi) page on Bugzilla.
2. Enter a a valid email address and click **Send.**
3. You’ll receive a verification email from bugzilla@redhat.com. Click the link in the email (or copy it into your web browser).
4. Now enter your name and password and click **Create**.<br>
Congratulations! You now have a Bugzilla account and you can report bugs found in oVirt.

## How to enter a bug in Bugzilla

Here is how to report a bug found in oVirt:

1. From [Redhat Bugzilla - Main Page](https://bugzilla.redhat.com/), click the [New](https://bugzilla.redhat.com/enter_bug.cgi) link.
2. On the 'pick a classification' page, select **oVirt.**
3. Now choose a product on which to enter a bug. e.g., for issues with the management application, select ‘ovirt-engine’.
4. On the next page, under Show Advanced Fields, choose a Component. Unsure? Simply enter your best guess.
5. In the Version box, enter the project version.
6. Select the oVirt Team. If you are unsure, you can leave it set to `---`
7. In the Summary field, enter a short description of the problem. e.g., "Cannot connect to virtual machines using Console."
8. In the Description field, we recommend that you follow the provided template.
<br>All other fields can be left at their default value.
9. Finally, click the **Submit Bug** button, and you’re done!

Thank you for submitting a bug report! A developer will review your submission, and if more information is needed, we'll send you an email to the email address you provided.

If information provided within the bug description are insufficient or you don't know where to look for getting more details,
it may help proactively attach a [sos report](https://github.com/sosreport/sos/wiki) or
an [oVirt Log Collector report](/documentation/administration_guide/#sect-The_Log_Collector_Tool)
to your report.
