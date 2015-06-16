---
title: Categories
category: documentation
authors: quaid
wiki_category: Documentation|Wiki
wiki_title: Help:Categories
wiki_revision_count: 1
wiki_last_updated: 2011-12-13
---

# Categories

MediaWiki allows you to categorize pages and files by appending one or more **** tags to the content text. Adding these tags creates links at the bottom of the page that take you to the list of all pages in that category, which makes it easy to browse related articles.

## How to add a page to a Category

To add a page to a , simply put the following in the page you are editing:

      [[``:`*`NAME`*`]]

where *NAME* is the name of the you want to add it to. Any number of tags may be added to the page and the page will be listed in all of them. tags can be added wherever you like in the editing text, but in general, they are added at the very bottom for the convenience of other editors.

Images and other uploaded files can be categorized by adding tags to their description page. Adding tags to categories will categorize them into subcategories. It is always a good idea to organize all categories within your wiki into a hierarchy with a single top level category.

### Sort key

You can add a “sort key” to the tag that specifies where the page will appear within the Category. This is done by using the following markup:

      [[``:`*`NAME`*`|`*`SORT`*`]]

For example, to add this page to the “Help” category under the section “C,” you write

      [[``:Help|Categories]]

Note that sort keys are case sensitive, and even a space is recognized as a sort key. The order of the sections within a follows the order of Unicode.

The sort key does not affect how the page title is displayed in the category, only how it is ordered in the list. In the above example, the link to this page will still read ”Help:Categories.“

By default, pages not in the “main“ [namespaces](Help:Wiki_structure#Namespaces) will be sorted by the page name including the namespace, which can be rather inconvenient. One basic trick to avoid this is to use a special tag as a sort key as following:

      [[``:Help|{{PAGENAME}}]]

This is particularly useful when using templates that include a category tag.

## How to create a category

A category can be created just as other wiki pages (refer to [Help:Wiki structure](Help:Wiki structure)). Just remember to add `{{ns:category}}:` before the name of the category.

In fact, the list of pages in a category exists even if the category page is not created, but such categories are isolated from other categories and will serve little to sort out the pages and files of your wiki.

Renaming (moving) a category is not possible like other wiki pages. If it is necessary, you have to create a new category and change the tag in each member of the category. This loses the page history, which is undesirable in wikis where category pages contain significant amounts of text.

To save extra work, you may want to search well within your wiki before attempting to create a new category. The list of all categories can be found in “” in the “” box of the [sidebar](Help:Navigation#Sidebar).

## Linking to categories

To create a link to a category, use a leading colon as in:

      [[:``:NAME]]

For example, to link to “:Wiki policy", write `<nowiki>[[</nowikI>:{{ns:category}}:Wiki policy]]`, which will result in [:{{ns:category}}:Wiki policy](:{{ns:category}}:Wiki policy). Without the leading colon, it would add the page into the category.

If you want to display alternate text for the link, add that after a pipe as with other internal links (refer to <Help:Editing#Links>):

      [[:``:NAME|TEXT]]

[Redirects](Help:Redirect) to a category also need a leading colon to prevent the redirect pages from being included in the category.

*(Content from <https://fedoraproject.org/wiki/Help:Categories> under [CC BY SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/))*

[Wiki](Category:Documentation) [Category:Documentation for writing on the wiki](Category:Documentation for writing on the wiki) <Category:Help>
