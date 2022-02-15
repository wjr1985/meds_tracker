FROM ruby:3.1

COPY . .
RUN bundle install

EXPOSE 4567

CMD [ "bundle", "exec", "ruby", "main.rb" ]