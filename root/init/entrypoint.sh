#!/bin/bash

echo "Beginning /config preparation"

mkdir -p /config/gunicorn
cp -n /etc/config/gunicorn/config.py /config/gunicorn/

mkdir -p /config/jitsi
mkdir -p /config/secrets

cd /app

echo "Completed /config preparation"
echo "Beginning Django app Initialisation"

./manage.py migrate
./manage.py load_dynamic_fixtures jitsi

# Create Superuser if required
if [ "$SKIP_SUPERUSER" == "true" ]; then
  echo "↩️ Skip creating the superuser"
else
  if [ -z ${SUPERUSER_NAME+x} ]; then
    SUPERUSER_NAME='admin'
  fi
  if [ -z ${SUPERUSER_EMAIL+x} ]; then
    SUPERUSER_EMAIL='admin@example.com'
  fi
  if [ -z ${SUPERUSER_PASSWORD+x} ]; then
    SUPERUSER_PASSWORD='admin'
  fi
  if [ -z ${SUPERUSER_API_TOKEN+x} ]; then
    SUPERUSER_API_TOKEN='0123456789abcdef0123456789abcdef01234567'
  fi

  ./manage.py shell --interface python << END
from django.contrib.auth.models import User
if not User.objects.filter(username='${SUPERUSER_NAME}'):
    u=User.objects.create_superuser('${SUPERUSER_NAME}', '${SUPERUSER_EMAIL}', '${SUPERUSER_PASSWORD}')
END
  echo "Superuser Username: ${SUPERUSER_NAME}, E-Mail: ${SUPERUSER_EMAIL}"
fi

# Copy static files
./manage.py collectstatic --no-input

echo "Completed Django app Initialisation"
echo "Starting Gunicorn"

[ -z "$PORT" ] && PORT="8080"
[ -z "$NUM_WORKERS" ] && NUM_WORKERS="4"

cd /app || exit

gunicorn \
    --bind 0.0.0.0:$PORT \
    --config /config/gunicorn/config.py \
    --workers $NUM_WORKERS \
    jitsi.wsgi
