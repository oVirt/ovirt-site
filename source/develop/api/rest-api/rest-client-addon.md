---
title: REST Client Addon
authors: lpeer, moti
---

# REST Client Addon

**Two methods for invoking REST-API requests are described bellow:**

## Using *firefox* rest client add on

1. Add to firefox the rest-client add-on: [`https://addons.mozilla.org/en-US/firefox/addon/restclient/`](https://addons.mozilla.org/en-US/firefox/addon/restclient/)
2. Restart firefox
3. Go to Tools --> REST Client
4. Click on Authorization -> Basic Authorization button, enter username and password.
   Username should include the domain. e.g. `admin@internal`
5. Click on Headers -> Custom headers and add

      name: Content-type
      value: application/xml

6. Select "Get" method, put in URL field the server address, followed by `/api`. e.g: `http://localhost:8080/api/`
7. Click on send

The expected result in the bottom window should be a red bar with text: `STATUS CODE: 200, OK`
On the "Response Body" tab, the entire entities supported by the service are presented.
Selecting a specific entity and sending request for it will return the action supported for it and a collection of those entities.

The following link will return the entire list of VMs: `http://localhost:8080/api/vms`
The response body contains a fixed list of "ready-to-paste" list which could be used to be pasted into the URL.

If wishes to run command/action:
1. Change to "Post" method
2. Paste in the request body the request e.g. for adding a snapshot for a specific vm, type a url for that vm: `http://localhost:8080/api/vms/61d0c568-62f5-4b8c-8548-7000beb27d7c/snapshots`

   The request body:
   {% highlight xml %}
   <snapshot>
     <description>New Snapshot for VM</description>
     <vm id="61d0c568-62f5-4b8c-8548-7000beb27d7c" href="/api/vms/67f2ba3e-1a32-4aee-8be6-3f5c6fa4cfd8"/>
   </snapshot>
   {% endhighlight %}

This will add a new snapshot for VM with id `61d0c568-62f5-4b8c-8548-7000beb27d7c`.

## curl

The second method is by using *curl* utility from the command line.

Example of adding new snapshot:

      curl -v -u "admin@internal":letmein\! \
        -H "Content-type: application/xml" \
        -d '`<snapshot>`  \
             `<description>`New Snapshot for VM`</description>` \
             `<vm id="61d0c568-62f5-4b8c-8548-7000beb27d7c" href="/api/vms/61d0c568-62f5-4b8c-8548-7000beb27d7c"/>` \
         `</snapshot>`' \
        http://localhost:8080/api/vms/61d0c568-62f5-4b8c-8548-7000beb27d7c/snapshots

The *curl* command line utility (provided by the *curl* package) could be enhanced by a script which could run in parallel to test various scenarios.
It is also suitable for any type of non-functional tests (NFT). For full list of arguments refer to curl man pages.
