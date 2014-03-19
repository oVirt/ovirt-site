# If you have OpenSSL installed, we recommend updating
# the following line to use "https"
source 'http://rubygems.org'

gem "middleman", "~>3.2"

# Live-reloading plugin
gem "middleman-livereload"

# Debugger / REPL alternative to irb
gem 'pry'
gem 'pry-debugger'
gem 'pry-stack_explorer'

# Cross-templating language block fix for Ruby 1.8
platforms :mri_18 do
  gem "ruby18_source_location"
end

# For faster file watcher updates for people using Windows
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]


#####
# General plugins

# Blog plugin
gem "middleman-blog"
#gem "middleman-blog-drafts"
#gem "middleman-blog-authors"

gem 'middleman-deploy'

# Thumbnailer
#gem "middleman-thumbnailer", github: "nhemsley/middleman-thumbnailer"

# favicon support (favicon PNG should be 144×144)
gem "middleman-favicon-maker"

# HTML & XML parsing smarts
gem "nokogiri"

# Syntax highlighting
gem "middleman-syntax"

# For feed.xml.builder
gem "builder", "~> 3.0"

# Better JSON lib
gem "oj"


#####
# Bootstrap

# Bootstrap, as SASS 3 version (there's a bug in 3.0.1+, so we're
# locking to 3.0.0 for now
gem "bootstrap-sass", "3.0.0"


#####
# Formats

# less (css)
gem "therubyracer"
gem "less"

# asciidoctor
gem "asciidoctor"

# mediawiki
gem "wikicloth"

# Markdown, with GitHub flavoring
gem "redcarpet"

gem 'open-uri-cached'
