#!/bin/bash
cd /rails
sv start sneakers/log
sv start sneakers
sv start unicorn
tail -f /rails/log/unicorn.log