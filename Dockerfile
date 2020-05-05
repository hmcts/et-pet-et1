FROM ministryofjustice/ruby:2.5.1-webapp-onbuild

# Adding argument support for ping.json
ARG APPVERSION=unknown
ARG APP_BUILD_DATE=unknown
ARG APP_GIT_COMMIT=unknown
ARG APP_BUILD_TAG=unknown

# Setting up ping.json variables
ENV APPVERSION ${APPVERSION}
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ENV DEBIAN_FRONTEND noninteractive
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && \
    apt-get install -y nodejs supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm -fr *Release* *Sources* *Packages* && \
    truncate -s 0 /var/log/*log


RUN npm install

EXPOSE 8080

ADD run.sh /run.sh
ADD ./run_sidekiq.sh /run_sidekiq.sh

RUN chmod +x /run.sh /run_sidekiq.sh
RUN bash -c "DB_ADAPTOR=nulldb bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=ijustdontcareyoureonlydoingaraketask"

CMD ["./run.sh"]
