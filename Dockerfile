FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq \
	&& apt-get install -y build-essential libpq-dev nodejs postgresql-client yarn

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
	&& apt-get install -y nodejs

RUN mkdir /minshif

WORKDIR /minshif

COPY Gemfile /minshif/Gemfile

COPY Gemfile.lock /minshif/Gemfile.lock

RUN bundle install

COPY . /minshif/
