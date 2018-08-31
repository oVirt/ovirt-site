# Configuring Persistent Storage for Elasticsearch

Elasticsearch requires persistent storage for the database.
By default, Elasticsearch uses ephemeral storage, and therefore you need to manually configure persistent storage.

**Important:** Before proceeding, ensure you have set up the storage according to the instructions in [Prerequisites](../Prerequisites).

**Configuring Persistent Storage for Elasticsearch**

1. Create the `/lib/elasticsearch` directory that will be used for persistent storage using the `/var` mounted storage partition you created in [Prerequisites](../Prerequisites): 

   ```
   # mkdir -p /var/lib/elasticsearch
   ```

2. Change the group ownership of the directory to 65534:

   ```
   # chgrp 65534 /var/lib/elasticsearch
   ```

3. Make this directory writable by the group: 

   ```
   # chmod -R 0770 /var/lib/elasticsearch
   ```

4. Run the following commands:

   ```
   # semanage fcontext -a -t container_file_t "/var/lib/elasticsearch(/.*)?"
   # restorecon -R -v /var/lib/elasticsearch
   ```
