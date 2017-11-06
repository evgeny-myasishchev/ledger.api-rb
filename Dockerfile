# Docker configuration file for production deployment

FROM ruby:2.4.2-stretch
# RUN echo deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main > /etc/apt/sources.list.d/pgdg.list
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && apt-get install vim -y && apt-get install postgresql-client-9.6 -y
RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64' \
	&& chmod +x /usr/local/bin/gosu
RUN mkdir /apps
RUN useradd -d /apps/ledger --create-home -s /bin/bash -U ledger

WORKDIR /apps/ledger
RUN mkdir -p app shared/bundle

ENV RAILS_ENV=production DISABLE_SPRING=true

# Caching bundle install
WORKDIR app
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --gemfile=Gemfile --without development test --deployment --path shared/bundle

# Adding app sources
ADD . .
RUN mkdir tmp
RUN chown -R ledger tmp

ENTRYPOINT ["docker/docker-entrypoint.sh"]
EXPOSE 3000
CMD ["start"]
