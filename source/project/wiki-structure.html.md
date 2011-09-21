---
title: Wiki structure
category: project
authors: quaid, wikisysop
wiki_category: Project
wiki_title: Help:Wiki structure
wiki_revision_count: 4
wiki_last_updated: 2011-12-13
---

# Wiki structure

Making wiki pages? Want to know how to name them in MediaWiki? This page tells you how we want the wiki structured, when it comes to creating new pages or moving around old content.

Consistency is good, it instills a sense of confidence in to the reader. These rules are designed to use MediaWiki while making life easier for contributors *and* readers.

## Page naming

Use this for naming new pages and areas.

### General naming rules

These rules are for pages and sections.

*   Do not nest pages in sub-folders, e.g. Topic/FAQ
*   Use natural language naming (as opposed to nesting)
*   Use capital letters only for the initial word in a title or section title: "Like this"
    -   Example: [[Join the Foo Project]]; [[Setting up USB boot media]]; [[FAQ on SELinux]]; [[Standing in the middle of the field#With my eyes wide open]].

Pages are not organized by nesting, they are organized using [#Categories](#Categories).

### End-user focused pages

These are pages focused on end-users of all levels, beginner to highly experienced. These are pages not specifically under a sub-project.

*   Name pages within a single, flat namespace; do not use directory-like hierarchies:
    -   **no** : [[CodeRepository/CommitHowTo]]
    -   **yes** : [[How to commit code to the repository]]

### Project and SIG focused pages for contributors

These are pages focused on contributors who are working in one or more areas of oVirt. Some content may be end-user focused but belong within the project for reference.

The content here *mus* be without nesting, putting all pages in an appropriate [:Category:Foo Project](:Category:Foo Project) category.

*   Content *must* be in a flat namespace with spaces
    -   **no** : Node/Packages/Distributions/Version
    -   **no** : VDSM/Package_Maintainer_Generic_Job_Description
    -   **yes** : Node_package_versions_in_different_distributions; Generic_job_description_for_VDSM_package_maintainers

## Namespaces

A MediaWiki namespace is a special word followed by a colon, that puts the content in a different naming area in the wiki.

### Automatically searchable namespaces

*   Main:
*   Help:
*   Category:

### User: namespace

The *User:* namespace is somewhere you can put drafts and other personal material that you do not want searched and indexed by engines like Google. For instance, the user *jpublic* can build any wiki materials as desired under *User:Jpublic*, using subpages. If you need to know what pages you've built under your personal *User:* namespace, use the <Special:Prefixindex> page.

## Categories

*   Use as many categories as needed that make sense:
    -   [:Category:ProjectName](:Category:ProjectName) [:Category:Meetings](:Category:Meetings) [:Category:Infrastructure](:Category:Infrastructure)
*   The category pages are the aggregation pages. Point to them prominently as the way to find all of something on a topic/within a category.
    -   "To review a list of all docs currently in draft, refer to the [:Category:Draft documentation](:Category:Draft documentation)."
    -   "Useful end-user docs are found in the [:Category:Documentation](:Category:Documentation)."
    -   "To learn more about oVirt Node, refer to the [:Category:Node](:Category:Node) pages.
*   New category names should follow the same natural language rules as individual pages but are usually plural:
    -   VDSM meeting logs
    -   Evangelists in North America
    -   2012 events
    -   Workshop agenda for 1 November

*(Remixed from <https://fedoraproject.org/wiki/Help:Wiki_structure> and used under the [CC BY SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).)*

[Category:How to](Category:How to) <Category:Documentation> <Category:Wiki>
