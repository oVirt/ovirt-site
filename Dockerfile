FROM docker.io/library/ruby:2

RUN DEBIAN_FRONTEND=noninteractive apt update \
    && DEBIAN_FRONTEND=noninteractive apt install -y build-essential ruby-bundler libcurl4-openssl-dev zlib1g-dev ruby-dev nodejs imagemagick libffi7 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /srv/site \
    && echo "#!/bin/sh" >/usr/local/bin/init.sh \
    && echo "set -e" >>/usr/local/bin/init.sh \
    && echo "bundle config --local path 'vendor/bundle'" >>/usr/local/bin/init.sh \
    && echo "bundle install --quiet" >>/usr/local/bin/init.sh \
    && echo 'exec bundle exec jekyll "$@"' >>/usr/local/bin/init.sh \
    && chmod +x /usr/local/bin/init.sh

WORKDIR /srv/site
VOLUME /srv/site
EXPOSE 4000

ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["s","-t","-l","--host=0.0.0.0"]
