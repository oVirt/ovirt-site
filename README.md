# Munity

Munity is a starter-pack for Middleman, for quickly whipping together
static-based community websites.

Think of "community" without the "com". Munity means "freedom" and
"security" — which are things a static site can help to bring (on
a small scale).


## Installation
 
1. Clone this repo into `~/.middleman`. You will need to create this
   directory if it doesn't exist.

  `$ git clone GIT_URL_HERE ~/.middleman/munity`

2. Initialize middleman on a new or existing folder 

  `$ middleman init path_to_project --template=munity`


## Usage

### View locally

1. Start up Middleman by typing `bundle exec middleman` (or if you have
   it in your path, just `middleman` works).
   
   Middleman will start up a development server. 

2. Next, browse to <http://0.0.0.0:4567>

3. Edit! 

   When you edit files (pages, layouts, CSS, etc.), the site will
   dyanmically update in development mode. (There's no need to refresh
   the page, unless you get a Ruby error.)


### Build your static site

After getting it how you want, you can build the static site by running:

`bundle exec middleman build`

(If you have middleman in your path, you can just run `middleman build`.)


### Add new parsers

Simply add a new `gem 'some-gem-here'` line in the `Gemfile` and run
`bundle install`

## More info

For more information, please check the excellent 
[Middleman documentation](http://middlemanapp.com/getting-started/).
