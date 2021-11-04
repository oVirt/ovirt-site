FROM docker.io/library/ruby:2

# Copy and run the setup.
COPY setup.sh /usr/local/bin/setup.sh
RUN DEBIAN_FRONTEND=noninteractive apt update \
    && apt install -y sudo \
    && DEBIAN_FRONTEND=noninteractive SKIP_BUNDLE=1 /usr/local/bin/setup.sh \
    && rm -rf /var/lib/apt/lists/*

# Please mount the site in this directory.
RUN mkdir -p /srv/site
WORKDIR /srv/site
VOLUME /srv/site

# HTTP port.
EXPOSE 4000

# Live-reload port.
EXPOSE 35729

# All parameters passed to the container get routed through a script we create here.
RUN echo "#!/bin/sh" >/usr/local/bin/init.sh \
    && echo "set -e" >>/usr/local/bin/init.sh \
    && echo "bundle config --local path 'vendor/bundle'" >>/usr/local/bin/init.sh \
    && echo "bundle install --quiet" >>/usr/local/bin/init.sh \
    && echo 'exec bundle exec jekyll "$@"' >>/usr/local/bin/init.sh \
    && chmod +x /usr/local/bin/init.sh
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["s","-t","-l","--host=0.0.0.0"]
