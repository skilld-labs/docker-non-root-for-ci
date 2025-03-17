FROM alpine:3.21

RUN apk upgrade --update-cache -a && apk add \
    docker \
    openrc \
    git-cliff && \
    rm -fr /var/cache/apk/* && \
    rc-update add docker boot
