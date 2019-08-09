---
title: Wiki rules and etiquette
category: help
authors: daejohnson, quaid
---

<!-- TODO: [Mikey] Update this page for contributing to content on GitHub -->

# Wiki rules and etiquette

This page sets out general guidelines for the oVirt project wiki.

There are a few simple points you should follow as you make changes to the wiki. Below are some examples. In general, be courteous and use common sense. Defying these guidelines and causing problems are a good way to get your edit privileges revoked. If you have questions, you can ask on #ovirt on [OFTC](http://oftc.net/) or [arch@ovirt.org](https://lists.ovirt.org/archives/list/arch).@ovirt.org/

## Introduce yourself

Before you start editing any page, kindly introduce yourself by adding your information to your wiki page. After you have registered your name in the wiki, you automatically have a personal wiki page located at `<nowiki>http://ovirt.org/wiki/User:</nowiki><username>`, where `<username>` is replaced by your oVirt wiki account name. You can also easily get to your wiki page by clicking your username in the top right-hand corner of each page of the wiki.

For examples, take a look at [<http://ovirt.org/w/index.php?title=Special%3AAllpages&from>=&namespace=2 some wiki pages of our contributors]. *This link is broken, but I dont' know where to point it. --daej (daejohnson)*

On your user page, make sure you mention at least your email address and, if you are on IRC often, your IRC nick and channel(s) you are often in.

## Always watch pages that you create or edit

It is important that you follow changes to pages you create or edit, so you can coordinate with others working in the wiki content. Wiki editors usually add notes to the pages to convey information to each other as part of working together, and it helps to keep track of these changes.

You can find the **watch** link in the tab bar at the top of a page when you are logged in.

You can set all pages that you create or edit to automatically be put in your watchlist with this procedure:

1.  Go to <Special:Preferences>.
2.  On the *Watchlist* tab under *Advanced options* put a checkmark next to these items:
    -   *Add pages I edit to my watchlist*
    -   *Add pages I move to my watchlist*
    -   *Add pages I create to my watchlist*

## Be Bold

Be **bold** while editing changes. Wiki changes are tracked and can be reverted when necessary. This doesn't mean you should be reckless, especially when making large changes to key documents.

For more information on being **bold**, take a look at the [be **bold** editing guideline on Wikipedia](wikipedia:Wikipedia:Be_bold).

## Avoid unnecessary edits of pages that discuss legal issues

These pages have been carefully written, and the words chosen carefully. When changing these documents, it is usually best to ask for review before applying changes. You can contact the [oVirt project board](/community/about/contact/) for assistance.

## Be careful when editing key guides or pages

Large and important guides are generally managed by a specific individual or small group. It is best to work with them when you feel that changes are needed.

Important pages, such as the [Main Page](/), are the first thing that many visitors see. Changes to such pages should generally be left to experienced contributors. If you feel that something on such a page should be altered, bring the issue to the [arch@ovirt.org](/community/about/contact/) mailing list for discussion.

## Do not edit pages just to edit pages

Senseless edits should be avoided. Making an alteration to a page just to put your name in the edit log is unacceptable. There are plenty of pages (most of them, in fact) that have real errors that can be corrected. Instead of making pointless edits, such as removing or adding whitespace or changing links from ovirt.org to www.ovirt.org (the former is preferred), try finding errors in spelling, grammar, or punctuation that can be corrected. Also, when correcting a small error, mark "This is a minor edit" using the appropriate checkbox before you save it.

## Avoid renaming pages or moving content without coordination

Wiki pages are generally referred to and linked to from various other locations. It is important that you coordinate with the appropriate groups before moving content or renaming existing pages. It would be better to avoid doing that without strong rationale. If you wish to discuss moving a particular item, bring your questions to the [arch@ovirt.org](/community/about/contact/) mailing list.

## Deleting Pages

Wiki pages that are no longer needed can be tagged for deletion by adding {% raw %}{{Delete|Reason}}{% endraw %} to the beginning of the page, this gives Wiki Administrators the ability to ensure that important or archivable content is not lost.

## Sign your attachments

When you attach a file to a wiki page, you should create a detached signature with your GPG key. Some file formats, such as RPM packages, support GPG keys, in which case you do not need to create a detached signature -- a signature in the file will be enough. A detached signature can be attached to the page alongside the original attachment, or can be included in the page itself.

GPG signatures allow others who download your file to verify that it came from you and has not been modified or corrupted. They do not violate your privacy in any way, they simply allow others to have confidence in the origin of your files.

Images and simple documents are safe to leave without a signature, but there would be no harm in adding one anyway to verify that you were the author.

## Review your changes for errors

Whether you are a skilled writer, or your English skills are not strong, invite someone else to review. Well-written documents are important to oVirt's image. Even the best writers are prone to typos or other errors. Take a moment to review your changes to catch small errors. Use the **Show preview** button when editing a page to check your syntax.

## oVirt is a community

When writing content, for the wiki or elsewhere, remember that oVirt is a community. *We* operate as one, unified group, moving towards common goals. *We* do not need to distinguish one group or class against another. For example, there is no need to distinguish between contributors who work for a company and those who do not. All contributors are part of the same community. There will be cases where classification is necessary, but it can be avoided otherwise.

## If you aren't sure about something, feel free to ask

Other community members will be happy to assist you. The #ovirt channel on [OFTC](http://oftc.net/) is the perfect place to discuss the wiki.

## Watch your pages, and other ones, too

Two details make a Wiki successful as an open content collaboration tool. First is being able to watch content you are responsible for, to make certain it stays true to its mission. Second is being able to watch other content develop, grow, and occasionally need your help.

To watch any page on the wiki, after logging in, click the **watch** link in the tab bar at the top of a page. It should change to **unwatch** after it has finished. If a page has **unwatch** at the top, you are already watching that page. You can click **unwatch** to unwatch a page.

To receive emails for every edit, go to **my preferences (Preferences)** (at the top of the page by your name) and make sure to check the appropriate boxes in the **User profile** tab, under **Email**.

#### Using Special:Watchlist

<Special:Watchlist> (available by clicking **my watchlist** at the top of each page when you are logged in) displays pages you are currently watching. For more information on how to use this special page, refer to [the manual page at Mediawiki.org](http://www.mediawiki.org/wiki/Manual:Watchlist).

## Summarize your changes (aka commit log message) -- this is the rule

We all need to be able to quickly glance at a change and know the substance of it. A full diff is not always available. You must supply a summary of your change (*Summary:* field when editing). This is akin to a changelog message. Explain what you did and why, as well as other useful links and details.

If you choose to not put in a summary, it should be the rare exception. One reason is when doing a minor edit. In that case, be sure to check *This is a minor edit* when saving.

*(Content from <https://fedoraproject.org/wiki/Help:Wiki_rules_and_etiquette> under [CC BY SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/))*

