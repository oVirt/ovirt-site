# How to contribute

Please join us! All content on ovirt.org is community-driven, and we welcome contributions!

## General guidelines
Make sure to follow the standard GitHub best practices:

* If you work offline in a text editor, fork the repository before you clone it and
keep your fork synced.
* Create topic branches and use meaningful titles in the branch names.
* Submit a pull request for every change, even if you are a site maintainer.

## Access the source files
You can access the source content in one of the following ways:

- Fork and clone this repository to your local machine. You can then use your favorite text editor and standard
Git commands to work on the files.
- From the website, scroll down to the bottom of the topic page that you want to edit and
click "Edit this page on GitHub". You can then edit the file directly in the GitHub editor.
- From this source repository directory, navigate to the file that you want to edit and click the Edit icon (hover text "Edit this file") at the top-right corner of the topic header.
You can then edit the file directly in the GitHub editor.

## Add new author
Author information is stored in `data/authors.yml`. If you write some content for the site, please add yourself to the list of authors.

## Add new content
All content in the website is written in Markdown. For information on formatting Markdown,
see [Markdown Basics](https://help.github.com/articles/markdown-basics/).

You can create a new topic file in one of the following ways:

- From your local Git repo folder, navigate to the relevant directory, create a new text file and
save it with the following naming convention: `<name>.md`

- From the GitHub repository, navigate to the relevant directory and click the New File button at the
top-right corner of the pane.

If you want to use an existing file as a template, click the Edit icon for this README and review
the headings, lists, and inline formatting used in this file.

Please note `{{ }}` curly braces are reserved for [templating](#Dynamic_pages), but you can escape in between `{% raw %}` and `{% endraw %}`.

### Page metadata
Additional metadata can be provided to each page by inserting block of following format at the beginning of the
document (called frontmatter):

```markdown

---
key: value
---

```

For example:


```markdown

---
title: Download
authors: gshereme,sandrobonazzola
---

```

### Page layout

The content you write is wrapped with a header and footer to display the logo, navbar and so on. This is what you get with the default `application` layout but we have some variant for specific cases and it is posible to define more in `source/_layouts`.

Pages are associated with a layout depending on their path in the Jekyll configuration file (`_config.yml`) but it is possible to override for a specific page using a `layout` entry in the frontmatter. Some special pages might not need any layout and in this case specifying `layout: null` will render the content of the page only without any wrapping.

### Dynamic pages

Pages are transformed depending on their format (markdown…), then a templating langage, [Liquid](https://shopify.github.io/liquid/), is used to allow some programming (variables, conditionals, loop…). Special variables like `site` and `page` are available to access frontmatter and site data.

If this is not sufficient then you may use HAML Ruby blocks. The Liquid special variables are available in HAML includes but *not* pages. They can be used identically as in Liquid. To make an include you need to create your HAML content in `source/_includes/<include>.haml` and reference if in your page using: `{% haml <include>.haml %}` (with <include> a name of your choice).

Please note ERB is not supported, use HAML with Ruby block instead

If access to Jekyll internals are needed (please avoid if possible), then the Jekyll `site` object can be found using `Jekyll.sites.first`; this is the raw Ruby object, not a Liquid wrapper, so you have access to all methods to control (or break if not careful) the whole site. Beware some methods like `html_pages` are Liquid extensions and are not accessible directly with this method.

In any case you can access the list of all pages using `site.pages`, filter them, loop over them, access their properties and content, so you should never need to access the filesystem directly; the filesystem path is anyway not always a good representation of the final URL. This is also better for security and build performance.

## Test your changes locally
If you edit any file type other than MD, for example HAML, YAML, or CSS, deploy the site locally
and test your changes.

For simple changes, you can try the Jekyll hot reload server, but note that it doesn't understand .htaccess
and mod_redirect rules that we use on the production apache server.


Run:
```
rvm use 2.5
./setup.sh && ./run-server.sh
```

If the site builds successfully, you will see this message:
The Jekyll web server is standing watch at http://\[address\]:4000
(the exact URL is given on the terminal when Jekyll is ready)

For complex changes, test with a local apache. Make sure apache is configured to allow `.htaccess` files by replacing
`AllowOverride None` with `AllowOverride None` in `httpd.conf`.

Run:
```
rvm use 2.5
# clean the build dir if it exists
rm -rf _site
bundle exec jekyll b
# copy all built content into the apache root
sudo rsync -av _site/ /var/www/html/
```

## Submit your changes
when you finish creating or editing content, commit your changes to the branch and submit a
pull request for review. Fill out the commit template. The commit message should include a detailed
description of the changes and as much context as possible.

NOTE: Make sure to submit a pull request even if you have commit rights to the repository, to ensure
consistent review and collaboration practices.

After your pull request is merged, the website auto-deploys and you can see the published changes
within 10-15 minutes.

## Report problems or make suggestions
If you find a problem with the content, with the website, or have suggestions for new content but
unsure how to proceed, simply [submit an issue here](https://github.com/oVirt/ovirt-site/issues/new).

## Still need help?
If you have any other questions, simply [submit an issue here](https://github.com/oVirt/ovirt-site/issues/new) and provide as much detail as possible.
