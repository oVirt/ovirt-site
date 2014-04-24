---
title: AAA JDBC
category: feature
authors: alonbl, moolit
wiki_category: Feature
wiki_title: Features/AAA JDBC
wiki_revision_count: 17
wiki_last_updated: 2015-04-11
---

# AAA JDBC Provider

### Data model

*   Settings
    -   Database
        -   Datasource - one of data source or jdbc url
        -   JDBC url
        -   User
        -   Password
    -   Account
        -   Max login time.
        -   Message of the day, default none
        -   Present welcome message.
        -   Authz user conversion regular expression, default (.\*)
    -   Brute force
        -   1.  of seconds for each response - response should be no less than this value preferably no more, default 5.
        -   max # of login per minute

    -   Account Lock
        -   Max failed attempts since last success, default: 5
        -   Max failed attempt since last X hours, default 20
        -   X of Failed counter X hours, default 24
        -   Lock duration in minutes - 0 infinite, default 60.
    -   Account Password
        -   Hash function, default sha256
        -   Password expiration notice in days, 0 to disable, default 0.
        -   Password expiration in days, default 90.
        -   Restrict unique password for N last passwords, default 3.
        -   Support password self reset, default no.
        -   Password complexity
            -   Minimum length, default 6.
            -   1.  of numbers (-1 not important), default -1.
            -   1.  of upper letters (-1 not important), default -1.
            -   1.  of lower letters (-1 not important), default -1.
            -   1.  of signs (-1 not important), default -1.
*   Dictionary for password strength
    -   Words
*   Each user:
    -   User id (guid)
    -   Password encoded as base64(random1(8 bytes)||hash(random1, userid, password))
    -   Last passwords, added each time password change, do not allow setting to password already in this list.
    -   Password valid to date
    -   Password self reset - password
    -   Password self reset - password expiration
    -   validFrom date
    -   validTo date
    -   Login time - 48 char string for each 30 minutes of the day 0 - not permitted, 1 - permitted.
    -   Flags
        -   disabled
        -   no password
    -   Unlock time
    -   Last successful login time
    -   Failed login count since last success
    -   Failed login count since last X hours
    -   Attributes
        -   Login name
        -   Email
        -   Display name
        -   Description
        -   X.500 name (used for X.509 authentication)
    -   Groups ids
    -   Challenge question / answers.
*   Each group:
    -   Group id (guid)
    -   Attributes
        -   Name
        -   Display name
        -   Description
        -   Group ids

### Authn

Notes:

*   Before any other check password is checked so return code will never change if password is invalid.
    -   if self reset password is available it should be considered as well one time and reset if invalid.
    -   self reset password is reset after successful logon.
*   Response should be delayed at least per "# of seconds for each response".
*   On password reset, challenge for at least one challenge which can be email at worse case.
*   Construct welcome message: Last success login, last failed login, # of failed login since last success.
*   Handle the lock logic.

### Authz

No notes.

### Command-line interface

Output should be easy to parse.

      ovirt-aaa-jdbc-tool
          user
`       `<command>
                  add
                  modify
                  delete
                  unlock
                  password-reset
                  show
`       `<user-name>
             --password=type:string, default: no password
                 pass - string is password
                 env - string is environment
                 file - string is file
                 interactive - acquire from console
             --passwordValidTo=`<date>`, default now()
             --accountValidFrom=`<date>`, default now()
             --accountValidTo=`<date>`, default infinite
             --accountLoginTime=48 length string, default 1**48
`       --attribute=`<name>`=`<value>
                 displayName
                 email
                 description
                 ...
              --flags=[+|-]`<flags>`, default none
                 disabled
                 no password
         group
`       `<command>
                 add
                 delete
                 show
`       `<group-name>
`       --attribute=`<name>`=`<value>
                 displayName
                 description
         group-manage
`       `<command>
                 useradd
                 userdel
                 groupadd
                 groupdel
                 show
`       `<group-name>
             --group=
             --user=
         query
             --what=
                 user
                 group
             --regexp=attribute=regexp
             --regexp=attribute=regexp
         settings
`       `<command>
                 show
                 set
             --attribute=, default all for show
             --value=
         dictionary
`       `<command>
                 import
                 export
             --file=csv

<Category:Feature> <Category:Security>
