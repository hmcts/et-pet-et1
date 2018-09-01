FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get update && \
    apt-get install -y pdftk nodejs

RUN npm install

EXPOSE 8080

ADD docker/rails/logstash-conf.sh /etc/logstash-conf.sh
ADD docker/rails/runit_bootstrap.sh /run.sh
ADD ./run_sidekiq.sh /run_sidekiq.sh

RUN chmod +x /run.sh /run_sidekiq.sh
RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production"

CMD ["./run.sh"]
