FROM ruby:2.7-rc-alpine

RUN mkdir -p /usr/local/bin/qp/scripts

# cron jobs in PST
RUN apk update --no-cache && apk add --no-cache dcron tzdata
ENV TZ America/Los_Angeles

COPY ./scripts/* /usr/local/bin/qp/scripts/

COPY ./crontab.txt /tmp/crontab.txt
RUN /usr/bin/crontab /tmp/crontab.txt

COPY ./start.sh /start.sh
ENTRYPOINT /start.sh crond -l 2 -f
