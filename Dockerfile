FROM ruby:3.4.1

# Install dependencies
RUN apt-get update -qq \
    && apt-get install -y build-essential libpq-dev

# Install Node.js (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# Create app directory
RUN mkdir /minshif

WORKDIR /minshif

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock /minshif/

# Install Ruby dependencies
RUN bundle install

# Copy the rest of the application code
COPY . /minshif/

# Install JavaScript dependencies
RUN yarn install

# Precompile assets
RUN bundle exec rails assets:precompile

# Run database migrations (migrate only if db exists, otherwise skip in production)
# RUN if [ "$RAILS_ENV" != "production" ]; then bundle exec rails db:migrate; fi

# Expose the port (not strictly necessary in Render, but good for documentation)
EXPOSE 8000

# Use $PORT environment variable to dynamically assign the port
CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0 -p ${PORT}"]
