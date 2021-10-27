# Dockerfileを元にイメージを構築
FROM ruby:3.0.1
ENV LANG=C.UTF-8 \
    APP_HOME=/app \
    TZ=Asia/Tokyo

# 必要なパッケージをインストール
RUN apt-get update -qq && \
  apt-get install -y \
    build-essential \
    apt-utils \
    cmake \
    curl \
    vim \
    apt-transport-https \
    imagemagick \
    wget && \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && \
  apt-get install -y nodejs yarn && \
  rm -rf /var/lib/apt/lists && \
  gem install bundler

WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle \
    DOCKER=1

ARG DEPLOY_ENV

RUN bundle install && \
  yarn install && \
  rm -rf ~/.gem && \
  mkdir -p $APP_HOME/tmp/sockets && \
  mkdir -p $APP_HOME/tmp/pids && \
  mkdir -p $APP_HOME/tmp/cache && \
  mkdir -p $APP_HOME/log && \
  touch $APP_HOME/log/puma.stdout.log && \
  touch $APP_HOME/log/puma.stderr.log

COPY . $APP_HOME

RUN RAILS_ENV=$DEPLOY_ENV NODE_ENV=$DEPLOY_ENV bundle exec rake webpacker:compile
