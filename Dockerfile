ARG FROM=python:3.7-alpine
FROM ${FROM} as builder

RUN apk add --no-cache \
      bash \
      build-base \
      ca-certificates \
      cyrus-sasl-dev \
      graphviz \
      jpeg-dev \
      libevent-dev \
      libffi-dev \
      libxslt-dev \
      openldap-dev \
      postgresql-dev \
      git

WORKDIR /install

RUN pip install --prefix="/install" --no-warn-script-location \
    gunicorn \
    Django \
    git+https://github.com/Peter-Slump/django-keycloak.git

COPY root/app/requirements.txt /
RUN pip install --prefix="/install" --no-warn-script-location -r /requirements.txt

FROM lsiobase/ubuntu:bionic

ARG DEBIAN_FRONTEND="noninteractive"

COPY root/ /
COPY --from=builder /install /usr/local

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    bash \
    ca-certificates \
    python3 \
  update-alternatives --install /usr/bin/python python /usr/bin/python3 5 && \
  echo "**** cleanup ****" && \
  apt-get -y remove \
     git && \
  apt-get -y autoremove && \
  rm -rf \
   /root/.cache \
   /tmp/*
