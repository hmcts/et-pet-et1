#!/bin/bash

case ${DOCKER_STATE} in
migrate)
    echo "Running migrate"
    bundle exec rake db:migrate
    ;;
create)
    echo "Running create"
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:seed
    ;;
esac

# remove if statement after migration to Azure is complete.
# python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf
if [[ $CLOUD_PROVIDER == "azure" || $DISABLE_CLOUDWATCH == "true" ]]; then
# ps -eaf | grep awslogs | grep -v grep | awk -F' ' '{print $2'} | xargs kill -9
    echo "Running app without cloudwatch"
# supervisord -c /etc/supervisor.conf &
else
  ./expand_variables.sh
  python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf
  ps -eaf | grep awslogs | grep -v grep | awk -F' ' '{print $2'} | xargs kill -9
  supervisord -c /etc/supervisor.conf &
  echo "Running app with cloudwatch"
fi

bundle exec unicorn -p ${PORT:-8080} -c ./config/unicorn.rb -E ${RAILS_ENV:-production}
