---
title: LDAP Quick Start
authors: alonbl, jhernand, moolit
wiki_title: LDAP Quick Start
wiki_revision_count: 5
wiki_last_updated: 2014-12-07
---

# LDAP Quick Start

The purpose of this page is

1.  Provide quick installation instructions of a simple a LDAP stack.
2.  Explain the basic concepts of LDAP with ovirt-engine context in mind.

### Installation outline & prerequisite

This installation instructions are under fedora 19 LDAP ( Lightweight Directory Access Protocol ) is a protocol setting and getting distributed directory information. In ovirt context, we use an external provider (currently support AD, IPA, RHDS and openldap)

### Installation instructions

      #> at the beginning of the command stands for execution as root.
      $> at the beginning of the command stands for execution as user.

#### Installing OpenLDAP

Install openldap server & client, start the openldap service and optionally set it to run on init #> yum install -y openldap-servers openldap-clients #> systemctl start slapd #> systemctl enable slapd
