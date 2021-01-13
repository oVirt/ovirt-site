---
title: Sonar with oVirt
authors: lhornyak sandrobonazzola
---


# Sonar with oVirt

## Where is Sonar

A public Sonar instance is here: <https://sonarcloud.io>

oVirt Engine is monitored there at: <https://sonarcloud.io/dashboard?id=org.ovirt.engine%3Aroot>


## Running sonar on oVirt

[Sonar](https://www.sonarqube.org/) is a very nice code analisys webapp. It does static code analysys with checkstyle, findbugs, pmd, cpd (and a number of other plugins) and test coverage report.

Sonar usually does not need any special configuration, you only have to run 'mvn sonar:sonar' and it just works.

## Special problems in oVirt

*   first, some of the gwt modules just does not compile the usual way. I have just removed these modules from the analisys.
*   another project where the compilation fails is ovirt-checkstyle-extension, again, removed from check
*   probably because of the huge code size, tests need a huge maxpermsize. Also forkMode=always is needed to ensure that each test gets a new JVM. This makes it slow, but otherwise it won't work.
*   oVirt upstream and downstream has the same groupid, artifactid and version, sonar can't tolerate this. It will just overwrite the project. (so does maven)
*   sometimes the dependencies break inside and no one notices. It is best to remove ovirt from the local repository before building.

## A build script
```bash
      #!/bin/bash
      . $HOME/.bashrc
      #remove the wrong artifacts from the local maven repo
      #in order to check if dependencies are not broken
      rm ~/.m2/repository/org/ovirt -rf
      cd ~$HOME/ovirt-engine
      git pull
      #install everything again
      mvn clean install -DskipTests=true;
      #and then run the checks
      mvn clean compile sonar:sonar -P enable-dao-tests -e -Dsonar.skippedModules=sharedgwt-deployment,gwt-extension,ovirt-checkstyle-extension -DargLine="-Xmx3g -XX:MaxPermSize=2048M" -DtestFailureIgnore=true -DforkMode=always #-Dtest=*Test.java
```
