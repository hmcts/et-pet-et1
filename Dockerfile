FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && \
    apt-get install -y pdftk nodejs


RUN npm install

EXPOSE 8080

ADD docker/rails/logstash-conf.sh /etc/logstash-conf.sh
ADD docker/rails/runit_bootstrap.sh /run.sh
ADD ./run_sidekiq.sh /run_sidekiq.sh

RUN chmod +x /run.sh /run_sidekiq.sh
RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=ijustdontcareyoureonlydoingaraketask"

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
RUN mkdir /etc/cron.d
RUN touch /etc/cron.d/awslogs

RUN apt-get update
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d/
COPY supervisor_awslogs.conf /etc/supervisor/conf.d/
COPY supervisor.conf /etc/supervisor.conf

CMD ["./run.sh"]
