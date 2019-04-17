#!/bin/bash

# remove if statement after migration to Azure is complete.
# python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf
if [[ $CLOUD_PROVIDER == "azure" || $DISABLE_CLOUDWATCH == "true" ]]; then
# ps -eaf | grep awslogs | grep -v grep | awk -F' ' '{print $2'} | xargs kill -9
    echo "Running sidekiq without cloudwatch"
# supervisord -c /etc/supervisor.conf &
else
  ./expand_variables.sh
  python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf
  ps -eaf | grep awslogs | grep -v grep | awk -F' ' '{print $2'} | xargs kill -9
  supervisord -c /etc/supervisor.conf &
  echo "Running sidekiq with cloudwatch"
fi

bundle exec sidekiq -c 5 -v
