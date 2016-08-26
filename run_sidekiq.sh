#!/bin/bash
export RAILS_ENV=production
bundle exec sidekiq -c 5 -v -e production
