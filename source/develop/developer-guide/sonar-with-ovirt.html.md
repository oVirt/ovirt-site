---
title: Sonar with ovirt
authors: lhornyak
---

<!-- TODO: Content review -->

# Sonar with ovirt

## Where is sonar

A public sonar instance is here: <http://sonar.dictat.org/>

This instance is running on openshift, it's database is periodically updated from an internal sonar installation (http://sonar.rhev.lab.eng.brq.redhat.com/)

## Running sonar on ovirt

[Sonar](http://sonarsource.org/) is a very nice code analisys webapp. It does static code analysys with checkstyle, findbugs, pmd, cpd (and a number of other plugins) and test coverage report.

Sonar usually does not need any special configuration, you only have to run 'mvn sonar:sonar' and it just works.

## Special problems in ovirt

*   first, some of the gwt modules just does not compile the usual way. I have just removed these modules from the analisys.
*   another project where the compilation fails is ovirt-checkstyle-extension, again, removed from check
*   Probably because of the huge code size, tests need a huge maxpermsize. Also forkMode=always is needed to ensure that each test gets a new JVM. This makes it slow, but otherwise it won't work.
*   ovirt upstream and downstream has the same groupid, artifactid and version, sonar can't tolerate this. It will just overwrite the project. (so does maven)
*   sometimes the dependencies break inside and no one notices. It is best to remove ovirt from the local repository before building.

## A build script

      #!/bin/bash
      . $HOME/.bashrc
      #remove the wrong artifacts from the local maven repo
      #in order to check if dependencies are not broken
      rm ~/.m2/repository/org/ovirt -rf
      #modify the pom to be different groupid than rhevm
      cd ~$HOME/ovirt-engine
      ` for i in `git status -s -uno`; do git checkout $i; done `
      git pull
      ` for i in `find -name pom.xml`; do cp $i $i.orig; cat $i.orig | sed -e s/groupId.org.ovirt.engine /groupId>org.ovirt.oss.engine/ > $i; done `
      #install everything again
      mvn clean install -DskipTests=true;
      #and then run the checks
      mvn clean compile sonar:sonar -P enable-dao-tests -e -Dsonar.skippedModules=sharedgwt-deployment,gwt-extension,ovirt-checkstyle-extension -DargLine="-Xmx3g -XX:MaxPermSize=2048M" -DtestFailureIgnore=true -DforkMode=always #-Dtest=*Test.java
