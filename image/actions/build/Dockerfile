FROM alpine:3.21

WORKDIR /host
ARG USER_ID
ARG USER_NAME
ARG GROUP_ID

RUN adduser -D -u ${USER_ID} -g ${GROUP_ID} -h /home/${USER_NAME} ${USER_NAME} \
    && chown -R ${USER_NAME}:${USER_NAME} /host \
    && apk upgrade --update-cache -a && apk add \
      docker \
      openrc && \
    rm -fr /var/cache/apk/* && \
    rc-update add docker boot && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel

USER ${USER_NAME}


