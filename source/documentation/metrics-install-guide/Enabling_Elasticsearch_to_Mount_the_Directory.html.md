# Enabling Elasticsearch to Mount the Directory

After the installation, the Elasticsearch service will not be able to run until granted permission to mount that directory.

**Enabling Elasticsearch to Mount the Directory**

Run the following:

```
# oc project logging
# oadm policy add-scc-to-user hostmount-anyuid \
  system:serviceaccount:logging:aggregated-logging-elasticsearch

# oc rollout cancel $( oc get -n logging dc -l component=es -o name )
# oc rollout latest $( oc get -n logging dc -l component=es -o name )
# oc rollout status -w $( oc get -n logging dc -l component=es -o name )
```


