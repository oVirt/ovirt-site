---
title: Website organisation
category: website-tasks
authors: dneary, jbrooks, quaid
wiki_category: Website tasks
wiki_title: Website organisation
wiki_revision_count: 14
wiki_last_updated: 2012-11-19
---

# Website organisation

These pages are to organise work on the reorganisation of the [ovirt.org front page](http://www.ovirt.org), the identification of missing documentation we should add, and the organisation and maintenance of the wiki.

## Priorities

*   Provide an automated way for someone to create an account on the wiki. Rather than requiring a user to contact an existing account holder, we can enable the [ConfirmAccount extension](http://www.mediawiki.org/wiki/Extension:ConfirmAccount) to allow a more standard moderator workflow, and add a number of people to the Bureaucrat role.
*   Review top level menu and web pages, and propose an alternative organisation. Some things are prominent that don't need to be, other things which should be are not.
*   Start spring-cleaning the wiki: make a more attractive front page, categorise pages, and generally work on making it more easily navigable (page renaming is crucial)
*   Gap analysis on the documentation we have - what docs do we need which we don't have yet?
*   Migrate PDF documentation to HTML (either static or wiki)
*   Promotion of the oVirt 3.1 release

## Front page organisation

*   There is no link to the wiki
*   Activity isn't really useful - should be a subsection of Community
*   Community activity and Activity are redundant
*   We need a "Documentation" section, which can include guides and wiki pages (I only see the presentation resources and the wiki, so perhaps we can have everything in the wiki for now).
*   "News and events" could go in "Activity"
*   Create opportunities to engage - make "Community" the second most important page after "Get oVirt"
*   We need a big "Get oVirt" link on the front page with a link to download + instructions.

### Wiki spring cleaning

*   Clean up and organise front page into two main parts: oVirt users knowledge base, and oVirt contributors workspace
    -   User pages will include tutorials, documentation, architecture overviews
    -   Developer pages will have developer getting started tutorials, workspaces for Infra and website, developer documentation for people who want to get started/build from source\* Rename all pages as per <Help:Wiki_structure#Page_naming>
*   Rename all pages as per <Help:Wiki_structure#Page_naming>
*   Add categories to facilitate search
*   Eliminate any orphan pages, consolidate redundant pages, split long pages, version docs for the oVirt version they apply to - basic wiki gardening
*   Refresh docs for oVirt 3.1

### Gap analysis

*   "Installing oVirt on Fedora 17" - I thought this existed, but can't find it
*   "Quick start oVirt cluster" - getting oVirt up and running from scratch with an engine, a storage domain, and two nodes
*   "Adding a new node to a cluster"
*   Screenshots, Engine walkthrough for common tasks
*   "Integrating a Gluster/Ceph storage cluster"

### PDF documentation

All of the documentation on [the resources page](http://www.ovirt.org/project/resources/) is either in PDF presentation form, or ODF and PDF document format. Specifically, we should migrate the following to the wiki, and complete with screenshots/images as necessary:

*   oVirt architecture "deep dive"
*   ovirt-node overview
*   ovirt-storage overview
*   vdsm overview
*   ovirt-engine overview
*   Starting a developer environment

[Category:Website tasks](Category:Website tasks) [Category:Wiki cleanup](Category:Wiki cleanup)
