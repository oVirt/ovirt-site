---
title: Engine config examples
authors: amuller, dougsland, tscofield
wiki_title: Engine config examples
wiki_revision_count: 12
wiki_last_updated: 2013-11-08
---

# Engine config examples

## Actions

      # engine-config -h
      engine-config: get/set/list configuration
      USAGE:
          engine-config ACTION [--cver=version] [-p | --properties=/path/to/alternate/property/file] [-c | --config=/path/to/alternate/config/file]
      Where:
          ACTION              action to perform, see details below
          version             relevant configuration version to use.
          -p, --properties=   (optional) use the given alternate properties file.
          -c, --config=       (optional) use the given alternate configuration file.

          Available actions:
          -l, --list
              list available configuration keys.
          -a, --all
              get all available configuration values.
          -g key, --get=key [--cver=version]
              get the value of the given key for the given version. If a version is not given, the values of all existing versions are returned.
          -s key=val --cver=version, --set key=val --cver=version
              set the value of the given key for the given version. The cver version is mandatory for this action.
          -h, --help
              display this help and exit.

      ### Note: In order for your change(s) to take effect,
      ### restart the JBoss service (using: 'service jboss-as restart').
      #############################################################################

## Changing admin user password

      # engine-config -s AdminPassword=superNewPassword
      # service jboss-as restart 

For Ovirt 3.2 or later

      # engine-config -s AdminPassword=interactive
      # service ovirt-engine restart 

## Adding VM custom properties (macspoof)

      # engine-config -s "UserDefinedVMProperties=macspoof=(True|False)"
      # service ovirt-engine restart 

Then edit the VM, click advanced, go to custom properties, add a key - Select macspoof, select True as the value and restart the VM.
