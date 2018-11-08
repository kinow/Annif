FROM alpine:3.7

RUN addgroup -S annif \
  && adduser -s /bin/sh -h /app -S -G annif annif

COPY . /app

RUN chown -R annif:annif /app
WORKDIR /app

RUN apk add --no-cache -U python3 \
  && apk add --no-cache --virtual .build-deps build-base gfortran python3-dev lapack-dev sudo \
  && pip3 install --no-cache-dir pipenv \
  && sudo -u annif pipenv install \
  && sudo -u annif pipenv run python -m nltk.downloader punkt \
  && apk del .build-deps \
  && rm -rf /app/.cache /tmp/* /var/tmp/*

USER annif
