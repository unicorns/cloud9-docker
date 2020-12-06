FROM ubuntu:focal-20201106

RUN apt-get update && apt-get install -y git vim curl wget ripgrep make build-essential python locales-all

WORKDIR /usr/src

RUN git clone https://github.com/c9/core.git c9sdk \
    && cd c9sdk \
    && ./scripts/install-sdk.sh

ENV PATH="${PATH}:~/.c9/bin:~/.c9/node/bin"

RUN mkdir -p /usr/src/ws
WORKDIR /usr/src/ws

EXPOSE 8181

ENTRYPOINT ["/root/.c9/node/bin/node","/usr/src/c9sdk/server.js","--listen","0.0.0.0","-a","testuser:pass","-w","/usr/src/ws","--collab"]
