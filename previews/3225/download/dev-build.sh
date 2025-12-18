#!/bin/sh

# This bash script is referenced by oVirt Blog post from
# Martin Sivak at https://blogs.ovirt.org/2016/11/testing-ovirt-engine-changes-without-a-real-cluster/

if [ $# -lt 1 ]; then
  echo "You must provide dev env prefix"
  exit 1
fi

ROOT=$HOME/Applications/ovirt-engine-prefix
export ENGINE_DB=$1
DEVENV=$1
CLEAN=0
CLEANBUILDFLAG=
CREATE=0
CONFIG=0
shift

if [ \! -d "$ROOT/$DEVENV" ]; then
  CREATE=1
fi

if [ $# -gt 0 -a "x$1" == "x--clean" ]; then
  CLEAN=1
  shift
fi

if [ $# -gt 0 -a "x$1" == "x--config" ]; then
  CONFIG=1
  shift
fi

if [ $CLEAN -gt 0 ]; then
  echo "Cleaning the DB.."
  sudo -i -u postgres psql -c "drop database $ENGINE_DB;"
  CREATE=1
  CLEANBUILDFLAG="clean"
fi

if [ $CREATE -gt 0 ]; then
  echo "Creating new DB..."
  sudo -i -u postgres psql -c "create database $ENGINE_DB owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8'" || exit 1
  CONFIG=1
fi

make $CLEANBUILDFLAG install-dev PREFIX="$ROOT/$DEVENV" "$@" || exit 1
echo "When asked about database use the following:"
echo " User: engine"
echo " Password: engine"
echo " Database name: $ENGINE_DB"
echo

SETUP_CONFIG="$ROOT/$DEVENV/answers.conf"

cat >$SETUP_CONFIG <<EOF
# action=setup
[environment:default]
OVESETUP_DIALOG/confirmSettings=bool:True
OVESETUP_CONFIG/applicationMode=str:both
OVESETUP_CONFIG/remoteEngineSetupStyle=none:None
OVESETUP_CONFIG/sanWipeAfterDelete=bool:False
OVESETUP_CONFIG/storageIsLocal=bool:False
OVESETUP_CONFIG/firewallManager=none:None
OVESETUP_CONFIG/remoteEngineHostRootPassword=none:None
OVESETUP_CONFIG/firewallChangesReview=none:None
OVESETUP_CONFIG/updateFirewall=none:None
OVESETUP_CONFIG/remoteEngineHostSshPort=none:None
OVESETUP_CONFIG/fqdn=str:localhost
OVESETUP_CONFIG/storageType=none:None
OSETUP_RPMDISTRO/requireRollback=none:None
OSETUP_RPMDISTRO/enableUpgrade=none:None
OVESETUP_CONFIG/dockerDaemon=none:None
OVESETUP_CONFIG/dockercTag=str:kilo
OVESETUP_CONFIG/glanceCDeploy=none:None
OVESETUP_CONFIG/cinderCDeploy=none:None
OVESETUP_DB/secured=bool:False
OVESETUP_DB/host=str:localhost
OVESETUP_DB/user=str:engine
OVESETUP_DB/password=str:engine
OVESETUP_DB/dumper=str:pg_custom
OVESETUP_DB/database=str:$ENGINE_DB
OVESETUP_DB/fixDbViolations=none:None
OVESETUP_DB/port=int:5432
OVESETUP_DB/filter=none:None
OVESETUP_DB/restoreJobs=int:2
OVESETUP_DB/securedHostValidation=bool:False
OVESETUP_ENGINE_CORE/enable=bool:True
OVESETUP_CORE/engineStop=none:None
OVESETUP_SYSTEM/memCheckEnabled=bool:True
OVESETUP_SYSTEM/nfsConfigEnabled=none:None
OVESETUP_PKI/organization=str:Test
OVESETUP_PKI/renew=none:None
OVESETUP_CONFIG/isoDomainName=none:None
OVESETUP_CONFIG/engineHeapMax=str:3894M
OVESETUP_CONFIG/adminPassword=str:letmein
OVESETUP_CONFIG/isoDomainACL=none:None
OVESETUP_CONFIG/isoDomainMountPoint=none:None
OVESETUP_CONFIG/engineDbBackupDir=str:$ROOT/$DEVENV/var/lib/ovirt-engine/backups
OVESETUP_CONFIG/engineHeapMin=str:3894M
OVESETUP_AIO/configure=none:None
OVESETUP_AIO/storageDomainName=none:None
OVESETUP_AIO/storageDomainDir=none:None
OVESETUP_PROVISIONING/postgresProvisioningEnabled=none:None
OVESETUP_APACHE/configureRootRedirection=none:None
OVESETUP_APACHE/configureSsl=none:None
EOF

$ROOT/$DEVENV/bin/engine-setup --config-append=$SETUP_CONFIG || exit 1

if [ $CONFIG -gt 0 ]; then
  echo "Disabling SSL and host deploy..."
  sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' WHERE option_name = 'SSLEnabled';" || exit 1
  sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' WHERE option_name = 'EncryptHostCommunication';" || exit 1
  sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' where option_name = 'InstallVds'" || exit 1
  sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'false' where option_name = 'HystrixMonitoringEnabled'" || echo "[WARN] Hystrix not available"
  sudo -i -u postgres psql $ENGINE_DB -c "UPDATE vdc_options set option_value = 'true' where option_name = 'UseHostNameIdentifier'" || echo "[WARN] JSON-RPC might not be able to differentiate between fake hosts"
fi

$ROOT/$DEVENV/share/ovirt-engine/services/ovirt-engine/ovirt-engine.py start

