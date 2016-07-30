#FROM ministryofjustice/ruby:2.2.3-webapp-onbuild
#FROM ministryofjustice/ruby:2-webapp-onbuild
FROM ministryofjustice/ruby:2.2

RUN touch /etc/inittab

# Set correct environment variables.
ENV APP_HOME=/rails DEBIAN_FRONTEND=noninteractive
# set WORKDIR
WORKDIR /rails
# Publish port 8080
EXPOSE 8080


# Ensure the pdftk package is installed as a prereq for ruby PDF generation
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y pdftk runit nodejs

### Get 'gosu'
RUN curl -o /usr/local/bin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && \
chmod 755 /usr/local/bin/gosu

ADD ./ /rails

RUN    cd /rails  && \
    chown -R $APPUSER /rails && \
    bundle config --global without build && \
    bundle --path vendor/bundle --deployment --standalone --binstubs  && \
    rm -rf bin && \
    npm install && \
    bundle exec rake rails:update:bin
#    source /atet/jenkins-vars-censored.sh && \
#    bundle exec rake assets:precompile RAILS_ENV=production

RUN GEM_HOME=/rails/vendor/bundle/ruby/2.3.0/ gem install bundler

# for development:
# apt-get install -y git build-essential libxml2-dev zlib1g-dev libpq-dev
# export DB_USERNAME=postgres
# #declare -x DB_HOST="172.22.5.136"
# bundle exec rake db:create
# db:setup
# RAILS_ENV=development bundle
#
ADD docker-ng/rails/logstash-conf.sh /etc/logstash-conf.sh

# ...put your own build instructions here...
# install service files for runit
#ADD docker-ng/rails/unicorn.service /etc/service/unicorn/run
#ADD docker-ng/rails/sneakers.service /etc/service/sneakers/run
#RUN mkdir -p /rails/log/sneakers
#ADD docker-ng/rails/sneakers.logger /etc/service/sneakers/log/run
ADD docker-ng/rails/runit/unicorn.service /etc/service/unicorn/run
ADD docker-ng/rails/runit_bootstrap.sh /run.sh
RUN chmod +x /etc/service/unicorn/run /run.sh


# The way this base image handles envvars is pretty strange
# ... and it doesn't work on official moj ruby image.
# COPY docker-ng/app_env_vars /etc/container_environment/

# ADD docker-ng/rails/runner.sh /run.sh
# RUN chmod +x /run.sh
#ENTRYPOINT /run.sh

CMD "/run.sh"
