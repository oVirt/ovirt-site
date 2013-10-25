---
title: Blogging and how it works
---

There is a blogging component under `source/blog` which makes it
pretty easy to do blog posts. There is automatic index and rss feed
generation etc. There is also a template for blog posts under layouts,
which you might want to have a look at if you are interested in how it
is done.

### Creating new posts

To create another post, run `middleman article "Post title here"` and
middleman will create a file with the correct name and metadata in the
appropriate location.

### Formatting posts

You can blog in any format middleman supports. By default, this is
markdown, with a `.md` file. However, you may edit `config.rb` and
change the extension to whatever you feel most comfortable with, such as
`.ad` for asciidoc, or `.mw` for mediawiki format.

If multiple people are blogging, then be sure to write `authors:` and the
name(s) of the person(s). Each person may use the formatting engine they wish,
and markdown will render the text based on the extension. (That is, if
something is foo.html.ad and the default is markdown, then the `.ad`
file will be rendered using asciidoctor whereas the rest of the `.md`
files will be markdown.)

Also, anything marked as `published: false` in the frontmatter
metadata (the block at the top) will not be published. Blog articles
dated in the future will also not be published, but will be included
in the site build once that date has passed. However, since this is a
static site generator, this will not magically happen by itself, but
you need to have some means to build and deploy the site when you wish to have
"future posts" become visible.
