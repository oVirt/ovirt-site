---
title: Non plugin console invocation
category: feature
authors: fkobzik
wiki_category: Feature
wiki_title: Features/Non plugin console invocation
wiki_revision_count: 7
wiki_last_updated: 2013-07-12
---

# Non plugin console invocation

### Summary

This feature allows connecting to VM console from the engine frontend without the need of browser plugin.

### Detailed description

This feature adds to the engine the possibility of serving configuration files for console viewer on the client system. The user can then associate corresponding viewer application to this file (using MIME type registration in browser).

### Configuration

      engine-config -s ClientConsoleMode=value

where value is a string that can be Plugin, Native or Auto. This settings will affect behavior of the connect-to-console button on the frontend.

      Plugin - current behavior. The browser plugin is used for connecting to the console.
      Native - the console configuration file is served to the client and then the native console client is used.
      Auto - if there is the console plugin installed in the browser, it is used. Otherwise native client is used.

### Benefit to oVirt

      - The possibility of invoking VNC connections from the browser.
      - The possibility of invoking SPICE connections from browsers that do not support spice-xpi plugin (Firefox in MS Windows, Google Chrome...).

<Category:Feature>
