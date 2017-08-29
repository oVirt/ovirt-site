---
title: First Release Blockers
authors: danken, lpeer, mburns, mkublin, ofrenkel, oschreib, ovedo
---

<!-- TODO: Content review -->

# First Release (3.0) Known blockers

| Component          | Description                                                       | Bugzilla                                                     | Status   | Notes                                           |
|--------------------|-------------------------------------------------------------------|--------------------------------------------------------------|----------|-------------------------------------------------|
 | Installer        | NFS ISO domain couldn't be attached                               | [782439](https://bugzilla.redhat.com/show_bug.cgi?id=782439) | Fixed    | Merged into engine_3.0                         |
 | Engine+Installer | LDAP authenticities against domain URI instead of LDAP Server URI | [783127](https://bugzilla.redhat.com/show_bug.cgi?id=783127) | Fixed    | Merged into engine_3.0                         |
 | Installer        | openssl lock file doesn't exist                                   | [771590](https://bugzilla.redhat.com/show_bug.cgi?id=771590) | Fixed    | Merged into engine_3.0                         |
| Engine           | IPA - IPA does not perform login with UPN                         | [783662](https://bugzilla.redhat.com/show_bug.cgi?id=783662) | Fixed    | Merged into engine_3.0                         |
| Engine           | User already logged in error                                      | [784810](https://bugzilla.redhat.com/show_bug.cgi?id=784810) | Fixed    | Merged into engine_3.0                         |
| Node             | Installation Error                                                | [785728](https://bugzilla.redhat.com/show_bug.cgi?id=785728) | Deferred | Not a blocker                                   |
| VDSM             | spice problems with tls                                           | [773371](https://bugzilla.redhat.com/show_bug.cgi?id=773371) | Fixed    | vdsm-4.9.3.3                                    |
| engine           | Nodes cannot be registered                                        | [782663](https://bugzilla.redhat.com/show_bug.cgi?id=782663) | Fixed    | Merged into engine_3.0                         |
| engine           | Engine locking issue                                              | [785671](https://bugzilla.redhat.com/show_bug.cgi?id=785671) | Fixed    | Merged into engine_3.0                         |
| VDSM/iscsid      | iscsid service fails to start                                     | [786174](https://bugzilla.redhat.com/show_bug.cgi?id=786174) | Fixed    | iscsi-initiator-utils-6.2.0.872-16.fc16.x86_64 |
| Enter            | Your                                                              | [XXXX](https://bugzilla.redhat.com/show_bug.cgi?id=XXXX)     | BUG      | HERE                                            |
