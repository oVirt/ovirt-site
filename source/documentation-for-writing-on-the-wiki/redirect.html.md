---
title: Redirect
category: documentation-for-writing-on-the-wiki
authors: quaid
wiki_category: Documentation for writing on the wiki
wiki_title: Help:Redirect
wiki_revision_count: 1
wiki_last_updated: 2011-12-13
---

# Redirect

Redirects are used to forward users from one page name to another. They can be useful if a particular article is referred to by multiple names, or has alternative punctuation, capitalization or spellings.

## Creating a redirect

You may start a new page with the name you want to direct from (refer to <Help:Wiki_structure#Page_naming>). You can also use an existing page that you are making inactive as a page by going to that page and using the "edit" tab at the top. In either case, you will be inserting the following code at the very first text position of the Edit window for the page:

      #REDIRECT [[`*`pagename`*`]]

where *pagename* is the name of the destination page. The word "redirect" is not case-sensitive, but there must be no space between the "#" symbol. Any text before the code will disable the code and prevent a redirect. Any text or regular content code after the redirect code will be ignored (and should be deleted from an existing page). However, to put or keep the current page name listed in a Category, the usual tag for that category is entered or kept on a line after the redirect code entry.

You should use the 'preview' button below the Edit window, or Alt-P, to check that you have entered the correct destination page name. The preview page will not look like the resulting redirect page, it will look like a numbered list, with the destination page in blue:

`1. REDIRECT  `<span style="color:blue">*`pagename`*</span>

If the *pagename* as you typed it is not a valid page, it will show in red. Until there is a valid destination page, you should not make the redirect.

## Viewing a redirect

After making a redirect at a page, you can no longer get to that page by using its name or by any link using that name; and they do not show up in wiki search results, either. However, near the top of the destination page, a notice that you have been forwarded appears, with the source pagename as an active link to it. Click this to get back to the redirected page, showing the large bent arrow symbol and the destination for the redirect.

By doing this, you can do all the things that any wiki page allows. You can go to the associated discussion page to discuss the redirect. You can view the history of the page, including a record of the redirect. You can edit the page if the redirect is wrong, and you can revert to an older version to remove the redirect.

## Deleting a redirect

There's generally no need to delete redirects. They do not occupy a significant amount of database space. If a page name is vaguely meaningful, there's no harm (and some benefit) in having it as a redirect to the more relevant or current page.

## Double redirects

A double redirect is a page redirecting to a page which is itself a redirect, and it will not work. Instead, people will be presented with a view of the next redirect page. This is a deliberate restriction, partly to prevent infinite loops, and partly to keep things simple.

However, you could look out for double redirects and eliminate them, by changing them to be 1-step redirects instead. You are most likely to need to do this after a significant [page move](Help:Moving a page). Use the "what links here" toolbox link to find double redirects to a particular page, or use <Special:DoubleRedirects> to find them throughout the whole wiki.

## A redirect to a page in the category namespace

To prevent a page that redirects to a category from appearing in the category, precede the word "Category" with a colon:

      #REDIRECT [[:Category:Glossary]]

*(Content from <https://fedoraproject.org/wiki/Help:Redirect> under [CC BY SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/))*

[Category:Documentation for writing on the wiki](Category:Documentation for writing on the wiki) <Category:Help>
