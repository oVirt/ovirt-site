---
title: Postgresql changing db pass
authors: oernii
---

# Postgresql changing db pass

## How to change the DB password for local postgresql database 'engine'

1.  1.  make a backup

2.  read PASSWD
3.  /etc/pki/ovirt-engine/encryptpasswd.sh $PASSWD
4.  unset PASSWD
5.  1.  copy the encrypted password and uptate the file */etc/sysconfig/ovirt-engine* with the encrypted password

6.  update the clear-text password in the file */etc/ovirt-engine/.pgpass*
7.  su - postgres
8.  postgres=# alter user engine with password 'NEW_CLEAR_TEXT_PASS';
9.  postgres=# alter user postgres with password 'NEW_CLEAR_TEXT_PASS';
10. service ovirt-engine restart

Everything should work as before.
