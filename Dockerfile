FROM ruby:3.1.2

RUN mkdir /app

WORKDIR /app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

COPY . .

EXPOSE 4567

CMD [ "bundle", "exec", "ruby", "main.rb" ]
