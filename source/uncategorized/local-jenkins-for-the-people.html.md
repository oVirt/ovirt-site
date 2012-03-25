---
title: Local Jenkins For The People
authors: lpeer, mkolesni, moti, msalem
wiki_title: Local Jenkins For The People
wiki_revision_count: 13
wiki_last_updated: 2013-02-11
---

# Local Jenkins (guide) for the people

Wherever you need to substitute a value, the notation **[]** is used, ie **[value]**. You can download this guide and run a search/replace on it with your own values (or just replace whenever needed).

The needed values are:

------------------------------------------------------------------------

*   **[jenkins-host]** - The host you're installing jenkins to (IP/FQDN) - i.e. your VDSM host.
*   **[git-host]** - The host where the GIT repository you work on is located (your local repo, not origin) - i.e. your lap[top.
*   **[user]** - The user you use to work on your stuff (In order to clone from your repo).
*   **[git-repo-location]** - The location of the git repo on the [git-host] - i.e. ~/git/ovirt-engine

# Install & configure Jenkins

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

### Configure SSH for jenkins user

#### Generate SSH key for jenkins

      # su - -s /bin/bash jenkins
      $ ssh-keygen -t rsa

#### Copy the public key to your user on your machine

`$ ssh-copy-id `**`[user]`**`@`**`[git-host]`**

#### Check that you can SSH without password

      $ ssh `**`[user]`**`@`**`[git-host]`**` "echo 'Hello world'"
      Hello world

### Now need to define jenkins & jobs..

#### Install plugins

##### Download jenkins CLI

`# wget `[`http://localhost:8080/jnlpJars/jenkins-cli.jar`](http://localhost:8080/jnlpJars/jenkins-cli.jar)

##### Install the plugins

      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin git
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin checkstyle
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin findbugs
      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin saferestart

##### Restart jenkins

      # java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` safe-restart

### Configure general settings

Go to <http://>**[jenkins-host]**:8080/configure which will open jenkins system config.

Add the GIT and Maven installations, if they aren't listed.

### Change the following fields to the specified values

*   1.  of executors = 4
*   SCM checkout retry count = 100
*   Global MAVEN_OPTS = -Xincgc

# Add the jobs

### Add job for oVirt-engine

This is the base jobs which builds the engine, without tests. All other jobs are triggered by this job.

TODO: Fill
