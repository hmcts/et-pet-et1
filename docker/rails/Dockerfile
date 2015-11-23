
#FROM ministryofjustice/ruby:2.2.3-webapp-onbuild
FROM ministryofjustice/ruby:2-webapp-onbuild

RUN touch /etc/inittab

# Set correct environment variables.
ENV APP_HOME /rails

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
#ADD docker/rails/unicorn.service /etc/service/unicorn/run
#ADD docker/rails/sneakers.service /etc/service/sneakers/run
#RUN mkdir -p /rails/log/sneakers
#ADD docker/rails/sneakers.logger /etc/service/sneakers/log/run
ADD docker/rails/runit/unicorn.service /etc/service/unicorn/run
RUN chmod +x /etc/service/unicorn/run

# The way this base image handles envvars is pretty strange
# ... and it doesn't work on official moj ruby image.
# COPY docker/app_env_vars /etc/container_environment/

# ADD docker/rails/runner.sh /run.sh
# RUN chmod +x /run.sh
# ENTRYPOINT /run.sh

ADD docker/rails/runit_bootstrap.sh /run.sh
#/usr/sbin/runit_bootstrap
RUN chmod +x /run.sh
# ENTRYPOINT ["/usr/sbin/runit_bootstrap"]