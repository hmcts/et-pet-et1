FROM ministryofjustice/ruby:2-webapp-onbuild

# Set correct environment variables.
ENV UNICORN_PORT 3000
ENV DEBIAN_FRONTEND noninteractive
# These environment variables are required for the asset building.
ENV RAILS_ENV production
ENV SENDING_HOST dummy
ENV SMTP_HOSTNAME dummy
ENV SMTP_PORT dummy
ENV SMTP_USERNAME dummy
ENV SMTP_PASSWORD dummy
ENV RABBIT_USER dummy
ENV RABBIT_PASSWORD dummy
ENV RABBIT_HOST dummy
ENV RABBIT_PORT dummy
ENV RABBIT_VHOST dummy
ENV SNEAKERS_WORKERS 1
ENV SNEAKERS_TIMEOUT_S 1
ENV SNEAKERS_RETRY_TTL_MS 1
ENV SNEAKERS_MAX_RETRIES 1
ENV EPDQ_PSPID dummy
ENV EPDQ_SECRET_IN dummy
ENV EPDQ_SECRET_OUT dummy
ENV AWS_ACCESS_KEY_ID dummy
ENV AWS_SECRET_ACCESS_KEY dummy
ENV S3_UPLOAD_BUCKET dummy
ENV AWS_SECRET_ACCESS_KEY dummy


# Publish unicorn port
EXPOSE $UNICORN_PORT

# ...put your own build instructions here...
# install service files for runit
ADD docker/rails/unicorn.service /etc/service/unicorn/run
ADD docker/rails/sneakers.service /etc/service/sneakers/run

# Ensure the pdftk package is installed as a prereq for ruby PDF generation
RUN apt-get update && apt-get install -y && apt-get install -y pdftk

#SECRET_TOKEN set here because otherwise devise blows up during the precompile.
RUN npm install
RUN bundle exec rake assets:precompile RAILS_ENV=production

# Use baseimage-docker's init process.
CMD ["./run.sh"]
