FROM lsiobase/ubuntu:bionic

ARG DEBIAN_FRONTEND="noninteractive"

COPY root/ /

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    bash \
    ca-certificates \
    git \
    python3 \
    python3-pip && \
  pip3 install --no-warn-script-location \
    gunicorn \
    Django \
    git+https://github.com/Peter-Slump/django-keycloak.git && \
  pip3 install --no-warn-script-location -r /app/requirements.txt && \
  echo "**** cleanup ****" && \
  apt-get -y remove \
     git && \
  apt-get -y autoremove && \
  rm -rf \
   /root/.cache \
   /tmp/*
