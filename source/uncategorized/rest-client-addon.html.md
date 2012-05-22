---
title: REST Client Addon
authors: lpeer, moti
wiki_title: REST Client Addon
wiki_revision_count: 6
wiki_last_updated: 2012-05-28
---

# REST Client Addon

Two methods for invoking RestAPI requests are described ahead:

Using *firefox* rest client add on:

Add to firefox the rest-client add-on: <
> <https://addons.mozilla.org/en-US/firefox/addon/restclient/>

Once installed and firefox was restarted, go to Tools --> REST Client<
> Click on Login button, enter username and password.<
> Username should include the domain. e.g.

Select "Get" method<
> Put in URL field the server address, followed by /api. e.g:

Click on send.<
> The expected result in the bottom window should be a green bar with text:<
>

On the "Response Body" tab, the entire entities supported by the service are presented.<
> Selecting a specific entity and sending request for it will return as response the action supported for it and a collection of those entities.<
> The following link will return the entire list of VMs: <
> The response body contains a fixed list of "ready-to-paste" list which could be used to be pasted into the URL.<
>

If wishes to run command/action: <
>

      1. Change to "Post" method
      1. Add a header by clicking on "+Add Request Header" button:

      1.#3 Paste in the request body the request

e.g. for adding a snapshot for a specific vm, type a url for that vm:

The request body: This will add a new snapshot for VM with id 61d0c568-62f5-4b8c-8548-7000beb27d7c. <
>

## curl

The second method is by using *curl* utility from the command line. <
>

Example of adding new snapshot: The *curl* command line utility could be enhanced by a script which could run in parallel to test various scenarios.<
> It is also suitable for any type of non-functional tests (NFT). For full list of arguments refer to curl man pages.
