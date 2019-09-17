#!/bin/sh

git submodule init && git submodule update
#setup for RedHat
if [ -f /etc/redhat-release ]; then
  
  sudo yum install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel redhat-rpm-config openssl nodejs

# setup for Debian 
elif [ -f /etc/debian_version ]; then
  
  sudo apt install -y build-essential ruby-bundler libcurl4-openssl-dev zlib1g-dev ruby-dev nodejs

else
    echo "Could not verify system is RedHat or Debian."
    exit 1
fi 

mkdir -p vendor/bundle

bundle install --path vendor/bundle
