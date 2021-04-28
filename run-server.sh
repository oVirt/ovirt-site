#!/bin/sh
set -e

bundle config --local path 'vendor/bundle'
bundle install --quiet
bundle exec jekyll s -t -l $@
