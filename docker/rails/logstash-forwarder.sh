#!/bin/bash
cat <<EOT
{
  "network": {
     "servers": [ "$LOGSTASH_SERVER" ],
     "timeout": 15,
     "ssl certificate": "/etc/certs/server.crt",
     "ssl key": "/etc/certs/server.key",
     "ssl ca": "/etc/certs/server.crt"
  },
  "files": [
    {
      "paths": [ "/rails/log/*" ],
      "fields": {
        "project": "$PROJECT",
        "appserver": "rails",
        "version": "$APPVERSION",
        "env": "$ENV",
      }
    }
  ]
}
EOT
