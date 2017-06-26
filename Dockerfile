FROM ministryofjustice/ruby:2.3.3-webapp-onbuild

# Set correct environment variables.
ENV HOME /root
ENV APP_HOME /rails

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo 'deb https://deb.nodesource.com/node jessie main' > /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install -y pdftk runit nodejs

ADD ./ /rails

# set WORKDIR
WORKDIR /rails

RUN cd /rails  && \
    chown -R $APPUSER /rails && \
    bundle config --global without build && \
    bundle --path vendor/bundle --deployment --standalone --binstubs  && \
    rm -rf bin && \
    npm install && \
    bundle exec rake rails:update:bin

RUN GEM_HOME=/rails/vendor/bundle/ruby/2.3.3/ gem install bundler

EXPOSE 8080

ADD docker/rails/logstash-conf.sh /etc/logstash-conf.sh
ADD docker/rails/runit_bootstrap.sh /run.sh
ADD ./run_sidekiq.sh /run_sidekiq.sh

RUN chmod +x /run.sh /run_sidekiq.sh
RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production"

CMD ["./run.sh"]
