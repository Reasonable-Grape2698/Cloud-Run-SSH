FROM python:3.7.17-alpine3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OPENSSH_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN apk add --no-cache build-base libffi-dev openssl-dev gcc
RUN pip install --upgrade pip
RUN pip install webssh

RUN apk add --no-cache --upgrade logrotate \
    nano \
    netcat-openbsd \
    sudo \
    curl \
    openssh-keygen \
    openrc \
    openssh-keygen && \
  echo "**** install openssh-server ****" && \
  if [ -z ${OPENSSH_RELEASE+x} ]; then \
    OPENSSH_RELEASE=$(curl -sL "http://dl-cdn.alpinelinux.org/alpine/v3.20/main/x86_64/APKINDEX.tar.gz" | tar -xz -C /tmp && \
    awk '/^P:openssh-server-pam$/,/V:/' /tmp/APKINDEX | sed -n 2p | sed 's/^V://'); \
  fi && \
  apk add --no-cache openssh && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** setup openssh environment ****" && \
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
  rc-update add sshd && \
  rm -rf \
    /tmp/* \
    $HOME/.cache && ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -b 521 -t ed25519 -C"$(id -un)@$(hostname)"
# add local files
COPY /root /
COPY /ssh /root/.ssh

EXPOSE 8080

VOLUME /config

RUN openrc && touch /run/openrc/softlevel
CMD ["sh", "-c", "rc-service sshd start && wssh --address=0.0.0.0 --port=8080"]
