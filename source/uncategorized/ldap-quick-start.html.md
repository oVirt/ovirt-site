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

## Installation instructions

#> at the beginning of the command stands for execution as root.

#### Installing OpenLDAP

LDAP ( Lightweight Directory Access Protocol ) is a protocol for setting and getting distributed directory information. In ovirt context, users and groups are provided by external servers (currently support AD, IPA, RHDS and openldap)

1.) Install openldap server & client, start the openldap service and optionally set it to run on init

      #> yum install -y openldap-servers openldap-clients
      #> systemctl start slapd
      #> systemctl enable slapd

The contents of LDAP Entries are governed by a *directory schema* the schema defines what attributes an entry has, how attributes comprised and searched and more

2.) add the schema representing a user ( and the base LDAPv3 schema ) to the LDAP server.

      #> ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/cosine.ldif
      #> ldapadd -H ldapi:/// -Y EXTERNAL -f /etc/openldap/schema/inetorgperson.ldif
       

ldif files are standard plain text representation of LDAP directory content ( LDAP schema included ) and operations.

now define the memberof attribute:

      #>cat > memberof.ldif <<'.'
      dn: cn={0}module,cn=config
      objectClass: olc Module List
      cn: {0}module
      olc Module Path: /usr/lib64/openldap
      olc Module Load: {0}memberof.la

      dn: olcOverlay={0}memberof,olcDatabase={2}hdb,cn=config
      objectClass: olcConfig
      objectClass: olc Member Of
      objectClass: olc Overlay Config
      objectClass: top
      olcOverlay: {0}memberof
      .
      #> ldapadd -H ldapi:/// -Y EXTERNAL -f memberof.ldif
       

3.) Create a password for the directory administrator:

1.  > slappasswd

New password: Re-enter new password: {SSHA}DZgCnj/1ZmLt0zprung+V/Fu8BDGiCVc

7. Create the top level structure of the directory, with a branch for users and another for groups:
