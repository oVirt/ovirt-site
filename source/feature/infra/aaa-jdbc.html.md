---
title: AAA JDBC
category: feature
authors: alonbl, moolit, mperina
wiki_category: Feature
wiki_title: Features/Design/AAA JDBC
wiki_revision_count: 17
wiki_last_updated: 2015-09-05
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
    -   Brute force
        -   1.  of seconds for each response - response should be no less than this value preferably no more, default 5.
        -   max # of login per minute

    -   Account Lock
        -   Enable account locking, default: yes
        -   Max failed attempts since last success, default: 5
        -   Max failed attempt since last X hours, default 20
        -   X of Failed counter X hours, default 24
        -   Lock duration in minutes - 0 infinite, default 60.
    -   Account Password
        -   PBE algorithm, iterations, keysize, default PBKDF2WithHmacSHA1, 2000, 256
        -   Password expiration notice in days, 0 to disable, default 0.
        -   Password expiration in days, default 180.
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
    -   Encoded password (PBE)
    -   Last passwords, added each time password change, do not allow setting to password already in this list.
    -   Password valid to date
    -   Password self reset - password
    -   Password self reset - password expiration
    -   validFrom date
    -   validTo date
    -   Login time - 7 week days \* 48 char string for each 30 minutes of the day 0 - not permitted, 1 - permitted.
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
                  edit
                  delete
                  unlock
                  password-reset
                  show
`       `<user-name>
             --password=type:string, default: no password
                 pass - string is password, insecure mode
                 env - string is environment
                 file - string is file
                 interactive - acquire from console
                 none - equal to --flag=noPassword
             --passwordValidTo=`<date>`, default now()
             --accountValidFrom=`<date>`, default now()
             --accountValidTo=`<date>`, default infinite
             --accountLoginTime=7 * 48 length string, default 1 ** 7 * 48
`       --attribute=`<name>`=`<value>
                 displayName
                 email
                 description
                 ...
              --flag=[+|-]`<flag>`, default none
                 disabled
                 noPassword
              --newName=`<name>`, ignored unless this is an edit command
              --id=`<int>`, ignored unless this is an add command
         group
`       `<command>
                 add
                 edit
                 delete
                 show
`       `<group-name>
`       --attribute=`<name>`=`<value>
                 displayName
                 description
             --id=`<int>`, ignored unless this is an add command
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

### PasswordStore

`<pre>
import java.nio.charset.*;
import java.security.*;
import java.util.*;
import javax.crypto.*;
import javax.crypto.spec.*;

import org.apache.commons.codec.binary.Base64;

public class PasswordStore {

    private final String algorithm;
    private final int length;
    private final int iterations;
    private final String randomProvider;

    public PasswordStore(String algorithm, int length, int iterations, String randomProvider) {
        this.algorithm = algorithm;
        this.length = length;
        this.iterations = iterations;
        this.randomProvider = randomProvider;
    }

    public static boolean check(String current, String password) throws GeneralSecurityException {
        String[] comps = current.split("\\|");
        if (comps.length != 5 || !"1".equals(comps[0])) {
            throw new IllegalArgumentException("Invalid current password");
        }
        byte[] salt = new Base64(0).decode(comps[2]);
        return Arrays.equals(
            new Base64(0).decode(comps[4]),
            SecretKeyFactory.getInstance(comps[1]).generateSecret(
                new PBEKeySpec(
                    password.toCharArray(),
                    salt,
                    Integer.parseInt(comps[3]),
                    salt.length*8
                )
            ).getEncoded()
        );
    }

    public String encode(String password) throws GeneralSecurityException {
        byte[] salt = new byte[length/8];
        SecureRandom.getInstance(randomProvider == null ? "SHA1PRNG" : randomProvider).nextBytes(salt);
        return String.format(
            "1|%s|%s|%s|%s",
            algorithm,
            new Base64(0).encodeAsString(salt),
            iterations,
            new Base64(0).encodeAsString(
                SecretKeyFactory.getInstance(algorithm).generateSecret(
                    new PBEKeySpec(
                        password.toCharArray(),
                        salt,
                        iterations,
                        salt.length*8
                    )
                ).getEncoded()
            )
        );
    }

    public static void main(String... args) throws Exception {
        for (String algo : new String[] { "PBEWithMD5AndDES", "PBEWithMD5AndTripleDES", "PBKDF2WithHmacSHA1" }) {
            PasswordStore ph = new PasswordStore(algo, 256, 2000, null);
            String p = ph.encode(args[0]);
            System.out.println(p);
            System.out.println(ph.check(p, args[0]));
        }
    }
}
</pre>`

Author: --[Alon Bar-Lev](User:Alonbl) ([talk](User talk:Alonbl)) 02:23, 1 July 2014 (GMT)

<Category:Feature> <Category:Security>
