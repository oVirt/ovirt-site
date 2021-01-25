---
title: Backend with jrebel
authors: lhornyak
---

# Backend with jrebel

## Running the backend with jrebel

The backend development sometimes needs a little more time than what you have, jrebel may be a solution for this.

### JRebel

[JRebel](http://zeroturnaround.com/jrebel/) is a **non-free** software that modifies the classloading behavior of the JVM and loads the classes from an alternate location. You can save the time spent on rebuilding and redeploying the whole source.

JRebel can be used for free on open source projects.

Steps:

*   request an opensource license
*   download the license and save as ~/.rebel

### modify the root pom.xml

Add this to the pom.xml

`   `<profile>
`     `<id>`jrebel`</id>
`     `<build>
`       `<plugins>
`         `<plugin>
`           `<groupId>`org.zeroturnaround`</groupId>
`           `<artifactId>`jrebel-maven-plugin`</artifactId>
`           `<executions>
`             `<execution>
`               `<id>`generate-rebel-xml`</id>
`               `<phase>`process-resources`</phase>
`               `<goals>
`                 `<goal>`generate`</goal>
`               `</goals>
`             `</execution>
`           `</executions>
`         `</plugin>
`       `</plugins>
`     `</build>
`   `</profile>

Either set it as active by default or use -Pjrebel at build time. When building, this will generate rebel.xml files to each of your jar files, they will be packaged into your jars and will be used to tell the jrebel runtime where to load classes from.

Since this modification is not welcome in the git repositories and it can easily get lost when doing the usual git magic, you can add this script to your build program. This will check if jrebel is in your pom and add it if not.

      ` JREBEL_INSTALLED=`grep jrebel pom.xml | wc -l` `
      if [ $JREBEL_INSTALLED -gt 0 ]; then
`       echo jrebel installed `\(should be ok!\)
      else
             echo jrebel not installed, installing
             cat pom.xml | sed -e "s/<\/profiles>/ `<profile>`\n`<build>`\n`<plugins>`\n`<plugin>`\n`<groupId>`org.zeroturnaround<\/groupId>\n`<artifactId>`jrebel-maven-plugin<\/artifactId>\n`<executions>`\n`<execution>`\n`<id>`generate-rebel-xml<\/id>\n`<phase>`process-resources<\/phase>\n`<goals>`\n`<goal>`generate<\/goal>\n<\/goals>\n<\/execution>\n<\/executions>\n<\/plugin>\n<\/plugins>\n<\/build>\n<\/profile>\n<\/profiles>/" > pom.hacked
             mv pom.hacked pom.xml
      fi

### JBoss

Add this to your jboss standalone.conf:

      export REBEL_HOME=/path/to/jrebel/
      JAVA_OPTS="$JAVA_OPTS -javaagent:$REBEL_HOME/jrebel.jar $JAVA_OPTS"

And start your jboss
