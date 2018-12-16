# How to contribute

All content on this website is community-driven, and we welcome contributions!

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
Minimalistic profiles of the author's are stored in `data/authors.yml`. Add yourself to this list,
if you want to use a nickname or an avatar.

## Add new content

All content in the website is written in Markdown. For information on formatting Markdown,
see [Markdown Basics](https://help.github.com/articles/markdown-basics/).

You can create a new topic file in one of the following ways:

- From your local Git repo folder, navigate to the relevant directory, create a new text file and
save it with the following naming convention: `<name>.html.md`

- From the GitHub repository, navigate to the relevant directory and click the New File button at the
top-right corner of the pane.

If you want to use an existing file as a template, click the Edit icon for this README and review
the headings, lists, and inline formatting used in this file.

### Page metadata

Additional metadata can be provided to each page by inserting block of following format at the beginning of the
document:

```markdown

---
key: value
---

```

For example:


```markdown

---
title: Virtio RNG Enhancements
feature_name: Virtio RNG
feature_modules: virtio
feature_status: WIP
---

```

## Add a new blog post

If you have an idea for a blog post, we'd love to help you publish it. Follow the steps to access
the source files and add new content, and when you submit the pull request the community team will
provide editorial review, so don't worry if you are unsure of your writing skills!

NOTE: Blog posts contain additional metadata and naming conventions that Middleman uses to accurately
sort and display the content. To ensure consistent formatting, you can
use [the first blog post](https://github.com/oVirt/ovirt-site/blob/master/source/blog/2015-11-30-welcome-to-new-ovirt-site.html.md) source
file name and header as a template.

## Update existing content

To modify incorrect, obsolete, or outdated information, you can edit the topic yourself and submit a
pull request. The pull request will be reviewed by contributors with commit rights, and if it is
accepted it will be merged to the website.

To edit content files, follow the steps in [Access the source files](#access-the-source-files) and
edit the file.

## Test your changes locally

If you edit any file type other than MD, for example HAML, YAML, or CSS, deploy the site locally
and test your changes.

For simple changes, you can try the Middleman hot reload server, but note that it doesn't understand .htaccess
and mod_redirect rules that we use on the production apache server.

**Note: the latest version of Ruby crashes when trying to start the server. Use Ruby 2.1 with the help of rvm.**

Run:
```
rvm use 2.1
./setup.sh && ./run-server.sh
```

or

```
sudo ./docker-setup.sh
sudo ./docker-run.sh
```

If the site builds successfully, you will see this message:
The Middleman is standing watch at http://\[address\]:4567

For complex changes, test with a local apache. Make sure apache is configured to allow `.htaccess` files by replacing
`AllowOverride None` with `AllowOverride None` in `httpd.conf`.

Run:
```
rvm use 2.1
# clean the build dir if it exists
rm -rf build
bundle exec middleman build --verbose
# copy all built content into the apache root
sudo rsync -av build/ /var/www/html/
```


## Submit your changes

when you finish creating or editing content, commit your changes to the branch and submit a
pull request for review. The commit message should include a detailed description of the changes
and as much context as possible.

NOTE: Make sure to submit a pull request even if you have commit rights to the repository, to ensure
consistent review and collaboration practices.

After your pull request is merged, the website auto-deploys and you can see the published changes
within 10-15 minutes.

## Report problems or make suggestions

If you find a problem with the content, with the website, or have suggestions for new content but
unsure how to proceed, you can create a GitHub issue to voice your request or question. All
issues are reviewed by the community team and triaged according to severity, priority, and complexity.

To open a GitHub issue, navigate to the GitHub repo website (you are here!) and click the Issues tab
in the top navigation bar of the repo. Make sure to search the issues list before you create a new
issue, as other contributors might have already reported similar issues.

## Still need help?

If you have any questions that this README did not answer, you can send us an email at community@ovirt.org
and we will do our best to help you get started.
