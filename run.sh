#!/bin/bash
case ${DOCKER_STATE} in
migrate)
    echo "running migrate"
    bundle exec rake db:migrate
    ;;
seed)
    echo "running seed"
    bundle exec rake db:migrate
    bundle exec rake db:seed
    ;;
vagrant)
    echo "running seed"
    bundle exec rake db:create
    bundle exec rake db:seed
    bundle exec rake db:migrate
    ;;
esac
bundle exec unicorn -p 3000
