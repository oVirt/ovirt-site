# Middleman-Springboard

Springboard is a starter-pack for Middleman, for quickly whipping together
static-based websites.

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".


## Initial setup

Before you do anything else, remember this: 

When you use `middleman-springboard`, remember that sites are a fork of this
repository. Be sure you change your origin before you push. You can do this
automatically when forking this repository.

You can push small changes back upream to this repository, as well as pull in
changes made too — but try to keep forks separate. _Thanks!_


### Fedora, RHEL, & CentOS

```
git clone https://github.com/OSAS/middleman-springboard.git YOUR_PROJECT
cd YOUR_PROJECT
./setup.sh # This script assumes your user account has sudo rights
```

### Other Linux distributions

Currently, `setup.sh` is a super-simple script that only has support for
Fedora, RHEL, and CentOS. 

(Pull requests to add support for other distributions and operating systems
are welcome.)

Be sure you have a C++ and Ruby development environment, as well as Ruby Gems
and Bundler, then run the following:

```
git clone https://github.com/OSAS/middleman-springboard.git YOUR_PROJECT
cd YOUR_PROJECT
bundle install
```


## Running a local server

1. Start a local Middleman server:

   `./run-server.sh`

   This will update your locally installed gems and start a Middleman
   development server.

2. Next, browse to <http://0.0.0.0:4567>

3. Edit!

   When you edit files (pages, layouts, CSS, etc.), the site will
   dyanmically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


## Customizing your site

The site can be easily customized by editing `data/site.yml`.


## Adding a Post

To add a post to the community blog (or any blog managed by middleman) use:

```
bundle exec middleman article TITLE
```


## Build your static site

After getting it how you want, you can build the static site by running:

`bundle exec middleman build`


## Deploying

### Setting up deployment

FIXME: Right now, please reference <data/site.yml>

### Actual deployment

After copying your public key to the remote server and configuring your
site in <data/site.yml>, deployment is one simple command:

```
bundle exec middleman deploy
```


### Add new features (parsers, etc.)

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`


## More info

For more information, please check the excellent
[Middleman documentation](http://middlemanapp.com/getting-started/).
