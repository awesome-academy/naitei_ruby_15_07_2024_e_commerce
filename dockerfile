FROM ruby:3.2.2

RUN apt-get update -qq && apt-get install -y nodejs npm imagemagick redis-tools
RUN npm install --global yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
