---
title: Migrate to Hosted Engine
authors: didi
wiki_title: Migrate to Hosted Engine
wiki_revision_count: 8
wiki_last_updated: 2014-12-03
---

# Migrate to Hosted Engine

## DRAFT

An example showing how to migrate an existing engine installation to [ Self Hosted Engine](Features/Self_Hosted_Engine).

Suppose we had an existing engine machine, with hostname 'host-a'. We setup the engine there with the fqdn 'my-engine.example.com', and configured our dns to point this name to the IP address of host-a. Now we want to migrate this installation to hosted engine.

First, on host-a, we run engine-backup --mode=backup: engine-backup --mode=backup --file=backupfile1 --log=backup1.log

Now we install a new host, say 'host-b'. We install on it fedora 19, choose minimal installation.

Then:

Add repos

yum install ovirt-hosted-engine-setup

hosted-engine --deploy

When deploy runs, we tell it that the engine VM's fqdn will be 'my-engine.example.com'.

It creates and boots a VM, we install fedora with minimal installation:

Give it a name 'new-engine.example.com'

Then:

Add repos

yum install ovirt-engine

Now we restore. First we create a database - 'engine-backup --help' will give more details:

create user

create database

edit pg_hba.conf

restart postgresql

Now we restore. We copy backupfile1 to the VM (new-engine.example.com), and run: engine-backup --mode=restore --file=backupfile1 --log=restore1.log --change-db-credentials --db-host=localhost --db-user=engine --db-password --db-name=engine

restore restores the files and database from the backup file, but does not enable/start the services, nor configures other things - such as selinux contexts. For this we need to run setup.

The cutoff point

Now suppose we are ready to do the cutoff.

On host-a, we stop the engine: service ovirt-engine stop

We update our dns to point the name 'my-engine.example.com' to the IP address of the new VM 'new-engine'.

Then on new-engine we run setup: engine-setup

Then we go back to the console where we ran 'hosted-engine --deploy', on 'host-b':

It reboots the VM, etc.
