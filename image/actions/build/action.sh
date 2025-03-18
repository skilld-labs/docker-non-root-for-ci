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
