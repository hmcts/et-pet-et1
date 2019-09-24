#!/bin/bash

PHUSION_SERVICE="${PHUSION:-false}"
case ${PHUSION_SERVICE} in
true)
    echo "running as service"
    cd /home/app/
    bundle exec sidekiq -c 5 -v
    ;;
*)
    echo "normal startup"
    bundle exec sidekiq -c 5 -v
    ;;
esac
