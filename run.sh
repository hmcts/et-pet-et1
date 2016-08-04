#!/bin/bash


bundle exec unicorn -p 8080 -c ./config/unicorn.rb -E production