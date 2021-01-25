---
title: Engine config examples
authors: amuller, dougsland, omachace, tscofield
---

# Engine config examples

## Actions

      # engine-config -h
      engine-config: get/set/list configuration
      USAGE:
          engine-config ACTION [--cver=version] [-p | --properties=/path/to/alternate/property/file] [-c | --config=/path/to/alternate/config/file]
      Where:
          ACTION              action to perform, see details below
          version             relevant configuration version to use.
          -p, --properties=   (optional) use the given alternate properties file.
          -c, --config=       (optional) use the given alternate configuration file.

          Available actions:
          -l, --list
              list available configuration keys.
          -a, --all
              get all available configuration values.
          -g key, --get=key [--cver=version]
              get the value of the given key for the given version. If a version is not given, the values of all existing versions are returned.
          -s key=val --cver=version, --set key=val --cver=version
              set the value of the given key for the given version. The cver version is mandatory for this action.
          -h, --help
              display this help and exit.

      ### Note: In order for your change(s) to take effect,
      ### restart the JBoss service (using: 'service jboss-as restart').
      #############################################################################

## Changing admin user password

      # ovirt-aaa-jdbc-tool user password-reset admin 

For oVirt 3.5, oVirt 3.4 and oVirt 3.3

      # engine-config -s AdminPassword=superNewPassword
      # service jboss-as restart 

For oVirt 3.2 or later

      # engine-config -s AdminPassword=interactive
      # service ovirt-engine restart 

## Adding VM custom properties (macspoof)

      # engine-config -s "UserDefinedVMProperties=macspoof=(true|false)"
      # service ovirt-engine restart 

In order to deactivate mac spoof filtering on a VM:

1.  Bring down the VM
2.  edit the VM
3.  Click advanced
4.  Custom properties
5.  Add a key
6.  Select macspoof
7.  Type true as the value
8.  Start the VM

## MacPoolRanges

MacPoolRanges provide a pool of MAC addresses to be used by all of the datacenters managed by the ovirt engine. Of course, in a LAN this doesn't make much difference as the possibility of MAC "hijack" from a hardware vendor is extremely low. The 3 first bytes in a MAC specify the vendor ID, and the 3 last bytes the "card" address (explained in <http://en.wikipedia.org/wiki/MAC_address>). If you run into the **Not enough MAC addresses left in MAC Address Pool.** error, you will need to expand this pool. If you are running multiple ovirt-engines or other virtualization platforms on the same network you may need to update this setting

Also please notice you can have multiple ranges separated by comma

      # engine-config -s "MacPoolRanges=00:1A:4A:97:5E:00-00:1A:4A:97:5E:FF,00:1A:4A:97:5F:00-00:1A:4A:97:5F:FF"
      # service ovirt-engine restart

## MaxMacsCountInPool

Limits the MAC pool size so if you have a pool that is too big the engine won't start. So for example if you have pools 00:1A:4A:97:5E:00-00:1A:4A:97:5E:FF,00:1A:4A:97:5F:00-00:1A:4A:97:5F:FF it's OK since there are 256 + 256 = 512 < 100000 MACs But, if you have pools 00:1A:4A:00:00:00-00:1A:4A:00:FF:FF,00:1A:4A:01:00:00-00:1A:4A:01:FF:FF it will fail since there are 65536 + 65536 = 131072 > 100000 MACs
