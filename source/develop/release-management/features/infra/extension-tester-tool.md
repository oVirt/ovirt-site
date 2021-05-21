---
title: Extension tester tool
category: feature
authors: omachace
---

# Extension tester tool

Extension tester tool serves to user to be able test his configuration of his oVirt extensions. Tool provides command line interface to send specific commands to these extensions. We currently support logger and aaa extension, but there will be more in future.

### Command-line interface

    ovirt-engine-extensions-tool
      --extension-file=[STRING]  Extension file to be used.
      --extensions-dir=[STRING]  Path to directory of extensions.
      --help  Show test tool help.
      --log-file=[STRING]  File where log will be stored.
      --log-level=[STRING]  Log level of test tool.
      --version  Show version of test tool.

## AAA module

This modules provides basic functionality to test your aaa extensions. You can search within your extension, login test sequence and other.

### Command-line interface

    aaa
      login-user
        --help
          Show help for login-user action.

        --password=[PASSWORD]
          Password can be specified in one of the following format:
            interactive: - query password interactively [default].
            pass:STRING - provide a password as STRING.
            env:KEY - provide a password using environment KEY.
            file:FILE - provide a password as 1st line of FILE.

        --profile=[STRING]
          Name of profile to perform login with

        --user-name=[STRING]
          User name to login with

      search
        --authz-flag=[FLAG]
          Authz flags to be used, can be specified multiple times.
          Valid values: resolve-groups-recursive|resolve-groups

        --entity=[ENTITY]
          Type of entity to search for
          Valid values: principal|group, default: principal.

        --entity-id=[STRING]
          Entity id to search.

        --entity-name=[STRING]
          Entity name to search, can be followed by '*' as wildcard, default: *.

        --extension-name=[STRING]
          Name of extension to perform search with

        --help
          Show help for search action.

        --namespace=[STRING]
          Namespace to search within, see extension context for available namespaces, default: all.
          Can be specified multiple times.

        --page-size=[STRING]
          Page size, default: 100

      authz-fetch_principal_record:
        --authz-flag=[FLAG]
          Authz flags to be used, can be specified multiple times.
          Valid values: resolve-groups-recursive|resolve-groups

        --extension-name=[STRING]
          Extension name to be used for fetch of principal

        --help
          Show help for authz action.

        --principal-name=[STRING]
          Principal name to fetch

      authn-authenticate_credentials

        --extension-name=[STRING]
          Extension name to be used for authenticate

        --help
          Show help for authn action.

        --password=[PASSWORD]
          Password can be specified in one of the following format:
            interactive: - query password interactively [default].
            pass:STRING - provide a password as STRING.
            env:KEY - provide a password using environment KEY.
            file:FILE - provide a password as 1st line of FILE.

        --user-name=[STRING]
          User name to authenticate with

### Examples

Search example:

      ovirt-engine-extensions-tool aaa search --extension-name=my_ldap --user-name=user

Login example:

      ovirt-engine-extensions-tool aaa login-user --profile=my_ldap --user-name=user

## Logger module

Logger module provides functionality to setup specific logging of oVirt. You can find more information [here](https://gerrit.ovirt.org/gitweb?p=ovirt-engine-extension-logger-log4j).

### Command-line interface

    logger 
      --help  Show help for logger module.
      log-record
          --extension-name=[STRING]  Name of logger extension.
          --help  Show help for log-record action.
          --level=[STRING]  Level of log message to be sent.
          --logger-name=[STRING]  Name of logger.
          --message=[STRING]  Message which should be sent to logger.

### Example

This example log message with text 'test' at level 'INFO' using logger name 'test-logger'. It fill find extension named 'ovirt-logger' in directory <i>/etc/ovirt-engine/extensions.d</i>

    ovirt-engine-extensions-tool logger log-record --extension-name=ovirt-logger --message=test --logger-name=test-logger --level=INFO

## Info module

This module provides basic command to check your extensions configuration.

### Command-line interface

    info
      context
        --extension-name=[STRING]
          Name of extension.

        --format=[STRING]
          Format to use, place holders: {key}, {value}, {name}, default: {name}: {value}.

        --help
          Show help for context action.

        --key=[STRING]
          Key to output, default all, can be specified multiple times.

      configuration
        --extension-name=[STRING]
          Name of extension.

        --format=[STRING]
          Format to use, place holders: {key}, {value}, default: {key}: {value}.

        --help
          Show help for configuration action.

        --key=[STRING]
          Key to output, default all, can be specified multiple times.

      list-extensions
        --help
          Show help for list-extensions action.

### Example

List extensions example:

    ovirt-engine-extensions-tool info list-extensions


