FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq \
	&& apt-get install -y build-essential default-libmysqlclient-dev

# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn

RUN mkdir /minshif

WORKDIR /minshif

COPY Gemfile Gemfile.lock /minshif/

RUN bundle install

COPY . /minshif/

RUN bundle exec rails assets:precompile
RUN bundle exec rails db:migrate

CMD ["bundle", "exec", "rails", "server", "-p", "8000", "-b", "0.0.0.0"]
