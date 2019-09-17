#!/bin/sh
set -e

bundle install --quiet --path vendor/bundle
bundle exec jekyll s -t -l $@
