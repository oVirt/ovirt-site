# How to maintain the oVirt site

If you are a maintainer (contributor with commit access), you can review and merge pull requests
and assign issues to other contributors.

This section describes the typical tasks and processes to follow as a maintainer.

IMPORTANT: Because maintainers have commit access to the repository, please fork and clone
the repository and work offline in a text editor on content that you want to edit or add yourself.
All contributions must follow the [general contribution guidelines](https://github.com/oVirt/ovirt-site/blob/master/CONTRIBUTING.md).

## List of current site maintainers

### General technical content, release management

* Doron Fediuck
* Sandro Bonazzola
* Greg Sheremeta
* Nir Soffer

### Site infra and Middleman

* Marc Dequenes (Duck)
* Greg Sheremeta

### Non-technical content, community, blog posts, legal

* Brian Proffit

## Previous maintainers

* Yaniv Kaul
* Allon Mureinik (storage)
* Marcin Mirecki (networking)
* Eyal Edri (infra)
* Garrett LeSage
* Jason Brooks
* Michael Scherer


## Triaging issues and PRs

* Currently there is no single person to triage issues and PRs. This means that each maintainer needs
to turn on notifications for new issues and PRs or regularly review the lists.
* Assign issues and PRs to yourselves based on the topic or component. If you see that an issue or PR remains unassigned for more than a few days and you can determine the maintainer that can review it, you can assign it to them.

## Handling issues

Most issues that are submitted can be divided to two main categories. Transparency in discussion is critical, since the issues usually indicate a pain point or need from the community. Please keep all issue-related discussions in the issue comments, and if closing with a Won't Fix resolution make sure to indicate the reason.

### Content-related issues

These issues might involve outdated or incorrect content, requests for additional content, and so on. Generally, if contributors create a content-related issue it's better if they submit a PR instead.

However, if they cannot fix the problem themselves or if the issue indicates a bigger problem, you can initiate a discussion in the issue comments to determine the best solution for the problem.

For example, an issue for obsolete content in the oVirt storage component should be assigned to the storage maintainer, who can then determine how to fix the issue and assign the relevant resources.

### Infra-related issues

These issues might involve broken links, incorrect markdown parsing, UX improvements, and so on. Similar to content-related issues, if the fix is straightforward it can be handled by the issue submitter.

However, any complex issues or issues that might affect other Middleman-based sites should be consulted with the site infra admins.

For example, an issue for broken links that result from Middleman replacing absolute paths with relative paths might impact multiple Middleman sites and should be assigned to the site infra admins to determine a cross-site solution.

## Reviewing and merging pull requests

After you assign yourself a submitted PR, follow standard review best practices to verify integrity, accuracy, and consistency. Similar to issues, make sure to keep discussions in the PR conversation and maintain transparency for any feedback or related actions.

Follow these best practices for all PRs, including yours. Do not merge your own PRs unless it is a quick and very safe fix, and make sure to test the change before and after you process the PR.
