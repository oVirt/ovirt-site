#!/bin/sh

ruby fetch-dashboard.rb
bundle install --quiet && bundle exec middleman $@
