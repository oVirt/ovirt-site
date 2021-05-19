---
title: Cockpit
category: feature
authors: tlitovsk
---

# Cockpit

## oVirt Node Cockpit

### Summary

This feature adds the cockipt server (http://cockpit-project.org/) to the oVirt node installation.
It will replace the TUI interface used to control the oVirt node.

### Owner

*   Name: Fabian Deutsch (fabiand)

<!-- -->

*   Email: fabiand AT redhat DOT com
*   IRC: fabiand

### Detailed Description

Th main reason for this change it to adopt a common used UI for the oVirt Node.
The use of such community supported framework will provide control of oVirt node in manner that is familiar to many users out of the oVirt community.
Additionally it provides a browser based control of the nodes which is much more user friendly then the current TUI.
Last but not least is the option of utilizing common code and reduce the amount of oVirt unique code.

### Benefit to oVirt

Less unique code with more friendly UI.

### Dependencies / Related Features

A command line browser will need to be added to allow browsing the cockpit page from serial console.

### Testing

TBD

### Documentation / External references

<http://cockpit-project.org/>
<https://bugzilla.redhat.com/show_bug.cgi?id=1190758>

### Comments and Discussion

Comments and discussion can be posted on mailinglist or the referenced bug.

This is a place holder for cockpit feature page and still being written

