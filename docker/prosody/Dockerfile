FROM ubuntu:latest
MAINTAINER camilo@camilo.fm

ENV TERM=xterm

ARG RELEASE
ARG REPOSITORY
ARG SHOULD_BUILD

# Installing dependencies
RUN apt-get update && \
    apt-get upgrade -y
RUN echo $SHOULD_BUILD && [ $SHOULD_BUILD = true ] && apt-get install prosody -y || \
    apt-get install git make lua5.1 luarocks \
	liblua5.1-dev libidn11-dev libssl-dev libexpat-dev libevent-dev -y && \
    luarocks install luasocket && \
    luarocks install luaexpat && \
    luarocks install luafilesystem && \
    luarocks install luasec && \
    luarocks install luabitop && \
    luarocks install luaevent && \

    mkdir -p /etc/prosody/ /var/lib/prosody /var/log/prosody /var/run/prosody && \
    useradd -d /etc/prosody -s /sbin/nologin prosody && \
    chown -R prosody:prosody /etc/prosody/ /var/lib/prosody /var/log/prosody /var/run/prosody && \

    # Downloading and installing Prosody
    git clone --depth=1 --branch $RELEASE $REPOSITORY /root/prosody && \
    cd /root/prosody/ && \
    ./configure --ostype=debian --prefix= --require-config && \
    make && \
    make install && \
    rm /root/prosody/ -rf

RUN apt-get remove git make -y && \
    apt-get autoremove -y && \
    apt-get clean

USER prosody
WORKDIR /etc/prosody

CMD prosody
