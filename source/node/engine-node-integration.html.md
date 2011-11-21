---
title: Engine Node Integration
category: node
authors: doron, dougsland, fsimonce, roy
wiki_title: Engine Node Integration
wiki_revision_count: 42
wiki_last_updated: 2012-02-21
---

# Engine Node Integration

Ovirt and VDSM on Fedora

This is a work in progress for making Ovirt engine and ovirt node/regular host run on Fedora

engine installation:

1.The engine core was built on fedora 14 but all stages applies for later versions as well.

The engine was built from sources and installed via maven on a pre-installed jboss 5.1.0-GA server. Follow these steps(link the installation process from the wiki).

compile pubkey2ssh

      cd backend/manager/3rd
      gcc -o pubkey2ssh pubkey2ssh.c -lcrypto

• create engine dirs

      sudo mkdir -p /var/lock/engine /usr/share/engine/backend/manager/conf/

• put vds_installer.py in place

      cp backend/manager/conf/vds_installer.py

• create /etc/pki/engine

      mkdir -p /etc/pki/engine

• create CA and certs

      cd backend/manager/conf/ca 
      ` ./installCA_dev.sh `pwd` /etc/pki/engine `

• db updates:

      psql engine postgres  -c "update vdc_options set option_value = '/etc/pki/engine/ca/certs/engine.cer' where option_name = 'CertificateFileName';"
      psql engine postgres  -c "update vdc_options set option_value = '/etc/pki/engine/ca/.keystore' where option_name = 'TruststoreUrl';"
      psql engine postgres  -c "update vdc_options set option_value = '/etc/pki/engine//ca/' where option_name = 'CABaseDirectory';"
      psql engine postgres -c "update vdc_options set option_value = 'ca.pem' where option_name  = 'CACertificatePath';"
      psql engine postgres  -c "update vdc_options set option_value = '/etc/pki/engine//ca/.keystore' where option_name = 'keystoreUrl';"
      psql engine postgres  -c "update vdc_options set option_value = '/etc/pki/engine//ca/private/ca.pem' where option_name = 'CAEngineKey';"

• copy cert to Jboss root dir

      cp /etc/pki/engine//ca/keys/engine.ssh.key.txt /usr/loca/jboss/server/default/deploy/ROOT.war/
