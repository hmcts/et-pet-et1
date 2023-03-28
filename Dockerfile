FROM ruby:2.7.7-alpine AS assets
RUN addgroup app --gid 1000
RUN adduser -SD -u 1000 --shell /bin/bash --home /home/app app app
RUN chown -R app:app /usr/local/bundle
COPY --chown=app:app . /home/app/et1
ENV RAILS_ENV=production
ENV HOME=/home/app
RUN apk add --no-cache libpq-dev tzdata gettext sudo shared-mime-info libc6-compat && \
    apk add --no-cache --virtual .build-tools git build-base curl-dev nodejs yarn && \
    cd /home/app/et1 && \
    gem install bundler -v 1.17.3 && \
    bundle install --no-cache --jobs=5 --retry=3 --without=test development --with=assets production --deployment && \
    bundle exec rails assets:precompile SECRET_KEY_BASE=doesntmatter && \
    chown -R app:app /usr/local/bundle && \
    apk del .build-tools

FROM ruby:2.7.7-alpine

RUN addgroup app --gid 1000
RUN adduser -SD -u 1000 --shell /bin/bash --home /home/app app app


ARG APPVERSION=unknown
ARG APP_BUILD_DATE=unknown
ARG APP_GIT_COMMIT=unknown
ARG APP_BUILD_TAG=unknown

# Setting up ping.json variables
ENV APPVERSION ${APPVERSION}
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

EXPOSE 8080

COPY --chown=app:app . /home/app/et1
COPY --from=assets --chown=app:app /home/app/et1/public/packs /home/app/et1/public/packs
COPY --from=assets --chown=app:app /home/app/et1/vendor/bundle /home/app/et1/vendor/bundle
RUN chown -R app:app /usr/local/bundle
RUN apk add --no-cache libpq-dev tzdata gettext sudo shared-mime-info curl-dev file bash libc6-compat && \
    apk add --no-cache postgresql-client~=11.12 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.10/main && \
    apk add --no-cache --virtual .build-tools git build-base && \
    cd /home/app/et1 && \
    gem install bundler -v 1.17.3 && \
    bundle install --no-cache --jobs=5 --retry=3 --without=test development --with=production --deployment && \
    apk del .build-tools && \
    chown -R app:app /usr/local/bundle && \
    mkdir -p /home/app/et1/tmp && \
    chown -R app:app /home/app/et1/tmp


USER app
ENV HOME /home/app
WORKDIR /home/app/et1
ENV RAILS_ENV=production
CMD ["bundle", "exec", "iodine", "-port", "8080"]
