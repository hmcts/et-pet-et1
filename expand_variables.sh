sed -i s#\${CW_LOG_FILE}#${CW_LOG_FILE}#g awslogs.conf
sed -i s/\${CW_LOG_STREAM_NAME}/${CW_LOG_STREAM_NAME}/g awslogs.conf
sed -i s/\${CW_LOG_GROUP_NAME}/${CW_LOG_GROUP_NAME}/g awslogs.conf
