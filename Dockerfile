FROM ubuntu:20.04

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y python3.8 python3-pip python-dev curl wget


RUN set -ex && \
    mkdir ~/.gnupg; \
    echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf; \
    for key in \
    05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
    do \
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "$key" ; \
    done

ENV TELEGRAF_VERSION 1.19.3

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
    amd64) ARCH='amd64';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armhf';; \
    armel) ARCH='armel';; \
    *)     echo "Unsupported architecture: ${dpkgArch}"; exit 1;; \
    esac && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    gpg --batch --verify telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb.asc telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    dpkg -i telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb && \
    rm -f telegraf_${TELEGRAF_VERSION}-1_${ARCH}.deb*

EXPOSE 8125/udp 8092/udp 8094

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

RUN mkdir /root/.aws/

COPY credentials /root/.aws/credentials

COPY credentials /root/.aws/config

COPY entrypoint.sh /entrypoint.sh

COPY telegraf.conf /etc/telegraf/telegraf.conf

RUN chmod +x entrypoint.sh
CMD ["./entrypoint.sh"]