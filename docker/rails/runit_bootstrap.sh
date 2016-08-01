#!/bin/bash

cd /rails

echo $*
echo $@
echo yes i ran
if [ "$1" == "bash" ]; then
    echo saw bash
    exec bash "$@"
fi

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
    echo "running vagrant"
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
    ;;
create)
    echo "running create"
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
    ;;
setup)
    echo 'running setup'
    bundle exec rake db:setup
    ;;
esac

# bundle exec succeeds as root
source /etc/container_environment/app_env_vars && exec bundle exec unicorn -p 8080 -c ./config/unicorn.rb
