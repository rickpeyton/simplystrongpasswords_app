FROM rickpeyton/rails:ruby-2.3.8-rails-4.2.11 as dev
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile* ./
RUN bundle
COPY . ./
CMD [ "bundle", "exec", "unicorn", "-p", "3000", "-c", "./config/unicorn.rb" ]


FROM rickpeyton/rails:ruby-2.3.8-rails-4.2.11 as builder
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash - && apt-get install -y nodejs
WORKDIR /app
COPY Gemfile* ./
RUN bundle
COPY . ./
RUN bundle exec rake assets:precompile
RUN bundle install --clean --without development test


FROM rickpeyton/rails:ruby-2.3.8-rails-4.2.11
WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app
CMD [ "bundle", "exec", "unicorn", "-p", "$PORT", "-c", "./config/unicorn.rb" ]
