FROM centos:7
MAINTAINER Garrett LeSage <garrett@redhat.com>

# User & group IDs — should match local user
ENV UID 1000
ENV GID 1000

# Install necessary deps
RUN yum install -y git rsync ruby-devel rubygems gcc-c++ curl-devel rubygem-bundler make patch tar openssl zlib-devel

# Set up working directory
RUN mkdir -p /opt/website
WORKDIR /opt/website

# Add generic "docker" user & set permissions
RUN groupadd docker -g $GID
RUN useradd docker -u $UID -g $GID
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker
RUN chown docker:docker /opt/website

# Switch to "docker" user
USER docker

# Set bundle path to map to local working dir
ENV BUNDLE_PATH /opt/website/.gem-docker

# Expose Middleman dev port
EXPOSE 4567:4567

# Running the server is the default command
# (This can be overridden at runtime, of course.)
CMD ["./run-server.sh"]
