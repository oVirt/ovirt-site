#!/bin/sh
set -e

bundle install --quiet
bundle exec jekyll s -t -l $@
