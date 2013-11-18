---
title: LDAP Quick Start
authors: alonbl, jhernand, moolit
wiki_title: LDAP Quick Start
wiki_revision_count: 5
wiki_last_updated: 2014-12-07
---

# LDAP Quick Start

Ovirt manager uses external directory services for user authentication and information. When a directory server is attached to the manger (using engine-manage-domain), existing users from it can be added as ovirt users and assigned different roles and permissions.

The purpose of this page is

1.  Provide quick installation instructions of a simple a LDAP stack.
2.  Explain the basic concepts of LDAP with ovirt-engine context in mind.

This installation instructions provided here are for fedora 19.

### Installation instructions

# at the beginning of the command stands for execution as root.

#### Installing OpenLDAP

Note that these instructions assume that you are using Fedora 19 and that the name of your domain is `f19.example.com`. If you are using a different domain make sure to use as well a different LDAP suffix instead of `dc=f19,dc=example,dc=com`. For example, if you are using `mycompany.com` as your domain then you should use `dc=mycompany,dc=com` for the LDAP suffix.

These are the steps required to install OpenLDAP and Kerberos so that the engine will be able to use them for authentication:

1.  Install OpenLDAP server & client, start the OpenLDAP service and optionally set it to run on init:
        # yum install -y openldap-{clients,servers}
        # yum -y install cyrus-sasl-gssapi
        # systemctl start slapd
        # systemctl enable slapd

2.  Add the cosine and inetorgperson schemas:
        # ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/cosine.ldif
        # ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/inetorgperson.ldif

3.  `Add the ``memberof`` overlay:`
        # cat > memberof.ldif <<'.'
        dn: cn={0}module,cn=config
        objectClass: olcModuleList
        cn: {0}module
        olcModulePath: /usr/lib64/openldap
        olcModuleLoad: {0}memberof.la

        dn: olcOverlay={0}memberof,olcDatabase={2}hdb,cn=config
        objectClass: olcConfig
        objectClass: olcMemberOf
        objectClass: olcOverlayConfig
        objectClass: top
        olcOverlay: {0}memberof
        .
        # ldapadd -H ldapi:/// -Y EXTERNAL -f memberof.ldif

    This overlay is an OpenLDAP plugin that manages automatically the set of members of a group. so when you add a member to a group it will automatically add the group to the list of groups of that member. You can also do this task manually, and other directory servers may do this in a different way.

4.  Create a password for the directory administrator (I used `example123`, make sure to use an stronger password):
        # slappasswd 
        New password: 
        Re-enter new password: 
        {SSHA}m0QjuHcKXOZwoL8H7LhZgQgj/+gjGje4

5.  Change the suffix and the credentians of the directory manager:
        # cat > config.ldif <<'.'
        dn: cn=config
        replace: olcSaslSecProps
        olcSaslSecProps: noanonymous,noplain,minssf=1
        -

        dn: olcDatabase={2}hdb,cn=config
        changetype: modify
        replace: olcSuffix
        olcSuffix: dc=f19,dc=example,dc=com
        -
        replace: olcRootDN
        olcRootDN: cn=Manager,dc=f19,dc=example,dc=com
        -
        replace: olcRootPW
        olcRootPW: {SSHA}0EAIzAxRBMZ1LP/XAhq4q80DLpNpDzr2
        -
        .
        # ldapmodify -H ldapi:/// -Y EXTERNAL -f config.ldif

    Note that the `olcSaslSecProps` is very important in order to avoid a bug in the Java virtual machine. It should contain at least `minssf=1`.

6.  Create the top level structure of the directory, with a branch for users and another for groups:
        # cat > structure.ldif <<'.'
        dn: dc=f19,dc=example,dc=com
        objectClass: dcObject
        objectClass: organization
        dc: f19
        o: F19 Example Inc.

        dn: ou=Users,dc=f19,dc=example,dc=com
        objectClass: organizationalUnit
        ou: Users

        dn: ou=Groups,dc=f19,dc=example,dc=com
        objectClass: organizationalUnit
        ou: Groups
        .
        # ldapadd -H ldapi:/// -D 'cn=Manager,dc=f19,dc=example,dc=com' -x -W -f structure.ldif

</li>
<li>
Create some users:

    # cat > users.ldif <<'.'
    dn: uid=user0,ou=Users,dc=f19,dc=example,dc=com
    objectclass: inetOrgPerson
    objectclass: uidObject
    uid: user0
    cn: User2
    givenName: User
    title: User
    mail: user0@f19.example.com
    sn: 0

    dn: uid=user1,ou=Users,dc=f19,dc=example,dc=com
    objectclass: inetOrgPerson
    objectclass: uidObject
    uid: user1
    cn: User1
    givenName: User
    title: User
    mail: user1@f19.example.com
    sn: 1
    .
    # ldapadd -H ldapi:/// -D 'cn=Manager,dc=f19,dc=example,dc=com' -x -W -f users.ldif

Note that the users don't need to have a `memberof` attribute, as this will be calculated and assigned by the `memberof` overlay when the group is created or modified.

</li>
<li>
Create some groups:

    # cat > groups.ldif <<'.'
    dn: cn=Group0,ou=Groups,dc=f19,dc=example,dc=com
    objectclass: groupOfNames
    cn: Group0
    member: uid=user0,ou=Users,dc=f19,dc=example,dc=com
    member: uid=user1,ou=Users,dc=f19,dc=example,dc=com
    .
    # ldapadd -H ldapi:/// -D 'cn=Manager,dc=f19,dc=example,dc=com' -x -W -f groups.ldif

</li>
Once this is done the directory should return the memberOf attributes when quering users:

    # ldapsearch -H ldapi:/// -b 'dc=f19,dc=example,dc=com' -x '(uid=user0)' memberOf -LLL
    dn: uid=user0,ou=Users,dc=f19,dc=example,dc=com
    memberOf: cn=Group0,ou=Groups,dc=f19,dc=example,dc=com

</li>
<li>
Install the Kerberos server packages:

    # yum -y install krb5-{workstation,server}

</li>
<li>
Adjust the `/etc/krb5.conf` file, should be something like this:

    [logging]
     default = FILE:/var/log/krb5libs.log
     kdc = FILE:/var/log/krb5kdc.log
     admin_server = FILE:/var/log/kadmind.log

    [libdefaults]
     dns_lookup_realm = false
     ticket_lifetime = 24h
     renew_lifetime = 7d
     forwardable = true
     default_realm = F19.EXAMPLE.COM

    [realms]
     F19.EXAMPLE.COM = {
      kdc = f19.example.com
      admin_server = f19.example.com
     }

    [domain_realm]
     .f19.example.com = F19.EXAMPLE.COM
     f19.example.com = F19.EXAMPLE.COM

</li>
<li>
Create the kerberos database:

    # cd /var/kerberos/krb5kdc
    # kdb5_util create -s

Modify the `/var/kerberos/krb5kdc/kdc.conf` and `/var/kerberos/krb5kdc/kadm5.acl` and replace `EXAMPLE.COM` with your realm name.

</li>
<li>
Create the a Kerberos admin user, for root, for example:

    # kadmin.local
    Authenticating as principal root/admin@F19.EXAMPLE.COM with password.
    kadmin.local:  add_principal root/admin
    WARNING: no policy specified for root/admin@F19.EXAMPLE.COM; defaulting to no policy
    Enter password for principal "root/admin@F19.EXAMPLE.COM":
    Re-enter password for principal "root/admin@F19.EXAMPLE.COM":
    Principal "root/admin@F19.EXAMPLE.COM" created.

</li>
<li>
Start and enable the `krb5kdc` and `kadmin` services:

    # systemctl start krb5kdc
    # systemctl enable krb5kdc
    # systemctl start kadmin
    # systemctl enable kadmin

</li>
<li>
Check that you can login with the admin user:

    # kadmin
    Authenticating as principal root/admin@F19.EXAMPLE.COM with password.
    Password for root/admin@F19.EXAMPLE.COM:
    kadmin:  list_principals
    K/M@F19.EXAMPLE.COM
    kadmin/admin@F19.EXAMPLE.COM

</li>
<li>
Add the users to the Kerberos database and verify that they can login:

    # kadmin
    kadmin: add_principal user0
    kadmin: add_principal user1

    # kinit user0
    Password for user0@F19.EXAMPLE.COM:

</li>
<li>
Create a password for the LDAP server and extract it to a keytab file with read permissions for the user running the LDAP server (usually the `ldap` user):

    # kadmin
    kadmin:  add_principal -randkey ldap/f19.example.com
    kadmin:  ktadd -keytab /etc/openldap/ldap.keytab ldap/f19.example.com

    # chgrp ldap /etc/openldap/ldap.keytab
    # chmod 640 /etc/openldap/ldap.keytab

</li>
<li>
Make sure that the LDAP server is using the keytab file created in the previous step, adding the `KRB5_KTNAME` to the `/etc/sysconfig/slapd` file (it is already there, just uncomment it):

    KRB5_KTNAME="FILE:/etc/openldap/ldap.keytab"

Then restart the LDAP server:

    # systemctl restart slapd

</li>
<li>
Test that users can do LDAP queries using the Kerberos credentials:

    # kinit user0
    # Password for user0@F19.EXAMPLE.COM:

    # ldapsearch -H ldap://f19.example.com -Y GSSAPI -b 'dc=f19,dc=example,dc=com' '(uid=user0)' memberOf

The query should succeed without asking any password.

</li>
<li>
Add DNS SRV records for the LDAP and Kerberos servers, something like this in the zone file:

    _kerberos._tcp.f19.example.com. SRV 0 100 88 f19.example.com.
    _ldap._tcp.f19.example.com. SRV 0 100 389 f19.example.com.

</li>
<li>
Register the domain with `engine-manage-domains`:

    # engine-manage-domains -action=add -domain=f19.example.com -provider=OpenLDAP -user=user0 -interactive

</li>
</ol>
