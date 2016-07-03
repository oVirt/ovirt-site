#!/usr/bin/ruby

require 'bundler'
Bundler.setup

require 'active_support/core_ext/string'
require 'launchy'
require 'yaml'
require 'chronic'
require 'slop'

# Disable ActiveSupport's UTF-8 warning
I18n.enforce_available_locales = false

slop_opts = {
  help: true,
  ignore_case: true,
  optional_arguments: true,
  banner: 'Usage: ' + __FILE__ + ' [options] "Blog title here."'
}

# Command line options are parsed using Slop
opts = Slop.parse(slop_opts) do |o|
  o.string '-a', '--author', 'Author name', argument: :required, default: ENV['USER']
  o.string '-d', '--date', 'Custom datetime', argument: :required, default: Time.now.strftime('%F %T %Z')
  o.string '-e', '--editor', 'Custom editor', argument: :required, default: ENV['EDITOR']
  o.on '-t', '--tags', 'Comma-separated list of tags', argument: :required
  o.on '-n', '--no-browser', 'Disable browser'
  o.on '-h', '--help', 'Show this simple usage screen' do
    puts opts
  end
end

# Slop removes the flags from ARGV and places them in opts.arguments,
# so we're left with the title (either as a string or in parts)
title = opts.arguments.join(' ').strip

# Simply display usage and exit if there's no title provided
if title.empty?
  puts opts
  exit
end

# Normalize CSV
tags = opts[:tags] ? opts[:tags].gsub(/,\s*/, ', ') : nil

# Frontmatter
meta = {
  'title' => title,
  'author' => opts[:author],
  'tags' => tags,
  'date' => (Chronic.parse(opts[:date]) || Time.now).strftime('%F %T %Z')
}

content = "#{meta.to_yaml}---\n\n\n"

# File values
root = File.dirname(__FILE__)
ext = 'html.md'
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
  Launchy.open file_full.to_s
end

# View file in a webpage
Launchy.open url unless opts['no-browser']
