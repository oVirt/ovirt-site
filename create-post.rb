#!/usr/bin/ruby

require 'active_support/core_ext/string'
require 'launchy'
require 'yaml'
require 'chronic'
require 'slop'

# Disable ActiveSupport's UTF-8 warning
I18n.enforce_available_locales = false

# Command line options are parsed using Slop
opts = Slop.parse!(help: true, ignore_case: true) do
  on 'a', 'author', "Author name", argument: :required, default: ENV['USER']
  on 'd', 'date', "Custom datetime", argument: :required, default: Time.now.strftime('%F %T %Z')
  on 'e', 'editor', "Custom editor", argument: :required, default: ENV['EDITOR']
  on 'n', 'no-browser', "Disable browser"
end

# Since we're using 'parse!', Slop removes the flags from ARGV,
# so we're left with the title (either as a string or in parts)
title = ARGV.join(' ')


# Frontmatter
meta = {
  'title' => title,
  'author' => opts[:author],
  'date' => (Chronic.parse(opts[:date]) || Time.now).strftime('%F %T %Z')
}

content = "#{meta.to_yaml}---\n\n\n"


# File values
root = File.dirname(__FILE__)
ext = "html.md"
path = "#{root}/source/blog"
file = "#{meta['date'].to_date}-#{title.parameterize}"
file_full = "#{path}/#{file}.#{ext}"

# URL values
date_parts = 2
date_urlfrag = meta['date'].to_date.to_s.split(/-/).take(date_parts).join('/')
file_urlfrag = "#{date_urlfrag}/#{title.parameterize}"
url = "http://0.0.0.0:4567/blog/#{file_urlfrag}"


# Save the file
File.write file_full, content
puts "Created #{file_full}"

# Open file in editor
if opts[:editor]
  # Use $EDITOR or --editor
  exec opts[:editor], file_full
else
  # Fall back to xdg-open (or platform equiv)
  Launchy.open "#{file_full}"
end

# View file in a webpage
Launchy.open url unless opts["no-browser"]
