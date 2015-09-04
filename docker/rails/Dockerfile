FROM moj-ruby:latest

# Set correct environment variables.
ENV HOME /root
ENV APP_HOME /rails

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y pdftk

ADD ./ /rails
# set WORKDIR
WORKDIR /rails

# Publish port 80
EXPOSE 80

ADD docker/rails/logstash-conf.sh /etc/logstash-conf.sh

# ...put your own build instructions here...
# install service files for runit
ADD docker/rails/unicorn.service /etc/service/unicorn/run
ADD docker/rails/sidekiq.service /etc/service/sidekiq/run

# The way this base image handles envvars is pretty strange
COPY docker/app_env_vars /etc/container_environment/

