# Verifying the OpenShift Aggregated Logging Installation

The following procedures verify that all pods and services are running, and that the hostname, IPs, and routes are correctly configured.

**Verifying the OpenShift Aggregated Logging Installation**
 
1. Log into the project:

   ```
   # oc project logging
   ```

2. To confirm that Elasticsearch, Curator, and Kibana pods are running, run:

   ```
   # oc get pods
   ```

3. Check that the *STATUS* is `Running`.

4. To confirm that the Elasticsearch and Kibana services are running, run:

   ```
   # oc get svc
   ```

5. Ensure  that the *EXTERNAL-IP*  and  *PORT(S)* fields are correct.

6. To confirm that there are routes for Elasticsearch and Kibana, run:

   ```
   #  oc get routes
   ```

7. Ensure that the value of *HOST/PORT* is correct.
