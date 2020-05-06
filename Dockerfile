FROM python:3.7-alpine

COPY root/ /

RUN \
  apk add --no-cache \
    bash \
    ca-certificates \
    git \
    build-base && \
  pip install --no-warn-script-location \
        gunicorn \
        Django \
        git+https://github.com/Peter-Slump/django-keycloak.git && \
  pip install --no-warn-script-location -r /app/requirements.txt
