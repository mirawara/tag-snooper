FROM alpine:latest

RUN apk add --no-cache --upgrade bash curl busybox-extras inotify-tools mutt grep

WORKDIR /opt/tagsnooper

COPY scripts/ /opt/tagsnooper/bin/
COPY conf/crontabfile /etc/crontabs/root
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod -R +x /opt/tagsnooper/bin/ 

CMD [ "/docker-entrypoint.sh" ]
