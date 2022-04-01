FROM ruby:3.1

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

COPY . .

EXPOSE 4567

CMD [ "bundle", "exec", "ruby", "main.rb" ]