---
title: Feature template
category: feature
authors: acathrow, danken, dneary, lvernia, nsoffer, ovedo, quaid, sandrobonazzola,
  vered
wiki_category: Feature
wiki_title: Feature template
wiki_revision_count: 20
wiki_last_updated: 2014-12-12
feature_name: Your feature name
feature_modules: engine,network,vdsm
feature_status: Released
---

# Feature template

## Your Feature's Name

The actual name of your feature page should look something like: "Your feature name". Use natural language to [name the pages](How to make pages#Page_naming).

### Summary

Summarize what this feature is and what it will do. Explain the problem it aims to solve, and the benefits to the end user. This information is used for the overall feature summary page for each release.

### Owner

This should link to your GitHub profile so we know who you are.

*   Name: My User (MyUser)

Include your email address to enable people to contact you: To help with the feature, to get a status update, or to raise technical issues that need addressing.

*   Email: <my@email>

### Detailed Description

Expand on the summary by explaining the feature's purpose clearly and in greater detail.

### Prerequisites

List any hardware or software prerequisites or any steps that need to be performed before the feature can be implemented.

### Limitations

List the feature's limitations.

### Benefit to oVirt

What is the benefit to the oVirt project? If this is a major capability update, what has changed? If this is a new feature, what capabilities does it bring? Why will oVirt become a better distribution or project because of this feature?

#### Entity Description

New entities and changes in existing entities.

#### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

#### User Experience

Describe user experience related issues. For example: "We need a wizard for ....", "the behavior is different in the UI because .....", etc. Add GUI mockups to make your explanation clearer.

#### Installation/Upgrade

Describe how the feature will effect new or existing installations.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

#### Event Reporting

What events should be reported when using this feature.

### Dependencies / Related Features

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? For example, the completion of another feature owned by someone else, which may prevent you from finishing on time, or require of you to coordinate the development work. Will other features be affected by this feature?

### Documentation / External references

Does this feature have upstream documentation or notes written by you? Add links to those resources, to enable interested developers to get involved. Links to RFEs.

### Testing

Explain how this feature may be tested by a user or a quality engineer. List relevant use cases and expected results.

### Contingency Plan

Explain what will be done in the event that the feature is not ready in time.

### Release Notes

      == Your feature heading ==
      A descriptive text of your feature to be included in release notes


### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.
