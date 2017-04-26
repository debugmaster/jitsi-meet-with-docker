FROM ubuntu:latest
MAINTAINER camilo@camilo.fm

ENV TERM=xterm

# Installing dependencies
RUN apt-get update && \
    apt-get upgrade -y
RUN apt-get install git make lua5.1 luarocks \
	liblua5.1-dev libidn11-dev libssl-dev libexpat-dev -y
RUN luarocks install luasocket && \
    luarocks install luaexpat && \
    luarocks install luafilesystem && \
    luarocks install luasec && \
    luarocks install luabitop

RUN mkdir -p /etc/prosody/ /var/lib/prosody /var/log/prosody /var/run/prosody && \
    useradd -d /etc/prosody -s /sbin/nologin prosody && \
    chown -R prosody:prosody /etc/prosody/ /var/lib/prosody /var/log/prosody /var/run/prosody

# Downloading and installing Prosody
ARG RELEASE
ARG REPOSITORY
RUN git clone --depth=1 --branch $RELEASE $REPOSITORY /root/prosody
RUN cd /root/prosody/ && \
    ./configure --ostype=debian --prefix= --require-config && \
    make && \
    make install && \
    rm /root/prosody/ -r && ls /root

USER prosody
WORKDIR /etc/prosody

CMD prosody
