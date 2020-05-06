ARG FROM=python:3.7-alpine
FROM ${FROM} as builder

RUN apk add --no-cache \
      bash \
      build-base \
      ca-certificates

WORKDIR /install

RUN pip install --prefix="/install" --no-warn-script-location \
# gunicorn is used for launching django
      gunicorn \
# django
      Django \
# django-keycloak
      git+https://github.com/Peter-Slump/django-keycloak.git

COPY app/requirements.txt /
RUN pip install --prefix="/install" --no-warn-script-location -r /requirements.txt

###
# Main stage
###

ARG FROM
FROM ${FROM} as main

RUN apk add --no-cache \
      bash \
      ca-certificates

WORKDIR /opt

COPY --from=builder /install /usr/local

COPY app /opt/app

WORKDIR /opt/app

ENTRYPOINT [ "/opt/app/docker-entrypoint.sh" ]

CMD ["gunicorn", "-c /etc/app/config/gunicorn_config.py", "app.wsgi"]
