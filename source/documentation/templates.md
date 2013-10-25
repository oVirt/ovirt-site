---
title: Template Structure
---

Middleman uses templates to define page structure, and you can split
commonly used parts using "partials", which are snippets of markup
that are shared among many pages. Good examples would be a page
header, navigation and footer that are common in all different
templates. Templates and partials are in in the layouts folder which
for now is `source/layouts`. You can add your own if you wish, using
HAML or any other supported markup.

Templates can also inherit other templates using the `wrap_layout`
method. For example of this see `source/layouts/docs.html-haml`, which
wraps itself into the default layout but adds a custom navigation menu
to the left side, like on this document you are reading now.

### Bootstrap Crash Course

Bootstrap itself has [excellent documentation](http://getbootstrap.com/), which 
you should refer to, if you wish to leverage it. However, here are the few most 
useful concepts and components:

#### Responsiveness

Bootstrap makes it relatively easy to create layouts and designs that
work nicely accross a variety of devices and screen sizes. With little
consideration one site can serve them all.

#### Container

Basic _responsive_ building block, which means it centers the content
to predefined width that adapts to the device screen width. 

If you
wish to have a full width block -- like the "Getting Started" section
on the front page -- you can specify "no_container: true" in the
page's front matter. Then wrap the content in containers yourself, but
for the special block, create div with custom class and place a
.container immediately within. Then you can style the div with css. A
good example again is the main landing page, `source/index.html`

#### Grids

Grids also adapt to screen width, and thus make it easy to make the same layout work for both larger screens as well as tablets and mobile devices.
