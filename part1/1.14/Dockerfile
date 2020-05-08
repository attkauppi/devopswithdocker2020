FROM ruby:2.6.0-alpine

WORKDIR /mydir

RUN apk add --no-cache --update build-base sqlite-dev nodejs tzdata

COPY Gemfile Gemfile.lock ./
RUN bundle install

ENV RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV SECRET_KEY_BASE=tositosisalainen

COPY . .

RUN rails db:migrate && rake assets:precompile

EXPOSE 3000
CMD ["rails", "s"]

