---
title: Project moVirt for iOS
authors: mpolednik
wiki_title: Project moVirt for iOS
wiki_revision_count: 5
wiki_last_updated: 2015-04-28
---

# moVirt for iOS

### Summary

moVirt for iOS is iOS version of previously Android only mobile client for oVirt. This project is aimed at delivering similar functionality in native Swift for iOS platform, with UI and controls respecting platform guidelines.

### Owner

*   Name: [ Martin Polednik](User:Martin Polednik)
*   Email: <mpolednik@redhat.com>

### Current phase

phase 1

### Phases

#### Phase 1

*   Analysis of technologies available for accessing oVirt REST API.
*   Creation of basic (offline) app to test possible moVirt UI and UX

### iOS specific limitations

iOS does not give application developers much freedom when the application is in the background. There are 2 hacks, often causing rejection in App Store:

*   using e.g. music API with silent track to keep the app active in the background and
*   using VoIP API.

The supported solution is declaring a class of background actions the app can execute, which in our case is `fetch` or `remote-notification`. In the first case, moVirt would be able to periodically poll Engine or doctor REST for batch updates. The second case is a bit more complex as it involves use of APNs, therefore sending possibly sensitive data to Apple servers. `fetch` mode also comes with a small caveat: "Enabling this mode is not a guarantee that the system will give your app any time to perform background fetches.".

It seems that currently, given limitations and choices, `fetch` is the best way of getting fresh data center state to moVirt.
