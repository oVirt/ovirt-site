# Configuring Ansible Prerequisites

You must be able to log into the machine using an SSH keypair.
The following instructions assume you are running Ansible on the same machine that you will be running OpenShift Aggregated Logging. 

**Configure Ansible Prerequisites**

1. Assign the machine an FQDN and IP address so that it can be reached from another machine.
   These are the `public_hostname` and `public_ip` parameters.

2. Use the root user or create a user account.
   This user will be referred to below as $USER.
   If you do not use the root user, you must update *ansible_ssh_user*  and *ansible_become* in *vars.yaml*, which is saved to the */root* directory on the Metrics Store machine by default. 

3. Create an SSH public key for this user account using the `ssh-keygen` command.

   ```
   # ssh-keygen
   ```

4. Add the SSH public key to the user account *$HOME/.ssh/authorized_keys*:

   ```
   # cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
   ```

5. Add the SSH hostkey for localhost to your SSH known_hosts:

   ```
   # ssh-keyscan -H localhost >> $HOME/.ssh/known_hosts
   ```

6. Add the SSH hostkey for public_hostname to your SSH known_hosts:

   ```
   # ssh-keyscan -H public_hostname >> $HOME/.ssh/known_hosts
   ```

7. If you _not_ using the root user, enable passwordless sudo by adding `$USER ALL=(ALL) NOPASSWD: ALL` to */etc/sudoers*.

8. Verify that passwordless SSH works, and that you do not get prompted to accept host verification, by running:

   ```
   # ssh localhost 'ls -al'
   # ssh public_hostname 'ls -al'
   ```

   Ensure that you are not prompted to provide a password or to accept host verification.

**Note:** openshift-ansible may attempt to SSH to localhost. This is the expected behavior.
