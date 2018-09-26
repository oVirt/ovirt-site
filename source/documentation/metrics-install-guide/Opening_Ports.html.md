# Opening Ports

The TCP ports listed below are required by OpenShift Container Platform. Ensure that they are open on your network and configured to allow access between hosts. 

Use iptables to open ports. The following example opens port *22*:

```
# iptables OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp \
 --dport 22 -j ACCEPT
```

**Required Ports**

* **22** Required for SSH by the installer or system administrator.
* **443** For use by Kibana. 
* **8443** For use by the OpenShift Container Platform web console, shared with the API server. This enables Metrics users to access the OpenShift Management user interface.
* **9200** For Elasticsearch API use. Required to be internally open on any infrastructure nodes to enable Kibana to retrieve logs. It can be externally opened for direct access to Elasticsearch by means of a route. The route can be created using `oc expose`.