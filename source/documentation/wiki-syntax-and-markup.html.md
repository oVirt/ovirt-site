---
title: Wiki syntax and markup
category: documentation
authors: quaid
wiki_category: Documentation
wiki_title: Help:Wiki syntax and markup
wiki_revision_count: 2
wiki_last_updated: 2011-12-13
wiki_conversion_fallback: true
wiki_warnings: conversion-fallback
---

# Wiki syntax and markup

If you need help with syntax that is not listed here, the [Mediawiki Help](http://www.mediawiki.org/wiki/Help:Contents) should contain it. There is also a handy [reference card](http://meta.wikimedia.org/wiki/Help:Reference_card) image.

## Basic syntax

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">What you type</th>
<th align="left">What it looks like</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><pre><code>bold text</code></pre></td>
<td align="left"><strong>bold text</strong></td>
</tr>
<tr class="even">
<td align="left"><pre><code>italics</code></pre></td>
<td align="left"><em>italics</em></td>
</tr>
<tr class="odd">
<td align="left"><pre><code>bold italics</code></pre></td>
<td align="left"><em><strong>bold italics</strong></em></td>
</tr>
<tr class="even">
<td align="left"><pre><code>Monospace text</code></pre></td>
<td align="left"><code>Monospace text</code></td>
</tr>
</tbody>
</table>

## Lists

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">What you type</th>
<th align="left">What it looks like</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><pre><code>* A list item
Another list itemOh joy, more list items!</code></pre></td>
<td align="left"><ul>
<li>A list item</li>
<li>Another list item
<ul>
<li>Oh joy, more list items!</li>
</ul></li>
</ul></td>
</tr>
<tr class="even">
<td align="left"><pre><code># A numbered item

Another numbered item
Sub items
More sub items

Third numbered item</code></pre></td>
<td align="left"><ol>
<li>A numbered item</li>
<li>Another numbered item
<ol>
<li>Sub items</li>
<li>More sub items</li>
</ol></li>
<li>Third numbered item</li>
</ol></td>
</tr>
<tr class="odd">
<td align="left"><pre><code>* An unordered item...

With a sub-list that is ordered
More steps

Back to the first listAnother ordered listWith its own sub point

</code></pre></td>
<td align="left"><ul>
<li>An unordered item...
<ol>
<li>With a sub-list that is ordered</li>
<li>More steps</li>
</ol></li>
<li>Back to the first list
<ol>
<li>Another ordered list
<ul>
<li>With its own sub point</li>
</ul></li>
</ol></li>
</ul></td>
</tr>
</tbody>
</table>

Use HTML markup for numbered lists that include preformatted <pre> blocks, such as code or screen examples. Such <pre> blocks, when used in a numbered list using wiki markup, causes the numbering to restart. Instead, use the <ol> ordered list HTML markup to create the list.

## Links

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">What you type</th>
<th align="left">What it looks like</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><pre><code>Visit [[Documentation]] to learn more about oVirt&#39;s documentation.</code></pre></td>
<td align="left">Visit <a href="Documentation" class="uri">Documentation</a> to learn more about oVirt's documentation.</td>
</tr>
<tr class="even">
<td align="left"><pre><code>Our [[Infrastructure|Infrastructure team]] works on resources for oVirt contributors.</code></pre></td>
<td align="left">Our <a href="Infrastructure">Infrastructure team</a> works on resources for oVirt contributors.</td>
</tr>
<tr class="odd">
<td align="left"><pre><code>Refer to [[Node_Building#From_Git]] for instructions on building Node from git.</code></pre></td>
<td align="left">Refer to <a href="Node_Building#From_Git" class="uri">Node_Building#From_Git</a> for instructions on building Node from git.</td>
</tr>
<tr class="even">
<td align="left"><pre><code>[[The weather in London]] is a page that doesn&#39;t exist yet.</code></pre></td>
<td align="left"><a href="The%20weather%20in%20London">The weather in London</a> is a page that doesn't exist yet.</td>
</tr>
<tr class="odd">
<td align="left"><pre><code>http://fedoraproject.org/</code></pre></td>
<td align="left"><a href="http://fedoraproject.org/" class="uri">http://fedoraproject.org/</a></td>
</tr>
<tr class="even">
<td align="left"><pre><code>Here are some sites:
[http://www.deviantart.com]
[http://www.flickr.com]</code></pre></td>
<td align="left">Here are some sites: <a href="http://www.deviantart.com" class="uri">http://www.deviantart.com</a> <a href="http://www.flickr.com" class="uri">http://www.flickr.com</a></td>
</tr>
<tr class="odd">
<td align="left"><pre><code>[http://ovirt.org Our home page] is full of interesting information.</code></pre></td>
<td align="left"><a href="http://ovirt.org">Our home page</a> is full of interesting information.</td>
</tr>
<tr class="even">
<td align="left"><pre><code>Use a &#39;:&#39; in the link to link to an [[:File:More cases.png|image]].</code></pre></td>
<td align="left">Use a ':' in the link to link to an <a href=":File:More%20cases.png">image</a>.</td>
</tr>
<tr class="odd">
<td align="left"><pre><code>The [[:Category:Documentation]] lists end-user documentation.</code></pre></td>
<td align="left">The <a href=":Category:Documentation" class="uri">:Category:Documentation</a> lists end-user documentation.</td>
</tr>
<tr class="even">
<td align="left"><pre><code>The [[Category:Documentation]] link puts this page in the listed category; the link
appears automatically on the bottom of the page and not inline.</code></pre></td>
<td align="left">The [[Category:Documentation]] link puts this page in the listed category; the link appears automatically on the bottom of the page and not inline.</td>
</tr>
</tbody>
</table>

There are two ways to use the Category links|Be sure to use the ':' before the word Category when you intend to link to a category page. Omit the ':' when the page is supposed to be in that category. Refer to the examples above and [Help:Categories](help:Categories).

## Tables

Tables should be used sparingly and only when necessary.

For more advanced table usage, read up on [Mediawiki.org's page on tables](http://www.mediawiki.org/wiki/Help:Tables).

<table>
<colgroup>
<col width="50%" />
<col width="50%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">What you want</th>
<th align="left">How to get it</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Start a table</td>
<td align="left"><pre><code>{|</code></pre></td>
</tr>
<tr class="even">
<td align="left">Table header</td>
<td align="left"><pre><code>! Column 1 !! Column 2 !! Column 3</code></pre></td>
</tr>
<tr class="odd">
<td align="left">Table row</td>
<td align="left"><pre><code>|-</code></pre></td>
</tr>
<tr class="even">
<td align="left">Table data</td>
<td align="left"><pre><code>| Cell 1 || Cell 2 || Cell 3</code></pre></td>
</tr>
<tr class="odd">
<td align="left">End a table</td>
<td align="left"><pre><code>|}</code></pre></td>
</tr>
</tbody>
</table>

## Writing example commands

Example commands are one or more commands set apart from the body of the explanation. Do not use prompt symbols or any other content that shows machine name, user, directory, etc. (which are details set in the $PS1 environment variable.)

Enclose any example command in ``

tags:

    su -c "yum install awesome-application"
    </pre>

    Enter the root password when prompted.

Which produces:

    su -c "yum install awesome-application"

Enter the `root` password when prompted.

***Note:**Command examples and root|Many commands require `root` privileges. The reader should not be logged into their system as `root`, so you must specify (consistently) either `su -c`, `su -`, or `sudo` when explaining such commands.*

If the command requires elements to be quoted, nesting should be `" ' ' "`, with the single quote marks surrounded by one containing set of double quote marks. For example:

    su -c "command -o 'Some Text' -file 'More text' foo/bar"

If you need to have a series of commands or `su -c` is not responding as expected, have the user switch to `root` and warn the user to return to a normal user shell afterward.

    su -
    Password:
    service food stop
    cp /etc/foo.d/foo.conf /etc/foo.d/foo.conf.backup
    vi /etc/foo.d/foo.conf
    food --test-config
    ...
    service food start
    exit

### Example command output

When the example shows a command as part of showing the output to the screen, you may use a command prompt to clarify commands and output.

    $ su -c "ls -l /root"
    Password: 
    total 148
    -rw------- 1 root root  1961 2007-09-21 02:46 anaconda-ks.cfg
    -rw-r--r-- 1 root root 46725 2007-09-21 02:46 install.log
    -rw-r--r-- 1 root root  6079 2007-09-21 02:42 install.log.syslog
    -rw-r--r-- 1 root root  3699 2008-07-28 17:24 scsrun.log
    -rw-r--r-- 1 root root 45038 2008-01-10 10:21 upgrade.log
    -rw-r--r-- 1 root root  1317 2008-01-10 10:20 upgrade.log.syslog

## Quick tips

### Structure of a wiki page

This section describes the common structure of a wiki page. Follow these guidelines for every wiki page. Pages that are templates of standard content that are drawn into other pages may have a different structure.

***NOTE:** The header 1 = Page title = is defined by the page title. When making new or migrating pages, either re-nest or re-structure the page to have* only *header 2 and below.*****

*   The title of the page is a first-level header. It is created automatically from the page title.
*   Sections are created using the equals symbols in pairs:

         Header 2

         Header 3

         Header 4

         Don't do this, 5 levels of nesting means you need a new page or three

*   The table of contents is automatically created and populated when the page grows big enough. You may use the markup to remove the table of contents. The _TOC_ markup can be used to place the table of contents in a specific location in the document.
*   Anchors to sections are automatically created, with specific symbols used in place of punctuation and spaces:

        This page ==> This_page
        This, that, and the other page ==> This%2C_that%2C_and_the_other_page

*TIP*You can use .2C instead of %2C for anchors|The substitute of '.' for '%' works for anchors against a specific section.

### Learn by example

Among the better ways to learn how to edit the wiki is reviewing the code of existing pages. This is very easy to do:

1.  Find a page whose source you would like to view.
2.  Click on either the *edit* or *view source* tab at the top of the page.

The wiki will display the plaintext form of that page. This is particularly valuable for learning some of the clever tricks used by wiki editors ahead of you. Those clever tricks are valuable, as they allow you to do unique, interesting, and powerful things you might not have thought were possible. You might try this on pages such as [Main Page](Main%20Page) (but please don't make drastic or unwanted edits to this page!).

### Marking technical terms

Use the *code* markup (<code></code>) to mark the names of applications, files, directories, software packages, user accounts, and other words that have a specific technical meaning. This displays the marked words as `monospace`.

Use two single-quotes `([name of menu])` to mark the names of menu items and other elements of the graphical interface. This displays the marked words in *italic*.

<table>
<colgroup>
<col width="33%" />
<col width="33%" />
<col width="33%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Term</th>
<th align="left">Mark Up</th>
<th align="left">Formatted example</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Names of GUI applications</td>
<td align="left"><pre><code> boldface </code></pre></td>
<td align="left"><strong>Firefox</strong></td>
</tr>
<tr class="even">
<td align="left">Files, directories</td>
<td align="left"><pre><code> inline code tags </code></pre></td>
<td align="left"><code>/usr/bin/firefox</code></td>
</tr>
<tr class="odd">
<td align="left">Software packages</td>
<td align="left"><pre><code> package name </code></pre></td>
<td align="left"><code>vdsm-1.2.3</code></td>
</tr>
<tr class="even">
<td align="left">User accounts</td>
<td align="left"><pre><code> username </code></pre></td>
<td align="left"><code>username</code></td>
</tr>
<tr class="odd">
<td align="left">Other words that have a specific technical meaning</td>
<td align="left"><pre><code> technical term </code></pre></td>
<td align="left">... the class <code>org.ovirt.someJava.classname</code> ...</td>
</tr>
<tr class="even">
<td align="left">Graphical menus and menu items</td>
<td align="left"><pre><code> Menu name </code></pre></td>
<td align="left"><em>Applications &gt; Internet &gt; Firefox Web Browser</em></td>
</tr>
<tr class="odd">
<td align="left">Other GUI or WebUI interface element</td>
<td align="left"><pre><code> two single-ticks </code></pre></td>
<td align="left">... click the <em>Submit</em> button ...</td>
</tr>
<tr class="even">
<td align="left">Inline command and daemons</td>
<td align="left"><pre><code> command -option daemon</code></pre></td>
<td align="left">... run <code>ps -ef | grep httpd</code> to find the PIDs of the running <code>httpd</code> processes.</td>
</tr>
<tr class="odd">
<td align="left"><strong>Blocks</strong> of code, configuration files, etc.</td>
<td align="left"><pre><code> whitespace preserved </code></pre></td>
<td align="left"><pre><code>whitespace
    is preservered
  here</code></pre></td>
</tr>
<tr class="even">
<td align="left"><strong>Inline</strong> pieces of code, configuration files, etc.</td>
<td align="left"><pre><code> inline whitespace not preserved </code></pre></td>
<td align="left">... Next, modify the variables for <code>set()</code> in <code>/path/to/org/dev108/classname</code> ...</td>
</tr>
<tr class="odd">
<td align="left">First term, glossary term</td>
<td align="left"><pre><code> term </code></pre></td>
<td align="left">... <strong>Firefox</strong> is an example of a <em>graphical user interface</em> or <em>GUI</em>.</td>
</tr>
<tr class="even">
<td align="left">Keystrokes</td>
<td align="left"><pre><code> [Key] </code></pre></td>
<td align="left">Press the <strong>[Enter]</strong> key ...</td>
</tr>
</tbody>
</table>

For example:

    The thunderbird package installs the Mozilla Thunderbird
    e-mail application. To start Thunderbird, select:
      Applications > Internet > Thunderbird Email.

Which produces:

The `thunderbird` package installs the **Mozilla Thunderbird** e-mail application. To start **Thunderbird**, select: *Applications > Internet > Thunderbird Email*.

*(Content from <https://fedoraproject.org/wiki/Help:Wiki_syntax_and_markup> under [CC BY SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/))*
