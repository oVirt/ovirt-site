---
title: Welcome to the new oVirt.org website!
author: mariel
tags: community, news, documentation, infrastructure
date: 2015-11-30 18:17:01 CET
---

As part of our efforts to upgrade the ovirt.org website and improve the community experience, we migrated the oVirt website from a MediaWiki site to a static site, authored in [Markdown](https://help.github.com/articles/basic-writing-and-formatting-syntax/) and published with [Middleman](https://middlemanapp.com/). This was a major project that took more than 6 months and involved many contributors from all aspects of the project. 

I'd like to take this opportunity to thank all the people who were involved with this migration, from content reviewers to UX designers and Website admins who gave their time and brain power to make this happen. 

The old MediaWiki site is [still available in read-only](http://old.ovirt.org/Home), and will be taken offline on **March 1, 2016**. This is to ensure that you can compare pages and review migrated content.

## What's new?

The new Website is full of improvements and enhancements, check out these highlights:

- Source content is now formatted in Markdown instead of MediaWiki. This means that you can create and edit documentation, blog posts, and feature pages with the same Markdown syntax you know.
- The Website is deployed with Middleman and stored on GitHub. This means that you can make changes to content with the same GitHub contribution workflow that you know (fork, clone, edit, commit, submit pull request). We even have an "Edit this page on GitHub" link at the bottom of every page!
- New layout and design, from breadcrumbs to sidebards and an upgraded landing page.
- Hierarchical content structure. This means that instead of flat Wiki-style files, the deployed Website reflects an organized source repo with content sorted into directories and sub-directories.
- Official oVirt blog! This first post marks the beginning of our new blog, and we welcome contributions. This means that if you solved a problem with oVirt, want to share your oVirt story, or describe a cool integration, you can submit a blog post and we will provide editorial reviews and help publish your posts.
- Standardized contribution process. The GitHub repo now includes a [README.md](https://github.com/oVirt/ovirt-site/blob/master/README.md) file that you can use to learn about how to add and edit content on the website. We welcome pull requests!


Known Issues
============

Despite our best efforts, there are still a few kinks with the new website that you should be aware of:

- Attempting to navigate to ovirt.org (without www.) leads to a redirect loop. We have a ticket open with OpenShift, our hosting service to fix this.
- Only http is available. We also have a ticket with OpenShift to add SSL and enable https.
- Home page and Download page are still being upgraded by our UX team, expect some cool new changes soon!
- Feature pages look-and-feel is still under construction. You can still edit and push feature pages as usual.

What's Next
===========

Even though the Website is live, the work is hardly over. We'd like to ask for your help in:

- Reviewing content for anything obsolete or outdated; each page in the new website includes a header toolbar with metadata from the original wiki page for your convenience
- Submitting blog posts or any other content that you wish to share with the oVirt community
- Reporting bugs and proposing enhancements, for example broken links or missing pages

We hope you will enjoy the new oVirt Website, looking forward to your feedback and contributions!
