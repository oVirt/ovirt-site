# Attaching Subscriptions and Enabling Repositories

OpenShift Aggregated Logging requires RHEL 7.5 and OpenShift 3.9 subscriptions. 

1. Register your system with the Content Delivery Network, entering your Customer Portal user name and password when prompted:

   ```
   # subscription-manager register
   ```

2. Pull the latest subscription data from Red Hat Subscription Manager:

   ```
   # subscription-manager refresh
   ```

3. Find the the `OpenShift Container Platform` subscription pool and note down the pool ID:

   ```
   # subscription-manager list --available
   ```

4. Use the pool IDs to attach the subscriptions to the system: 

   ```
   # subscription-manager attach --pool=_pool_id_
   ```

5. Enable the required repositories:

   ```
   # subscription-manager repos --enable="rhel-7-server-rpms" \
       --enable="rhel-7-server-extras-rpms" \
       --enable="rhel-7-server-ose-3.9-rpms" \
       --enable="rhel-7-fast-datapath-rpms" \
       --enable="rhel-7-server-ansible-2.4-rpms"
   ```

