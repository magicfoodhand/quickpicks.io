FROM ruby:2.6.3-alpine3.10

# cron jobs in PST
ENV TZ America/Los_Angeles

COPY Gemfile Gemfile.lock /

RUN apk add --update --no-cache build-base dcron tzdata

RUN bundle config build.nokogiri && bundle install

RUN mkdir -p /usr/local/bin/qp/scripts

COPY ./scripts/* /usr/local/bin/qp/scripts/

COPY ./crontab.txt /tmp/crontab.txt
RUN /usr/bin/crontab /tmp/crontab.txt

COPY ./start.sh /start.sh
ENTRYPOINT /start.sh crond -l 2 -f
