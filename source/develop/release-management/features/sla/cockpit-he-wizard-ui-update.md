---
title: Cockpit Hosted Engine Wizard UI Update
category: feature
authors: phbailey
---

# Cockpit Hosted Engine Wizard UI Update

## Summary

Provide an improved user experience in the Cockpit hosted engine setup wizard.

## Owner

*   Owner: Phillip Bailey
*   Email: phbailey@redhat.com

## Detailed Description

The current hosted engine setup wizard in Cockpit uses the machine dialect interface for OTOPI, which effectively emulates the command line interface. This approach allows for the most robust error-handling possible, but delivers a very poor user experience for a number of reasons:

* Only a small amount of the available space is used, as each page consists of a single question
* Related questions aren't grouped and displayed together
* There is no indication of progress completion
* There is no "Back" option, meaning the user has to cancel entirely if they discover they've made an error
* A text box component is used for all input types

![](/images/wiki/cockpit-he-setup-wizard-old.png)

The redesigned UI addresses each of these issues in order to provide a more efficient and enjoyable user experience.

## Approach

Instead of interfacing with OTOPI in the machine dialect manner currently being used, an answer file will be created that can be consumed by hosted engine setup.

#### Error Handling

Existing Cockpit infrastructure will be used to check for major requirements such as hardware virtualization support and storage connectivity. Input issues like formatting problems will be checked in real-time on the front end. Errors thrown from the setup process will be determined via OTOPI exit codes. The user will then have the opportunity to correct the errors and reattempt deployment using the updated answer file.

## User Experience

The first major change in the updated UI is the addition of a progress indicator at the top of the wizard. The progress indicator informs the user of what stages make up the setup process, where they are in the process, and what stages they have left to complete. Each stage contains all of its relevant input fields, as expected.


![](/images/wiki/cockpit-he-setup-wizard-update-storage.png)

![](/images/wiki/cockpit-he-setup-wizard-update-vm.png)

The user can move between each of the stages as they choose, allowing for corrections to be made at any point in the process. The last stage of the process provides the user's inputs on one screen for easy review. Note that it is planned for values to be separated by stage in the final version of the review screen.

![](/images/wiki/cockpit-he-setup-wizard-update-review.png)

## References
RFE in Bugzilla: [BZ 1367457](https://bugzilla.redhat.com/show_bug.cgi?id=1367457)
