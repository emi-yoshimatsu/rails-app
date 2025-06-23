FROM ruby:3.4

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client && \
    gem install bundler

COPY . .

RUN bundle install
