# Removing Non-Operational Hosts from a Restored Self-Hosted Engine Environment

Once a host has been fenced in the Administration Portal, it can be forcefully removed with a REST API request. This procedure will use *cURL*, a command line interface for sending requests to HTTP servers. Most Linux distributions include *cURL*. This procedure will connect to the Manager virtual machine to perform the relevant requests.

**Fencing the Non-Operational Host**

1. In the Administration Portal, right-click the hosts and select **Confirm 'Host has been Rebooted'**.

    Any virtual machines that were running on that host at the time of the backup will now be removed from that host, and move from an **Unknown** state to a **Down** state. The host that was fenced can now be forcefully removed using the REST API.

2. **Retrieving the Manager Certificate Authority**

    Connect to the Manager virtual machine and use the command line to perform the following requests with *cURL*.

    Use a `GET` request to retrieve the Manager Certificate Authority (CA) certificate for use in all future API requests. In the following example, the `--output` option is used to designate the file `hosted-engine.ca` as the output for the Manager CA certificate. The `--insecure` option means that this initial request will be without a certificate.

        # curl --output hosted-engine.ca --insecure https://[Manager.example.com]/ca.crt

3. **Retrieving the GUID of the Host to be Removed**

    Use a `GET` request on the hosts collection to retrieve the Global Unique Identifier (GUID) for the host to be removed. The following example includes the Manager CA certificate file, and uses the `admin@internal` user for authentication, the password for which will be prompted once the command is executed.

        # curl --request GET --cacert hosted-engine.ca --user admin@internal https://[Manager.example.com]/api/hosts

    This request returns the details of all of the hosts in the environment. The host GUID is a hexadecimal string associated with the host name. For more information on the Red Hat Virtualization REST API, see the *Red Hat Virtualization REST API Guide*.

4. **Removing the Fenced Host**

    Use a `DELETE` request using the GUID of the fenced host to remove the host from the environment. In addition to the previously used options this example specifies headers to specify that the request is to be sent and returned using eXtensible Markup Language (XML), and the body in XML that sets the `force` action to be `true`.

        curl --request DELETE --cacert hosted-engine.ca --user admin@internal --header "Content-Type: application/xml" --header "Accept: application/xml" --data "<action><force>true</force></action>" https://[Manager.example.com]/api/hosts/ecde42b0-de2f-48fe-aa23-1ebd5196b4a5</screen>

    This `DELETE` request can be used to remove every fenced host in the self-hosted engine environment, as long as the appropriate GUID is specified.

5. **Removing the Self-Hosted Engine Configuration from the Host**

    Remove the host's self-hosted engine configuration so it can be reconfigured when the host is re-installed to a self-hosted engine environment.

    Log in to the host and remove the configuration file:

        # rm /etc/ovirt-hosted-engine/hosted-engine.conf

The host can now be re-installed to the self-hosted engine environment.
