# NAME:     homeland/homeland
FROM ruby:2.7-alpine

RUN gem install bundler
RUN apk --update add ca-certificates nodejs yarn curl git tzdata imagemagick nginx nginx-mod-http-image-filter nginx-mod-http-geoip &&\
  apk add --virtual .builddeps build-base ruby-dev libc-dev openssl linux-headers mysql-dev postgresql-dev libxml2-dev libxslt-dev &&\
  rm /etc/nginx/conf.d/default.conf

RUN curl https://get.acme.sh | sh

ENV RAILS_ENV "production"
ENV HOMELAND_VERSION "master"
ENV RUBYOPT "W0"

WORKDIR /home/app/homeland

VOLUME /home/app/homeland/plugins

RUN mkdir -p /home/app &&\
  find / -type f -iname '*.apk-new' -delete &&\
  rm -rf '/var/cache/apk/*' '/tmp/*'

COPY Gemfile Gemfile.lock package.json yarn.lock /home/app/homeland/
RUN gem install puma
RUN bundle config set deployment 'true' && bundle install && yarn &&\
  find /home/app/homeland/vendor/bundle -name tmp -type d -exec rm -rf {} +
ADD . /home/app/homeland
ADD ./config/nginx/ /etc/nginx

RUN rm -Rf /home/app/homeland/vendor/cache

RUN bundle exec rails assets:precompile RAILS_PRECOMPILE=1 RAILS_ENV=production SECRET_KEY_BASE=fake_secure_for_compile


