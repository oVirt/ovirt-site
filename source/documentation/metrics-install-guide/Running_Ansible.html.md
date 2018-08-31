# Running Ansible

Prior to running Ansible, verify that the value for hostname and IP address that you defined in the DNS matches the values Ansible will use.

**Running Ansible**

1. To check the host’s FQDN:

   ```
   # ansible -m setup localhost -a 'filter=ansible_fqdn'
   ```

2. To check the host's IP address:

   ```
   # ansible -m setup localhost -a 'filter=ansible_default_ipv4'
   ```

3. Run Ansible using the `prerequisites.yml` playbook to ensure the machine is configured correctly:

   ```
   # cd /usr/share/ansible/openshift-ansible
   # ANSIBLE_LOG_PATH=/tmp/ansible-prereq.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/prerequisites.yml
   ```

4. Run Ansible using the `openshift-node/network_manager.yml` playbook to ensure that the networking and the NetworkManager are configured correctly:

   ```
   # cd /usr/share/ansible/openshift-ansible
   # ANSIBLE_LOG_PATH=/tmp/ansible-network.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/openshift-node/network_manager.yml
   ```

5. Run Ansible using the `deploy_cluster.yml` playbook to install both OpenShift and the OpenShift Logging components:

   ```
   # cd /usr/share/ansible/openshift-ansible
   # ANSIBLE_LOG_PATH=/tmp/ansible.log ansible-playbook -vvv -e @/root/vars.yaml -i /root/ansible-inventory-ocp-39-aio playbooks/deploy_cluster.yml
   ```

6. Check `/tmp/ansible.log` to ensure that no errors occurred.
   If there are errors, fix the machine's definitions and/or `vars.yaml` and run Ansible again.

**Note:** If the installation fails, inspect the Ansible log files in `/var/log/ovirt-engine/ansible/`, fix the issue, and run the installation again.
