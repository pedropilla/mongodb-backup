FROM alpine:latest
MAINTAINER Pedro Pilla <pedropilla@gmail.com>

# Optional Configuration Parameter
ARG SERVICE_USER
ARG SERVICE_HOME

# Default Settings
ENV SERVICE_USER ${SERVICE_USER:-mongo}
ENV SERVICE_HOME ${SERVICE_HOME:-/home/${SERVICE_USER}}

RUN \
  adduser -h ${SERVICE_HOME} -s /sbin/nologin -u 1000 -D ${SERVICE_USER} && \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/main' >> /etc/apk/repositories && \
  echo 'http://dl-cdn.alpinelinux.org/alpine/latest-stable/community' >> /etc/apk/repositories && \
  apk update && \
  apk add --no-cache dumb-init mongodb-tools && \
  mkdir /backup

ENV CRON_TIME="0 0 * * *"
ADD run.sh /run.sh
VOLUME ["/backup"]

CMD ["/run.sh"]
