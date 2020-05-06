FROM python:3.7-alpine

COPY root/ /

RUN \
  apk add --no-cache \
    bash \
    ca-certificates \
    build-base && \
  pip install --no-warn-script-location \
  # gunicorn is used for launching django
        gunicorn \
  # django
        Django \
  # django-keycloak
        git+https://github.com/Peter-Slump/django-keycloak.git && \
  pip install --no-warn-script-location -r /app/requirements.txt
