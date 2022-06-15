---
title: Jenkins
category: infra
authors:
  - eedri
  - mburns
  - quaid
  - rmiddle
---

# Jenkins oVirt Server

oVirt Jenkins server is [jenkins.ovirt.org](http://jenkins.ovirt.org/) (107.22.215.130)

# Recommended server specs

These are specs for servers to run Jenkins slaves for oVirt testing. One base configuration could be:

* 16 GB RAM each
* 4/8 cores each
* 200 GB disk each
* 32 GB swap

# Access to the server

* OS Level Access: Restricted to infra team only. (PKI)
* Read UI Access: Anonymous read access is available to see all jobs/workspaces and build results.
* Login UI Access: availialble only to infra team, and by request to <infra@ovirt.org>.

Contact Infra team if you think you should have privileged access to the server.

## Troubleshooting OS level access:

```
restorecon -R -v /home/user
restorecon -R -v /home/user/.ssh
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys
passwd user
```

# Installation

1. Install LTS version from <http://pkg.jenkins-ci.org/redhat-stable/>
2. Run it behind Apache: <https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache>
3. `chkconfig httpd on`
4. `yum install java-1.6.0-openjdk-devel git postgresql postgresql-server postgresql-contrib`
5. Run `/etc/init.d/postgresql initdb`
6. Set `postgresql` in `pg_hba.conf` to `trust`
7. Restart PostgreSQL service
8. Add engine 'role' as superuser to PostgreSQL:

   ```
   psql -U postgres -c "CREATE ROLE engine WITH LOGIN SUPERUSER"
   ```

9. `service jenkins start`
10. Install Jenkins plugins:

    ```
    wget http://localhost:8080/jnlpJars/jenkins-cli.jar
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin audit-trail
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin git
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin multiple-scms
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin analysis-collector
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin findbugs
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin Email-ext
    java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin port-allocator
    ```

11. Config `JAVA_HOME` in  [Jenkins > configuration](https://jenkins.ovirt.org/configure){:data-proofer-ignore=''}
12. Config default maven in [Jenkins > configuration](https://jenkins.ovirt.org/configure){:data-proofer-ignore=''}
13. Edit `/etc/sysconfig/jenkins` (replace line):

    ```
    JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms4g -Xmx4g -XX:MaxPermSize=1024M"
    ```

14. increase limit of open file using `ulimit -n` (for persistent  change add to `/etc/sysctl.conf`): `fs.file-max = 2048`
15. Amazon EC2 doesn't come with swap space, so create a swap file or swap partition.


## Create swap space

Check to see if you have the `/dev/xvdk` device available (`fdisk -cul`).

If `/dev/xvdk` exists, follow these steps:

1. Edit the storage device:

   ```
   fdisk -cu /dev/xvdk
   ```
2. Create a new swap partition (type 82) and save changes.

3. Create swap:

   ```
   mkswap /dev/xvdk1
   ```
4. Activate swap:

   ```
   swapon /dev/xvdk1
   ```
5. Add device to the filesystem list:

   ```
   echo "/dev/xvdk1       none    swap    sw      0       0" >> /etc/fstab
   ```

If `/dev/xvdk` does not exist, [create a swapfile](http://www.cyberciti.biz/faq/linux-add-a-swap-file-howto/).

## Add temporary space for workspace (deletes data after reboot)

```
mkfs -t ext4 /dev/xvdj
mkdir /ephemeral0
echo "/dev/xvdj /ephemeral0 ext4 defaults 1 2" >> /etc/fstab
mount /ephemeral0
```

## Expand default root partition

Amazon VM comes with a default 5GB / partition. but it actually has 50GB you can use. run this command to expand it

```
resize2fs /dev/xvde1
```

## Change open files

Jenkins slave might run out of openfiles. to change this you need to run:

1. `ulimit -n 2048`
2. Edit `/etc/sysctl.conf`:

   ```
   fs.file-max = 2048
   ```
3. Edit `/etc/security/limits.conf`:

   ```
   jenkins  soft    nofiles    2048
   jenkins  hard    nofiles    2048
   ```

## allows sudo access for jenkins user

Jenkins user needs sudo access to be able to run tests from jenkins jobs, do this on each jenkins slave: edit /etc/suders:

1. Comment out this line:

   ```
   Defaults    requiretty
   ```

2. Add the line:

   ```
   jenkins ALL=(ALL)       NOPASSWD: ALL
   ```
