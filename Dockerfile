# Inspired from https://gist.github.com/avishayp/33fcee06ee440524d21600e2e817b6b7
# Usage:
# $ docker build -t non-root:1.0.0 --build-arg GID=1000 --build-arg GNAME=docker --build-arg USER=non-root .
# $ docker run -i -t --rm -v $(pwd):/$(pwd) -w $(pwd) non-root:1.0.0 ash

FROM alpine

ARG GID=1000
ENV GID=$GID
ARG GNAME=defaultgroup
ENV GNAME=$GNAME
ARG UNAME=defaultuser
ENV UNAME=$UNAME

# Install packages as root
RUN set -x &&\
    apk add --update --upgrade curl doas doas-sudo-shim &&\
    apk upgrade &&\
    rm -fr /var/cache/apk/* &&\
# Add group
    addgroup -g $GID $GNAME &&\
# Add new user
    adduser -G $GNAME -D $UNAME &&\
# Allow $UNAME to sudo/doas as root
    echo "permit nopass $UNAME" >> /etc/doas.d/$UNAME.conf &&\
    echo "permit nopass 0" >> /etc/doas.d/root.conf

USER $UNAME
WORKDIR /home/$UNAME

# Files in /home/$UNAME to be owned by $UNAME
# COPY src src
# RUN sudo chown -R $UNAME:$GNAME /home/$UNAME

CMD echo "User $(whoami) running from $PWD with premissions: $(doas env)"

