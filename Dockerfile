# Duck: DO NOT change the target OS, it needs to be in sync with the production builder
FROM registry.fedoraproject.org/fedora:33

# Copy and run the setup.
RUN dnf install -y git ruby-devel rubygems-devel gcc-c++ curl-devel rubygem-bundler patch zlib-devel redhat-rpm-config openssl nodejs ImageMagick make glibc-langpack-en

# Please mount the site in this directory.
RUN mkdir -p /srv/site
WORKDIR /srv/site
VOLUME /srv/site

# HTTP port.
EXPOSE 4000

# Live-reload port.
EXPOSE 35729

# Environment variables for build
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES=true

# All parameters passed to the container get routed through a script we create here.
RUN echo "#!/bin/sh" >/usr/local/bin/init.sh \
    && echo "set -e" >>/usr/local/bin/init.sh \
    && echo "set -x" >>/usr/local/bin/init.sh \
    && echo "export DEBUG=true" >>/usr/local/bin/init.sh \
    && echo "bundle config --local path 'vendor/bundle'" >>/usr/local/bin/init.sh \
    && echo "bundle install --quiet" >>/usr/local/bin/init.sh \
    && echo 'exec bundle exec jekyll "$@"' >>/usr/local/bin/init.sh \
    && chmod +x /usr/local/bin/init.sh
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["s","-t","-l","--host=0.0.0.0"]
