FROM python:3.7-alpine

COPY root/ /

RUN \
  echo "**** install packages ****" && \
  apk update && \
  apk add \
    bash \
    git \
    openssl-dev \
    libffi-dev \
    python-dev \
    build-base \
    ca-certificates &&\
  pip install --no-cache-dir \
    gunicorn \
    Django \
    git+https://github.com/Peter-Slump/django-keycloak.git && \
  pip install --no-cache-dir -r /app/requirements.txt && \
  echo "**** cleanup ****" && \
  rm -rf \
    /var/cache/apk/* \
    /root/.cache \
    /tmp/*

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
