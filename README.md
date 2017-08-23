# oVirt.org Project Website

Welcome to the oVirt community website! This site is the home for information about the project, the community, and everything you need to get started with oVirt. 

This is the source repository for the website, and the home of all documentation, community content, and release management content. 

## How this repository is organized

All of the actual content (Markdown files) are organized hierarchically in the source directory. The other directories contain website config files, stylesheets, Ruby gems for deployment, and other files that should not be edited unless you would like to join our Middleman infra team.

NOTE: This website is a fork of the [Middleman-Springboard](https://github.com/OSAS/middleman-springboard) template. If you wish to propose a change or fix to config files or any files other than Markdown, please create an issue and the infra team will review the proposal accordingly.

### Root directory (You Are Here!)
* data/ - Submodule that pulls oVirt-related events from another GitHub repo
* lib/ - Ruby scripts for Middleman
* **source/** - All content for the website
* This README, Travis config files, misc Gem files, and other Middleman scripts

### Source directory (here be content!)
* admin/ - Website config files
* **blog/** - Blog posts
* **community/** - Community-focused content, such as activities, user stories, governance, and licensing
* **develop/** - Developer-focused content, such as release management, feature pages, sub-projects, and a developer guide
* **documentation/** - User-focused content, including installation guide, user guide, security guide, and how-to articles
* **download/** - How to get started with oVirt, published as the Download page in the website
* events/ - More config files for event widget
* fonts/ - Font files
* images/, javascripts/, layouts/, site/, stylesheets - Various website config files
* Haml files used for building and deploying the website

## How to contribute

All content on this website is community-driven, and we welcome contributions! 

Please make sure to work in topic branches and use the pull request process to propose changes. Every change you make to the content will undergo peer-review before it's accepted and merged into the master branch.

### Access the source files

You can access the source content in one of the following ways:

- Fork or clone this repo to your local machine. You can then use your favorite text editor and standard Git commands to work on the files.
- To deploy it locally, execute ./setup.sh once, and then ./run-server.sh to locally run the website.
- From the deployed website, scroll down to the bottom of the topic page and click "Edit this page on GitHub". You can then edit the file directly in the GitHub editor.
- From this source repo, click the Edit icon (hover text "Edit this file") at the top-right corner of the topic header. You can then edit the file directly in the GitHub editor.

### Add new content

All content in the website is written in Markdown. For information on formatting Markdown, see [Markdown Basics](https://help.github.com/articles/markdown-basics/).

You can create a new topic file in one of the following ways:

- From your local Git repo folder, navigate to the relevant directory, create a new text file and save it with the following naming convention: `<name>.html.md`

- From the GitHub repo, navigate to the relevant directory and click the New File button at the top-right corner of the pane.

If you want to use an existing file as a template, click the Edit icon for this README and review the headings, lists, and inline formatting used in this file.

### Add a new blog post

If you have an idea for a blog post, we'd love to help you publish it. Follow the steps to access the source files and add new content, and when you submit the pull request the community team will provide editorial review, so don't worry if you are unsure of your writing skills!

NOTE: Blog posts contain additional metadata and naming conventions that Middleman uses to accurately sort and display the content. To ensure consistent formatting, you can use [the first blog post](https://github.com/oVirt/ovirt-site/blob/master/source/blog/2015-11-30-welcome-to-new-ovirt-site.html.md) source file name and header as a template.

### Update existing content

To modify incorrect, obsolete, or outdated information, you can edit the topic yourself and submit a pull request. The pull request will be reviewed by contributors with commit rights, and if it is accepted it will be merged to the website.

To edit content files, follow the steps in [Access the source files](#access-the-source-files) and edit the file.

IMPORTANT: Some content was converted from legacy MediaWiki and contains a special header used for auto-redirects. If you edit a legacy file, do not modify or remove this header.

### Submit your changes

when you finish creating or editing content, commit your changes to a **new branch** and submit a pull request for review. The commit message should include a detailed description of the changes and as much context as possible. 

NOTE: Make sure to submit a pull request even if you have commit rights to the repo, to ensure consistent review and collaboration practices. 

After your pull request is merged, the website auto-deploys and you can see the published changes within 10-15 minutes. 

### Report problems or make suggestions

If you find a problem with the content, with the website, or have suggestions for new content but unsure how to proceed, you can create a GitHub issue to voice your request or question. All issues are reviewed by the community team and triaged according to severity, priority, and complexity.

To open a GitHub issue, navigate to the GitHub repo website (you are here!) and click the Issues tab in the top navigation bar of the repo. Make sure to search the issues list before you create a new issue, as other contributors might have already reported similar issues.

## Still need help?

If you have any questions that this README did not answer, you can send us an email at community@ovirt.org and we will do our best to help you get started.
