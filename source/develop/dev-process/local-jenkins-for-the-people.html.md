---
title: Local Jenkins For The People
authors: lpeer, mkolesni, moti, msalem
---

# Local Jenkins (guide) for the people

Wherever you need to substitute a value, the notation **[]** is used, ie **[value]**.

The needed values are:

------------------------------------------------------------------------

*   **[jenkins-host]** - The host you're installing jenkins to (IP/FQDN) - i.e. your VDSM host.
*   **[git-host]** - The host where the GIT repository you work on is located (your local repo, not origin) - i.e. your lap[top.
*   **[user]** - The user you use to work on your stuff (In order to clone from your repo).
*   **[git-repo-url]** - Full URL of the git repo on the [git-host] - i.e. [ssh://[user]](ssh://[user])@[git-host]/~/git/ovirt-engine

# Install & configure Jenkins

The enclosed installation script does most of the work for you, installing Jenkins & pre-requisites, but it does not configure Jenkins for you.

You can either use the installation script or follow the steps manually, it's up to you!

## Installation script

If after running the script you get: "AWT is not properly configured on this server. Perhaps you need to run your container with "-Djava.awt.headless=true"?"

Then run:

      # yum install dejavu-sans-fonts

and then run the script again.

Download from here: <Media:jenkins.sh.gz>

Or copy this:

    #! /bin/bash
    #
    # Copyright (c) 2012 Red Hat, Inc.
    #
    # Licensed under the Apache License, Version 2.0 (the "License");
    # you may not use this file except in compliance with the License.
    # You may obtain a copy of the License at
    #
    #           http://www.apache.org/licenses/LICENSE-2.0
    #
    # Unless required by applicable law or agreed to in writing, software
    # distributed under the License is distributed on an "AS IS" BASIS,
    # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    # See the License for the specific language governing permissions and
    # limitations under the License.
    #

    usage() {
    #    echo "Usage: ${ME} [-h] -s SERVERNAME -u USERNAME [-v]"
        echo "Usage: ${ME} [-h] [-f] [-v]"
        echo ""
    #    echo "  -s SERVERNAME - The IP/FQDN for the GIT server.           (eg your machine)"
    #    echo "  -u USERNAME   - The user you are using on the GIT server. (eg your user)"
        echo "  -v            - Turn on verbosity."
        echo "  -f            - Use force (don't stop if a critical step fails)."
        echo "  -h            - This help text."
        echo ""

        exit 0
    }

    function printSuccess {
        if [ $2 = 0 ]
        then
            successStr='[SUCCESS]'
        else
            successStr='[FAILED]'
        fi

        limit=$(echo 79 - $( echo $successStr | wc -m) | bc)
        start=$(echo 1 + $(echo $1 | wc -m) | bc)

        echo -n $1' '

        for i in `seq $start $limit`;
        do
            echo -n '.'
        done

        echo ' '$successStr
    }

    function yumInstall {
        yum install $VERBOSE -y $1

        success=$?
        printSuccess "Installed $1" $success
    }

    function startService {
        chkconfig $1 on
        success=$?
        printSuccess "Enabled $1 service on start-up" $success

        if [ $success ]
        then
            service $1 start
            success=$?
            printSuccess "Started $1 service" $success
        fi
    }

    function installPlugin {
        java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 install-plugin $1
        printSuccess "Installed Jenkins $1 plugin" $?
    }

    VERBOSE='-q'
    while getopts :hfv option; do
        case $option in
    #        s) SERVERNAME=$OPTARG;;
    #        u) USERNAME=$OPTARG;;
            v) VERBOSE='';;
            f) FORCE=true;;
            h) usage;;
        esac
    done

    #if [[ "$SERVERNAME" = '' || "$USERNAME" = '' ]]
    #then
    #    echo "ERROR: One or more required parameters are missing."
    #    usage
    #fi

    echo "Installing pre-requisites:"
    echo "=========================="

    yumInstall ntp

    if !grep "10.5.26.10" /etc/ntp.conf &> /dev/null
    then
        echo "\nserver 10.5.26.10 # Added by jenkins install script.\n" >> /etc/ntp.conf
        printSuccess "Added working NTP server" $?
    fi

    yumInstall java
    yumInstall git

    if grep Fedora /etc/redhat-release &> /dev/null
    then
        yumInstall maven
    else
        rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
        wget $VERBOSE -O /etc/yum.repos.d/epel-apache-maven.repo http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo
        yumInstall apache-maven
    fi

    yumInstall postgresql-server
    yumInstall postgresql-contrib

    if [ "$(rpm -q postgresql | cut -f2 -d'-' | cut -f1 -d'.')" = "8" ]
    then
        su - postgres -c 'initdb -U postgres -D /var/lib/pgsql/data/'
    else
        su - postgres -c 'pg_ctl initdb'
    fi

    printSuccess "Initialized DB" $?

    echo ""
    echo "Installing Jenkins CI:"
    echo "======================"

    wget $VERBOSE -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo

    printSuccess 'Downloaded Jenkins repo' $?

    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

    printSuccess 'Imported Jenkins RPM key' $?

    yumInstall jenkins

    if [[ "$success" != "0" && !$FORCE ]]
    then
        echo "FATAL: Can't install Jenkins, exiting."
        exit 1
    fi

    startService jenkins

    if [[ "$success" != "0" && !$FORCE ]]
    then
        echo "FATAL: Can't start Jenkins service, exiting."
        exit 1
    fi

    #su - -s /bin/bash -c "ssh -o 'StrictHostKeyChecking no' $USERNAME@$SERVERNAME 'echo Success > /dev/null'" jenkins

    #printSuccess "Added server $SERVERNAME to known hosts list" $?

    #su - -s /bin/bash -c "if [ ! -e ~/.ssh/id_rsa.pub ]; then ssh-keygen -q -t rsa; fi && ssh-copy-id $USERNAME@$SERVERNAME" jenkins

    #printSuccess "Generated & deployed SSH public-key" $?

    echo ""
    echo "Installing Jenkins Plugins:"
    echo "==========================="

    echo "Wait 30s for jenkins to go up.."
    sleep 30s

    wget $VERBOSE -O /tmp/jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar

    printSuccess "Downloaded Jenkins CLI" $?

    wget $VERBOSE -O /tmp/jenkins-update-center.tmp http://updates.jenkins-ci.org/update-center.json

    tail -n +2 /tmp/jenkins-update-center.tmp | head -n -1 > /tmp/jenkins-update-center.json

    curl -X POST -d @/tmp/jenkins-update-center.json http://localhost:8080/updateCenter/byId/default/postBack

    printSuccess "\nInitialized Jenkins update center" $?

    installPlugin git
    installPlugin checkstyle
    installPlugin findbugs
    installPlugin build-name-setter
    installPlugin saferestart

    java -jar /tmp/jenkins-cli.jar -s http://localhost:8080 safe-restart

    printSuccess "Restarted Jenkins after plugins installed" $?

    echo "Jenkins should now be installed & working, enjoy!"

    exit 0

## Manual installation

### Prerequisites

Make sure you have ntpd installed and running, a good server to use is (in /etc/ntp.conf):

      # server 10.5.26.10

### Installing Jenkins

**Note: All steps are to be done on the machine you want jenkins installed at!**

`# ssh root@`**`[jenkins-host]`**

#### Add jenkins REPO

`# wget -O /etc/yum.repos.d/jenkins.repo `[`http://pkg.jenkins-ci.org/redhat/jenkins.repo`](http://pkg.jenkins-ci.org/redhat/jenkins.repo)
`# rpm --import `[`http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key`](http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key)

#### Install Jenkins

      # yum install jenkins

#### Start jenkins

      # service jenkins start

#### Make sure jenkins starts automatically

      # chkconfig jenkins on

### Additional installations

#### Install maven

##### On EL6 host

`# rpm -Uvh `[`http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm`](http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm)
`# wget -O /etc/yum.repos.d/epel-apache-maven.repo `[`http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo`](http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo)
      # yum install apache-maven

##### On FC16 host

      # yum install maven

#### Install git

      # yum install git

### Installing some Jenkins plugins..

#### Download jenkins CLI

`# wget `[`http://localhost:8080/jnlpJars/jenkins-cli.jar`](http://localhost:8080/jnlpJars/jenkins-cli.jar)

#### Initialize Jenkins Update Center

`# wget -O /tmp/jenkins-update-center.tmp `[`http://updates.jenkins-ci.org/update-center.json`](http://updates.jenkins-ci.org/update-center.json)
      # tail -n +2 /tmp/jenkins-update-center.tmp | head -n -1 > /tmp/jenkins-update-center.json
`# curl -X POST -d @/tmp/jenkins-update-center.json `[`http://localhost:8080/updateCenter/byId/default/postBack`](http://localhost:8080/updateCenter/byId/default/postBack)

#### Install the plugins

      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin git
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin checkstyle
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin findbugs
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin build-name-setter
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin saferestart

#### Restart jenkins

      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` safe-restart

## Configure general settings

Go to <http://>**[jenkins-host]**:8080/configure which will open jenkins system config.

Add the GIT installation, if it isn't listed.

### At the top section

Change the following fields to the specified values:

*   1.  of executors = 4
*   SCM checkout retry count = 100

### At the Maven sections

*   Add a maven installation (if none listed).
*   Uncheck 'Install automatically'
*   Name = maven
*   For EL6: MAVEN_HOME = /usr/share/apache-maven
*   For FC16: MAVEN_HOME = /usr/share/maven
*   Global MAVEN_OPTS = -Xincgc

# Configure SSH for jenkins user

This is necessary so that Jenkins can clone your local GIT repository and poll it.

## Generate SSH key for jenkins

      # su - -s /bin/bash jenkins
      $ ssh-keygen -t rsa

## Copy the public key to your user on your machine

`$ ssh-copy-id `**`[user]`**`@`**`[git-host]`**

## Check that you can SSH without password

      $ ssh `**`[user]`**`@`**`[git-host]`**` "echo 'Hello world'"
      Hello world

# Add the jobs

Now you can add the jobs.

Maven job is usually what you want, this job will monitor and build your maven project.

You can also freestyle it, which allows more advanced usages.

Jenkins is pretty well documented so you can (and should) experiment on your own.

## Sample oVirt jobs

Here's a selection of sample jobs that you can import to the project, just be sure to change the repo-url.

<Media:oVirt-engine.jobs.tar.gz>

You can do this by running:

      # sed -i 's#`\[git-repo-url\]`#ssh://[user]@[git-host]/[git-repo-location]#' oVirt-engine.*

For example:

      # sed -i 's#`\[git-repo-url\]`#ssh://mkolesni@myhost/~/git/ovirt-engine#' oVirt-engine.*

Then, you can import them using the Jenkins CLI client:

      # cat [job].xml | java -jar /tmp/jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` create-job [job-name]

For example:

      # cat oVirt-engine.xml | java -jar /tmp/jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` create-job oVirt-engine
