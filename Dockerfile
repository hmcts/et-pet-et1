FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Adding argument support for ping.json
# ARG APPVERSION=unknown
# ARG APP_BUILD_DATE=unknown
# ARG APP_GIT_COMMIT=unknown
# ARG APP_BUILD_TAG=unknown

# Setting up ping.json variables
ENV APPVERSION ${APPVERSION:-unknown}
ENV APP_BUILD_DATE ${APP_BUILD_DATE:-unknown}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT:-unknown}
ENV APP_BUILD_TAG ${APP_BUILD_TAG:-unknown}

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
ENV DEBIAN_FRONTEND noninteractive
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && \
    apt-get install -y pdftk nodejs supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log


RUN npm install

EXPOSE 8080

ADD run.sh /run.sh
ADD ./run_sidekiq.sh /run_sidekiq.sh

RUN chmod +x /run.sh /run_sidekiq.sh
RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=ijustdontcareyoureonlydoingaraketask"

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
RUN mkdir /etc/cron.d
RUN touch /etc/cron.d/awslogs

RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d/
COPY supervisor_awslogs.conf /etc/supervisor/conf.d/
COPY supervisor.conf /etc/supervisor.conf

CMD ["./run.sh"]
