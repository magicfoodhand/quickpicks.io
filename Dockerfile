FROM ruby:2.6.3-alpine3.10

# cron jobs in PST
ENV TZ America/Los_Angeles

COPY Gemfile Gemfile.lock /

RUN apk update \
    && apk add dcron tzdata \
    && apk add --virtual .build-dependencies build-base \
    && bundle config build.nokogiri \
    && bundle install \
    && gem cleanup \
    && apk del .build-dependencies \
    && rm -rf /usr/lib/ruby/gems/*/cache/* \
            /var/cache/apk/* \
            /tmp/* \
            /var/tmp/*

COPY ./scripts/* /usr/local/bin/qp/scripts/

COPY ./crontab.txt /tmp/crontab.txt
RUN /usr/bin/crontab /tmp/crontab.txt

COPY ./start.sh /start.sh
ENTRYPOINT /start.sh crond -l 2 -f
