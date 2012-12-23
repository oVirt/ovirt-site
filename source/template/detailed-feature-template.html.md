---
title: Detailed feature template
category: template
authors: dneary, lvernia, mlipchuk, ovedo, quaid, vered
wiki_category: Template
wiki_title: Detailed feature template
wiki_revision_count: 18
wiki_last_updated: 2014-09-30
---

# Detailed feature template

The actual name of your feature page should look something like: "Your feature name". Use natural language to name the pages. Do *not* put in the name a fake-nesting e.g. "Feature/Your feature name".

## Your Feature Name

### Summary

A sentence or two summarizing what this feature is and what it will do. This information is used for the overall feature summary page for each release.

Add a link to the main feature page as well: [Your feature name](Your feature name)

### Owner

This should link to your home wiki page so we know who you are

*   Name: [ My User](User:MyUser)

Include you email address that you can be reached should people want to contact you about helping with your feature, status is requested, or technical issues need to be resolved

*   Email: <my@email>

### Current status

*   Target Release: ...
*   Status: ...
*   Last updated:

### Detailed Description

Provide the details of the feature. What is it going to include. See the sub-sections below. This section may contain more sub-sections, depends on the oVirt projects relevant for this feature.

#### Entity Description

New entities and changes in existing entities.

#### CRUD

Describe the create/read/update/delete operations on the entities, and what each operation should do.

#### User Experience

Describe user experience related issues. For example: We need a wizard for ...., the behaviour is different in the UI because ....., etc. GUI mockups should also be added here to make it more clear

#### Installation/Upgrade

Describe how the feature will effect new installation or existing one.

#### User work-flows

Describe the high-level work-flows relevant to this feature.

#### Events

What events should be reported when using this feature.

### Dependencies / Related Features and Projects

What other packages depend on this package? Are there changes outside the developers' control on which completion of this feature depends? In other words, completion of another feature owned by someone else and might cause you to not be able to finish on time or that you would need to coordinate? Other Features that might get affected by this feature?

Add a link to the feature description for relevant features. Does this feature effect other oVirt projects? Other projects?

### Documentation / External references

Is there upstream documentation on this feature, or notes you have written yourself? Link to that material here so other interested developers can get involved. Links to RFEs.

### Comments and Discussion

Add a link to the "discussion" tab associated with your page. This provides the ability to have ongoing comments or conversation without bogging down the main feature page

### Open Issues

Issues that we haven't decided how to take care of yet. These are issues that we need to resolve and change this document accordingly.

<Category:Template> <Category:DetailedFeature>
