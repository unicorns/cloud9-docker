FROM ubuntu:focal-20201106

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y git vim curl wget ripgrep make build-essential python locales-all

WORKDIR /usr/src

RUN git clone https://github.com/c9/core.git c9sdk \
    && cd c9sdk \
    && ./scripts/install-sdk.sh

ENV PATH="${PATH}:~/.c9/bin:~/.c9/node/bin"

# Ruby, Python3
RUN apt-get update && apt-get -y install ruby ruby-dev zlib1g-dev python3 python3-pip

# Java
RUN apt-get update && apt-get -y install openjdk-11-jdk maven gradle

# C/C++
# public LLVM PPA, development version of LLVM
RUN wget --quiet -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main" > /etc/apt/sources.list.d/llvm.list && \
    apt-get update && \
    apt-get install -y \
                       clang-tools \
                       clangd \
                       clang-tidy \
                       gcc-multilib \
                       g++-multilib \
                       gdb

# Install latest stable CMake
ARG CMAKE_VERSION=3.18.1

RUN wget --quiet "https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-Linux-x86_64.sh" && \
    chmod a+x cmake-$CMAKE_VERSION-Linux-x86_64.sh && \
    ./cmake-$CMAKE_VERSION-Linux-x86_64.sh --prefix=/usr/ --skip-license && \
    rm cmake-$CMAKE_VERSION-Linux-x86_64.sh

RUN mkdir -p /usr/src/ws
WORKDIR /usr/src/ws

EXPOSE 8181

ENTRYPOINT ["/root/.c9/node/bin/node","/usr/src/c9sdk/server.js","--listen","0.0.0.0","-a","testuser:pass","-w","/usr/src/ws","--collab"]
