---
title: Basic concepts, to get you started
---

We are building static web sites because it makes hosting them very
simple, they are lightweight from the webhosting point of view, and since
there is no code being evaluated or executed in the server side, there is
very little to worry about in terms of security holes, server software upgrades
and similar things once you deploy the site. It's all just HTML, CSS and images.
No PHP or other scripts, no databases. Very little to break. 

_What could possibly go wrong? :-)_

### Blocks to Play With

There are many useful things we take advantage of. This makes life much easier 
for us as web developers and we can concentrate more on the actual content and
design. Springboard gives us a good box of Legos&trade; to play with.

  * [HAML](http://haml.info/) is a nice language for generating html markup. It is
    not very well suited for content, but it works wonders for layouts and we also
    tend to use it for landing pages (like the frontpage) where you likely want
    to have layouts with grids and columns and such. It is awkward for actual
    content though. An example about HAML is `source/index.html.haml`

  * [Markdown](http://daringfireball.net/projects/markdown/), like mentioned, is much
    better suited for actual content, as the amount of markup is minimal, and stuff
    looks more or less like you had written a plain text document. This document,
    `source/documentation/index.md`, for example, is written in Markdown.

  * [SASS](http://sass-lang.com/) is a stylesheet language that makes it easy to
    author and maintain our stylesheets. Like background: $textcolor, and a zillion
    other useful things. Look into `source/stylesheets/*.sass` for examples. As you
    can see 

  * [Compass](http://compass-style.org/) works with Springboard / Middleman as well,
    giving you a lot of useful tools and shorthand ways to do cross-browser compatible
    design. Some stuff in `source/stylesheets/_application-custom.css.sass` uses compass
    helpers, but you can use them anywhere in your sass stylesheets.

  * [Bootstrap](http://getbootstrap.com/), the free and open source html/css front-end 
    framework from Twitter, Inc. is nice, customizable with sass variables, and gives 
    a lot of legos to play with. You can tweak the styles by editing 
    `source/stylesheets/_bootstrap-custom.css.

###