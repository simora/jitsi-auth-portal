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
  update-alternatives --install /usr/bin/python python /usr/bin/python3 5 && \
  pip3 install \
    gunicorn \
    Django \
    git+https://github.com/Peter-Slump/django-keycloak.git && \
  pip3 install -r /app/requirements.txt && \
  echo "**** cleanup ****" && \
  apt-get -y remove \
     git && \
  apt-get -y autoremove && \
  rm -rf \
   /root/.cache \
   /tmp/*
