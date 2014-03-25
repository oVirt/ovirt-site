# Middleman-Springboard

Springboard is a starter-pack for Middleman, for quickly whipping together
static-based websites.

To get started, you need to have Ruby and Ruby Gems installed, as well
as "bundler".


## Initial setup

### Fedora, RHEL, & CentOS

```
sudo yum install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler
git clone GIT_URL_HERE PROJECT_NAME
cd PROJECT_NAME
bundle install
```


## Running a local server

1. Start a local Middleman server that uses local gems by typing
   `bundle exec middleman server`

   (Note: 'server' is optional, but it helps if you're going through
   command-history in bash or zsh with control-r, versus other middleman
   commands like `console`, `build`, or `deploy`)

2. Next, browse to <http://0.0.0.0:4567>

3. Edit!

   When you edit files (pages, layouts, CSS, etc.), the site will
   dyanmically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


## Updating

When there are new gems in `Gemfile`, just run `bundle` again.


## Customizing your site

The site can be easily customized by editing `data/site.yml`.


## Adding a Post

To add a post to the community blog (or any blog managed by middleman) use:

```
bundle middleman article TITLE
```


## Build your static site

After getting it how you want, you can build the static site by running:

`bundle exec middleman build`

(If you have middleman in your path, you can just run `middleman build`.)


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
