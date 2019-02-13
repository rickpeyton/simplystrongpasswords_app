FROM ruby:2.2 as dev
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile* ./
RUN bundle
COPY . ./
CMD [ "bundle", "exec", "unicorn", "-p", "3000", "-c", "./config/unicorn.rb" ]


FROM ruby:2.2 as builder
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile* ./
RUN bundle
COPY . ./
RUN bundle exec rake assets:precompile
RUN bundle install --path vendor/bundle --without development test


FROM ruby:2.2
WORKDIR /app
COPY --from=builder /app /app
COPY config/bundle_config /usr/local/bundle/config
CMD [ "bundle", "exec", "unicorn", "-p", "$PORT", "-c", "./config/unicorn.rb" ]
