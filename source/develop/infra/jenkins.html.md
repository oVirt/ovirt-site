---
title: Jenkins
category: infra
authors: eedri, mburns, quaid, rmiddle
wiki_category: Infrastructure documentation
wiki_title: Jenkins
wiki_revision_count: 10
wiki_last_updated: 2012-07-23
---

# Jenkins oVirt Server

oVirt Jenkins server is jenkins.ovirt.org (107.22.215.130)

# Recommended server specs

These are specs for servers to run Jenkins slaves for oVirt testing. One base configuration could be:

*   16 GB RAM each
*   4/8 cores each
*   200 GB disk each
*   32 GB swap

# Access

      * OS Level Access: Restricted to infra team only. (PKI)
      * Read UI Access: Anonymous read access is available to see all jobs/workspaces and build results. 
      * Login UI Access: availialble only to infra team, and by request to infra@ovirt.org.

Contact Infra team if you think you should have privileged access to the server.

### Troubleshooting OS level access:

      * restorecon -R -v /home/user
      * restorecon -R -v /home/user/.ssh
      * chmod 700 /home/user/.ssh
      * chmod 600 /home/user/.ssh/authorized_keys
      * passwd user

# Installation

`* Install LTS version from `[`http://pkg.jenkins-ci.org/redhat-stable/`](http://pkg.jenkins-ci.org/redhat-stable/)
`* Run it behind apache: `[`https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache`](https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache)
      * chkconfig httpd on
      * yum install java-1.6.0-openjdk-devel git postgresql postgresql-server postgresql-contrib
      * run /etc/init.d/postgresql initdb 
      * set postgresql pg_hba.conf to trust 
      * restart postgresql service
      * add engine 'role' as superuser to postgres -> 
      * psql -U postgres -c "CREATE ROLE engine WITH LOGIN SUPERUSER"
      * service jenkins start
      * Install Jenkins plugins: 
`  wget `[`http://localhost:8080/jnlpJars/jenkins-cli.jar`](http://localhost:8080/jnlpJars/jenkins-cli.jar)
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin audit-trail
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin git
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin multiple-scms
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin analysis-collector
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin findbugs
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin Email-ext
        java -jar jenkins-cli.jar -s `[`http://localhost:8080`](http://localhost:8080)` install-plugin port-allocator

`* config JAVA_HOME in `[`http://jenkins.ovirt.org/configure`](http://jenkins.ovirt.org/configure)
`* config default maven in `[`http://jenkins.ovirt.org/configure`](http://jenkins.ovirt.org/configure)
      * edit /etc/sysconfig/jenkins (replace line):
      * JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms4g -Xmx4g -XX:MaxPermSize=1024M"
      * increase limit of open file using 'ulimit -n' (for persistent  change add to '/etc/sysctl.conf') => fs.file-max = 2048
      * amazon ec2 doesn't come with swap space -> create a swap file or partition:

### Create swap space

check to see if you have /dev/xvdk device available (fdisk -cul) if it exists, follow these steps:

      * fdisk -cu /dev/xvdk
      * create a new swap partition (type 82) and save changes
      * mkswap /dev/xvdk1
      * swapon /dev/xvdk1
      * echo "/dev/xvdk1       none    swap    sw      0       0" >> /etc/fstab

in case it doesn't, create a swapfile

`* `[`http://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/`](http://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/)

### add temporary space for workspace (deletes data after reboot)

      * mkfs -t ext4 /dev/xvdj
      * mkdir /ephemeral0
      * echo "/dev/xvdj /ephemeral0 ext4 defaults 1 2" >> /etc/fstab
      * mount /ephemeral0

### expand default root partition

Amazon VM comes with a default 5GB / partition. but it actually has 50GB you can use. run this command to expand it

      * resize2fs /dev/xvde1

### change open files

Jenkins slave might run out of openfiles. to change this you need to run:

      *ulimit -n 2048
      *edit /etc/sysctl.conf: fs.file-max = 2048
      *edit /etc/security/limits.conf:
      *  jenkins  soft    nofiles    2048
      *  jenkins  hard    nofiles    2048

### allows sudo access for jenkins user

Jenkins user needs sudo access to be able to run tests from jenkins jobs, do this on each jenkins slave: edit /etc/suders:

      * remark the line: Defaults    requiretty
      * add the line: jenkins ALL=(ALL)       NOPASSWD: ALL

[Category: Infrastructure documentation](Category: Infrastructure documentation)
