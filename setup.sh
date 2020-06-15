#!/bin/sh

git submodule init && git submodule update
#setup for RedHat
if [ -f /etc/redhat-release ]; then
  sudo yum install -y epel-release
  sudo yum install -y --enablerepo=epel ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel redhat-rpm-config openssl nodejs ImageMagick

# setup for Debian
elif [ -f /etc/debian_version ]; then

  sudo apt install -y build-essential ruby-bundler libcurl4-openssl-dev zlib1g-dev ruby-dev nodejs imagemagick

else
    echo "Could not verify system is RedHat or Debian."
    exit 1
fi

bundle install --path vendor/bundle
