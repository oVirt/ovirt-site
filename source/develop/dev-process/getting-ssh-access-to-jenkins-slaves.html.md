---
title: Getting ssh access to jenkins slaves
authors: eedri
---

# Getting access to ssh jenkins slaves

If you're a developer or a user that requires ssh access to jenkins slaves, in order to debug a certain job or look at logs, please follow the following procedure to request access.

## Access Request to jenkins.ovirt.org slaves

*   Send email to dcaro@redhat.com with subject: "Devel oVirt jenkins ssh account - $USERNAME", cc infra@ovirt.org
*   $USERNAME will be used as username for the slaves
*   Append you public ssh public key to the body of the email (or as attachment)
*   Add hashed password (for sudo access, as you see in /etc/shadow)
*   Specify in the email body reason for request and link to relevant job you're maintaining)
*   If you need a dedicated slave:

       - OS
       - Bare metal/vm/don't care (bare metal will only be given for tests requiring vm spawning) 

*   If you need access to all the slaves (be cautious, you can break other jobs with this) - need infra approval.
