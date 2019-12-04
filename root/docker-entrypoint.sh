#!/bin/bash -x

# Start Supervisor if not already running
if ! ps aux | grep -q "[s]upervisor"; then
  echo "Starting supervisor service"
  /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf &
fi

# Run as the www-data user
su - www-data

exec "$@"
