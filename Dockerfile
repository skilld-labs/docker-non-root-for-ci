# Inspired from https://gist.github.com/avishayp/33fcee06ee440524d21600e2e817b6b7
# Usage:
# $ docker build -t non-root:1.0.0 --build-arg GID=1000 --build-arg GNAME=docker --build-arg USER=non-root .
# $ docker run -i -t --rm -v $(pwd):/$(pwd) -w $(pwd) non-root:1.0.0 ash

FROM alpine

ARG GID=1000
ARG GNAME=defaultgroup
ARG USER=defaultuser

ENV HOME /home/$USER

# Install packages as root
RUN apk upgrade --no-cache -a
RUN apk update --no-cache --quiet
RUN apk add --no-cache --quiet sudo curl

# Add group
RUN addgroup -g $GID $GNAME
# Add new user
RUN adduser -D $USER -G $GNAME \
        && mkdir -p /etc/sudoers.d \
        && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
        && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME

# Files in /home/$USER to be owned by $USER
# Docker has --chown flag for COPY, but it does not expand ENV so we fallback to:
# COPY src src
# RUN sudo chown -R $USER:$USER $HOME

CMD echo "User $(whoami) running from $PWD with premissions: $(sudo -l)"

