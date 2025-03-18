# action.sh

```sh
#!/bin/sh
whoami
id
docker build --help
service docker status || true
service containerd status || true
service docker start
service containerd start || true
service docker status || true
service containerd status || true
docker --version
export VERSION=111.111
docker build -t skilldlabs/docker-non-root-for-ci:${VERSION}-r --build-arg ALPINE_VERSION=${VERSION} --build-arg GID=233 --build-arg GNAME=docker --build-arg UNAME=skilld .

```

# action.yaml

```yaml
working_directory: "{{ .current_working_dir }}"
action:
  title: Build
  description: Create new docker image from local files

runtime:
  type: container
  image: image-actions-build:latest
  build:
    context: ./
    args:
      USER_ID: {{ .current_uid }}
      GROUP_ID: {{ .current_gid }}
      USER_NAME: plasma
  command:
    - /bin/sh
    - /action/action.sh


```

# Dockerfile

```
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



```

