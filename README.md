# oVirt.org

Welcome to the oVirt website source repository. This repository contains the code and images for the website and documentation.

## How to contribute
Please join us! All content on ovirt.org is community-driven, and we welcome contributions!

## Found a bug or documentation issue?
To submit a bug or suggest a documentation fix/enhancement for a specific page, navigate to the page, and click "Report an issue on GitHub" in the page footer. If it is a more general problem, simply [submit an issue here](https://github.com/oVirt/ovirt-site/issues/new) and provide as much detail as possible.

## Edit the site
To edit a single page, navigate to the page, and click "Edit this page on GitHub" in the page footer. That will create a simple Pull Request where you can propose your changes.

You can also clone and fork the repository like any other GitHub project, if you are more comfortable with that.
See [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on building and testing the site locally.

See [MAINTAINING.md](MAINTAINING.md) for information about site maintainers.

See [README_ORGANIZATION.md](README_ORGANIZATION.md) for information about how the source code is organized.

Most of the content in the website is written in Markdown.
For information on formatting Markdown, see [Markdown Basics](https://help.github.com/articles/getting-started-with-writing-and-formatting-on-github/).

You can create a new file two ways:

- From your local Git repo folder, navigate to the relevant directory, create a new text file and save it with the following naming convention: `<name>.md`

- From the GitHub repo, navigate to the relevant directory and click the New File button at the top-right corner of the pane.

After you submit a PR to the ovirt-site reposiory, automation will verify your submission. If no error is found you'll see a green symbol and a text saying
"All checks have passed". You can inspect the generated website by downloading the site-without-markdown.zip file from the automation system.
In order to do so, click on the "Checks" tab within your PR and then click on "Website Tests" link on the left bar.
You can find "site-without-markdown" artifact at the bottom of the page.

Once downladed the zip file, in order to check how the website looks like you need to extract the archive and serve the extracted directory with a web server.
An easy way to do it is using python: `python3 -m http.server` from the web site directory. This won't provide a full replica of what will happen on the real website
because there are a few redirects provided via `.htaccess` that can be processed only using apache. If you can run an apache server on your system you can extract the
zip within `/var/www/html/` and serve it with your apache installation.


## Still need help?
If you have any other questions, simply [submit an issue here](https://github.com/oVirt/ovirt-site/issues/new) and provide as much detail as possible.
