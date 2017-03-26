#!/bin/sh

#setup for redhat
if [ -f /etc/redhat-release ]; then
  git submodule init && git submodule update

  sudo yum install -y ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel redhat-rpm-config openssl

  bundle install
# setup for debian 
elif [ -f /etc/debian_version ]; then
  git submodule init && git submodule update

  sudo apt install -y build-essential ruby-bundler libcurl4-openssl-dev zlib1g-dev ruby-dev

  bundle install 

else
    echo "Could not verify system is redhat or debian."
    exit 1
fi 